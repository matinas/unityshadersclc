// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/BinaryTextureSplattingShader" {

	Properties {
		_MainTex("Splat Map", 2D) = "white" {}
		[NoScaleOffset] _Texture1 ("Texture 1", 2D) = "white" {}
		[NoScaleOffset] _Texture2 ("Texture 2", 2D) = "white" {}
	}

	SubShader {

		Pass {
			CGPROGRAM

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _Texture1;
			sampler2D _Texture2;

			struct Interpolators
			{
				float4 position : SV_POSITION;
				float2 uv_splat : TEXCOORD0;
				float2 uv_tex : TEXCOORD1;
			};

			struct VertexData
			{
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			Interpolators MyVertexProgram (VertexData v)
			{
				Interpolators i;
				i.position = mul(UNITY_MATRIX_MVP, v.position);
				i.uv_splat = v.uv;
				i.uv_tex = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;	// Tilling and offset (alternative: TRANSFORM_TEX(v.uv, _MainTex_ST))
				
				return i;
			}

			float4 MyFragmentProgram (Interpolators i) : SV_TARGET
			{
				float4 splat = tex2D(_MainTex,i.uv_splat);
				float4 color = tex2D(_Texture1,i.uv_tex) * splat.r +
							   tex2D(_Texture2,i.uv_tex) * (1 - splat.r);
				
				return color;
			}

			ENDCG
		}
	}
}