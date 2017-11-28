// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/WorldPositionShader" {

	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
	}

	SubShader {

		Pass {
			CGPROGRAM

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"

			float4 _Tint;

			struct Interpolators
			{
				float4 position : SV_POSITION;
				float3 worldPosition : TEXCOORD0;
			};

			Interpolators MyVertexProgram (float4 position : POSITION)
			{
				Interpolators i;
				i.worldPosition = mul(unity_ObjectToWorld,position);
				i.position = mul(UNITY_MATRIX_MVP, position);
				
				return i;
			}

			float4 MyFragmentProgram (Interpolators i) : SV_TARGET
			{
				return float4((i.worldPosition/5.0) + 0.5, 1);
			}

			ENDCG
		}
	}
}