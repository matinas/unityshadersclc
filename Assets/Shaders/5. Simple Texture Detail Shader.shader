// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/SimpleTextureDetailShader" {

	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Texture", 2D) = "white" {}
		_DetailTex("Detail exture", 2D) = "white" {}
	}

	SubShader {

		Pass {
			CGPROGRAM

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"

			float4 _Tint;
			sampler2D _MainTex;
			sampler2D _DetailTex;
			float4 _MainTex_ST;
			float4 _DetailTex_ST;

			struct Interpolators
			{
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uv_detail : TEXCOORD1;
			};

			struct VertexData {
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			Interpolators MyVertexProgram (VertexData v)
			{
				Interpolators i;
				i.position = mul(UNITY_MATRIX_MVP, v.position);
				i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw; 				// Tilling and offset (alternative: TRANSFORM_TEX(v.uv, _MainTex))
				i.uv_detail = v.uv * _DetailTex_ST.xy + _DetailTex_ST.zw;	// Tilling and offset (alternative: TRANSFORM_TEX(v.uv, _DetailTex_ST))
				
				return i;
			}

			float4 MyFragmentProgram (Interpolators i) : SV_TARGET
			{
				float4 color = tex2D(_MainTex,i.uv);
				color *= tex2D(_DetailTex,i.uv_detail)*2;
				
				return color * _Tint;
			}

			ENDCG
		}
	}
}