Shader "Custom/DiffuseSpecularNormalMapShader" {

	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Albedo", 2D) = "white" {}
		[NoScaleOffset] _NormalMap ("Normal Map", 2D) = "gray" {}
		_Shininness("Shininness",Range(0,1)) = 0.5
		_SpecularTint ("Specular", Color) = (0.5, 0.5, 0.5)
		_BumpScale ("Bump Scale", Float) = 1
	}

	SubShader {

		Pass {

			Tags
			{
				"LightMode" = "ForwardBase"
			}

			CGPROGRAM

			#pragma target 3.0

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"
			#include "UnityStandardBRDF.cginc"
			#include "UnityStandardUtils.cginc"

			float4 _Tint;
			float4 _SpecularTint;
			sampler2D _MainTex;
			sampler2D _NormalMap;
			float4 _NormalMap_TexelSize;
			float4 _MainTex_ST;
			float _Shininness;
			float _BumpScale;

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

				return i;
			}

			void InitializeFragmentNormal(inout Interpolators i)
			{
				// i.normal.xy = tex2D(_NormalMap, i.uv).wy * 2 - 1; 				// Convert the normals back to their original [−1,1] range, by computing 2*N-1
				// i.normal.xy *= _BumpScale;
				// i.normal.z = sqrt(1 - saturate(dot(i.normal.xy, i.normal.xy)));	// Taking into account that they are stored in DXT5nm format...

				i.normal = UnpackScaleNormal(tex2D(_NormalMap, i.uv), _BumpScale); 	// Same as all the above (be sure to set rendertarget >= 3 to scale bump properly)
				i.normal = normalize(i.normal.xzy);									// Swap Y and Z and normalize to obtain decoded DXT5nm normals
			}

			float4 MyFragmentProgram (Interpolators i) : SV_TARGET
			{
				InitializeFragmentNormal(i);

				float3 light_dir = _WorldSpaceLightPos0.xyz;
				float3 reflection_dir = reflect(-light_dir, i.normal); // Takes the direction of an incoming light ray and reflects it based on a surface normal
				float3 view_dir = normalize(_WorldSpaceCameraPos - i.worldPosition);
				float3 half_vec = normalize(view_dir + light_dir);

				float3 lightColor = _LightColor0.rgb;
				float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
				
				float oneMinusReflectivity;
				albedo = EnergyConservationBetweenDiffuseAndSpecular(albedo, _SpecularTint.rgb, oneMinusReflectivity);

				float3 diffuse = albedo * lightColor * DotClamped(light_dir, i.normal);

				float3 specular = _SpecularTint.rgb * lightColor * pow(DotClamped(half_vec, i.normal),_Shininness*100);

				return float4(diffuse + specular,1);
			}

			ENDCG
		}
	}
}