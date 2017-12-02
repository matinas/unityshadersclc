Shader "Custom/DiffuseSpecularNormalMapTangentShader" {

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

			#include "20.1 Diffuse Specular Normal Map Tangent.cginc"

			ENDCG
		}

		Pass {

			Tags
			{
				"LightMode" = "ShadowCaster"
			}

			CGPROGRAM

			#pragma target 3.0

			#pragma vertex MyShadowVertexProgram
			#pragma fragment MyShadowFragmentProgram

			#include "20.2 Shadow Caster.cginc"

			ENDCG
		}
	}
}