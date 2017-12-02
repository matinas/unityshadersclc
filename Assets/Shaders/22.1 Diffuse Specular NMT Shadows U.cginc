#if !defined(DIFFUSE_SPECULAR_NMTFSU_INCLUDED)
#define DIFFUSE_SPECULAR_NMTFSU_INCLUDED

#define BINORMAL_PER_FRAGMENT

#include "UnityCG.cginc"
#include "UnityStandardBRDF.cginc"
#include "UnityStandardUtils.cginc"
#include "AutoLight.cginc"

float4 _Tint;
float4 _SpecularTint;
sampler2D _MainTex;
sampler2D _NormalMap;
float4 _NormalMap_TexelSize;
float4 _MainTex_ST;
float _Shininness;
float _BumpScale;

// Almost the same logic as 21.1 (we are receiving shadows from a shadow map) but in this
// case we use the Unity predefined functions and macros to avoid manually sampling shadow maps

struct VertexData
{
	float4 vertex : POSITION;
	float3 normal : NORMAL;
	float4 tangent : TANGENT;
	float2 uv : TEXCOORD0;
};

struct Interpolators
{
	float4 pos : SV_POSITION;
	float2 uv : TEXCOORD0;
	float3 normal : TEXCOORD1;
	float3 worldPosition : TEXCOORD2;

	#if defined(BINORMAL_PER_FRAGMENT)
		float4 tangent : TEXCOORD3;
	#else
		float3 tangent : TEXCOORD3;
		float3 binormal : TEXCOORD4;
	#endif

	SHADOW_COORDS(5)
};

float3 CreateBinormal (float3 normal, float3 tangent, float binormal_sign)
{
	return cross(normal, tangent.xyz) * (binormal_sign * unity_WorldTransformParams.w);	// The unity_WorldTransformParams takes into account the negation
																						// of the binormal when an odd number of dimensions are negative
}

Interpolators MyVertexProgram (VertexData v)
{
	Interpolators i;
	i.pos = mul(UNITY_MATRIX_MVP, v.vertex);
	i.uv = TRANSFORM_TEX(v.uv, _MainTex);
	i.worldPosition = mul(unity_ObjectToWorld, v.vertex);
	i.normal = UnityObjectToWorldNormal(v.normal);

	#if defined(BINORMAL_PER_FRAGMENT)
		i.tangent = float4(UnityObjectToWorldDir(v.tangent.xyz),v.tangent.w); // W component needs to be passed along unmodified as it stores the binormal sign
	#else
		i.tangent = UnityObjectToWorldDir(v.tangent.xyz);
		i.binormal = CreateBinormal(i.normal, v.tangent.xyz, v.tangent.w);
	#endif

	// If we wanted to use a Unity function to fill the shadow coords instead of the TRANSFER_SHADOW macro...
	// #if defined(SHADOWS_SCREEN)
	// 	i.shadowCoords = ComputeScreenPos(i.vertex);
	// #endif

	TRANSFER_SHADOW(i);

	return i;
}

// In this shader we calculate the binormal in a per-fragment basis (check shader #20 to the per-vertex shader version)

void InitializeFragmentNormal(inout Interpolators i)
{
	float3 tangent_space_normal = UnpackScaleNormal(tex2D(_NormalMap, i.uv), _BumpScale);
	tangent_space_normal = tangent_space_normal.xzy; 		// Swap Y and Z
	tangent_space_normal = normalize(tangent_space_normal); // And normalize to obtain decoded DXT5nm normals

	#if defined(BINORMAL_PER_FRAGMENT)
		float3 binormal = CreateBinormal(i.normal, i.tangent.xyz, i.tangent.w);
	#else
		float3 binormal = i.binormal;
	#endif

	binormal = normalize(binormal);

	// Convert the bumped normal from tangent space to world space
	i.normal = tangent_space_normal.x*i.tangent + tangent_space_normal.y*i.normal + tangent_space_normal.z*binormal;
	i.normal = normalize(i.normal.xyz);
}

float4 MyFragmentProgram (Interpolators i) : SV_TARGET
{
	InitializeFragmentNormal(i);

	#if defined(SHADOWS_SCREEN)
		float attenuation = SHADOW_ATTENUATION(i);
	#else
		UNITY_LIGHT_ATTENUATION(attenuation, 0, i.worldPosition); // Actually this already uses SHADOW_ATTENUATION when needed so we can call just this macro one if we want
																  // The only change is that we have to use the interpolator i as its second argument instead of 0
	#endif

	float3 light_dir = _WorldSpaceLightPos0.xyz;
	float3 reflection_dir = reflect(-light_dir, i.normal); // Takes the direction of an incoming light ray and reflects it based on a surface normal
	float3 view_dir = normalize(_WorldSpaceCameraPos - i.worldPosition);
	float3 half_vec = normalize(view_dir + light_dir);

	float3 lightColor = _LightColor0.rgb;
	float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
	
	float oneMinusReflectivity;
	albedo = EnergyConservationBetweenDiffuseAndSpecular(albedo, _SpecularTint.rgb, oneMinusReflectivity);

	float3 diffuse = albedo * lightColor * attenuation * DotClamped(light_dir, i.normal);
	float3 specular = _SpecularTint.rgb * lightColor * pow(DotClamped(half_vec, i.normal),_Shininness*100);

	return float4(diffuse + specular,1);
}

#endif