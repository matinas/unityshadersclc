Shader "Custom/SpecularMetallicShader" {

	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Albedo", 2D) = "white" {}
		_Shininness("Shininness",Range(0,1)) = 0.5
		[Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
	}

	SubShader {

		Pass {

			Tags
			{
				"LightMode" = "ForwardBase"
			}

			CGPROGRAM

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"
			#include "UnityStandardBRDF.cginc"
			#include "UnityStandardUtils.cginc"

			float4 _Tint;
			float4 _SpecularTint;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Shininness;
			float _Metallic;

			struct VertexData
			{
				float4 position : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct Interpolators
			{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float3 worldPosition : TEXCOORD2;
			};

			Interpolators MyVertexProgram (VertexData v)
			{
				Interpolators i;
				i.position = mul(UNITY_MATRIX_MVP, v.position);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.worldPosition = mul(unity_ObjectToWorld, v.position);

				i.normal = UnityObjectToWorldNormal(v.normal);
				i.normal = normalize(i.normal);
				
				return i;
			}

			float4 MyFragmentProgram (Interpolators i) : SV_TARGET
			{
				i.normal = normalize(i.normal); // We renormalize, as linearly interpolating between different unit-length vectors does not result
												// in another unit-length vector. It will be shorter. The error is usually very small though (not done in mobile)

				float3 light_dir = _WorldSpaceLightPos0.xyz;
				float3 view_dir = normalize(_WorldSpaceCameraPos - i.worldPosition);
				float3 reflection_dir = reflect(-light_dir, i.normal); // Takes the direction of an incoming light ray and reflects it based on a surface normal
				float3 half_vec = normalize(view_dir + light_dir);

				float3 lightColor = _LightColor0.rgb;
				float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;

				// float3 specularTint = albedo * _Metallic;
				// float oneMinusReflectivity = 1 - _Metallic;
				// albedo *= oneMinusReflectivity;

				float3 specularTint;
				float oneMinusReflectivity;
				albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, specularTint, oneMinusReflectivity); // Same as commented lines above with few color corrections
																												// so we have a bit specular even when the object is full nonmetal

				float3 diffuse = albedo * lightColor * DotClamped(light_dir, i.normal);
				float3 specular = specularTint * lightColor * pow(DotClamped(half_vec, i.normal),_Shininness*100);

				return float4(diffuse + specular,1);
			}

			ENDCG
		}
	}
}