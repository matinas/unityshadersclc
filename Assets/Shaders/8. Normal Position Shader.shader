Shader "Custom/NormalPositionShader" {

	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D) = "white" {}
	}

	SubShader {

		Pass {
			CGPROGRAM

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"

			float4 _Tint;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct VertexData
			{
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
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
				//i.normal = v.normal; 													// Normal in Object Space
				//i.normal = mul(unity_ObjectToWorld, float4(v.normal, 0)); 			// Normal in World Space, messed by scalings though
				//i.normal = mul(transpose(unity_WorldToObject), float4(v.normal, 0)); 	// Normal in World Space, correctly calculated
				i.normal = UnityObjectToWorldNormal(v.normal);							// Same as above line
				i.normal = normalize(i.normal);
				
				return i;
			}

			float4 MyFragmentProgram (Interpolators i) : SV_TARGET
			{
				i.normal = normalize(i.normal); // We renormalize, as linearly interpolating between different unit-length vectors does not result
												// in another unit-length vector. It will be shorter. The error is usually very small though (not done in mobile)

				return float4(i.normal * 0.5 + 0.5, 1) * _Tint;
			}

			ENDCG
		}
	}
}