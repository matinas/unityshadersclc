Shader "Custom/DiffuseSpecularNMTFullShadowShader" {

	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Albedo", 2D) = "white" {}
		[NoScaleOffset] _NormalMap ("Normal Map", 2D) = "gray" {}
		_Shininness("Shininness",Range(0,1)) = 0.5
		_SpecularTint ("Specular", Color) = (0.5, 0.5, 0.5)
		_BumpScale ("Bump Scale", Float) = 1
	}

// In contrast to DiffuseSpecularNMTShadowCasterShader, this shader can casts shadows from two lights (generate a
// shadow map for each one) and also receive shadows casted by other objects (sample shadow map for each light)
// Logic for the different passes are included in 22.1 (shadow receiving) and 20.2 (shadow casting) include files
// Note that we are only supporting Directional Lights to this point, as 21.1 is based on 10 which only supports those

	SubShader {

		Pass {

			Tags
			{
				"LightMode" = "ForwardBase"
			}

			CGPROGRAM

			#pragma target 3.0
			#pragma multi_compile _ SHADOWS_SCREEN

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "21.1 Diffuse Specular NMT Shadows.cginc"

			ENDCG
		}

		// We also take the chance to support multiple lights and so multiple light shadows by
		// adding a new pass for each additional light (just one extra directional light for now)

		Pass {
			Tags {
				"LightMode" = "ForwardAdd"
			}

			Blend One One
			ZWrite Off

			CGPROGRAM

			#pragma target 3.0

			#pragma multi_compile _ SHADOWS_SCREEN

			//#pragma multi_compile_fwdadd_fullshadows // Use this instead to support other types of lights (point, spotlights, etc)
			
			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "21.1 Diffuse Specular NMT Shadows.cginc"

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