Shader "Custom/DiffuseShader" {

	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Albedo", 2D) = "white" {}
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

			float4 _Tint;
			sampler2D _MainTex;
			float4 _MainTex_ST;

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
			};

			Interpolators MyVertexProgram (VertexData v)
			{
				Interpolators i;
				i.position = mul(UNITY_MATRIX_MVP, v.position);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);

				i.normal = UnityObjectToWorldNormal(v.normal);
				i.normal = normalize(i.normal);
				
				return i;
			}

			float4 MyFragmentProgram (Interpolators i) : SV_TARGET
			{
				i.normal = normalize(i.normal); // We renormalize, as linearly interpolating between different unit-length vectors does not result
												// in another unit-length vector. It will be shorter. The error is usually very small though (not done in mobile)

				float3 light_dir = _WorldSpaceLightPos0.xyz;
				float3 lightColor = _LightColor0.rgb;
				float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;

				//float4 diffuse = max(0,dot(light_dir, i.normal));
				float3 diffuse = albedo * lightColor * DotClamped(light_dir, i.normal); // Same as above line

				return float4(diffuse,1);
			}

			ENDCG
		}
	}
}