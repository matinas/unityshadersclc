Shader "Custom/DiffuseSpecularNormalMapDetailWBShader" {

	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Albedo", 2D) = "white" {}
		_DetailTex("Detail Texture", 2D) = "white" {}
		[NoScaleOffset] _NormalMap ("Normal Map", 2D) = "gray" {}
		[NoScaleOffset] _DetailNormalMap ("Detail Normals", 2D) = "bump" {}
		_Shininness("Shininness",Range(0,1)) = 0.5
		_SpecularTint ("Specular", Color) = (0.5, 0.5, 0.5)
		_BumpScale ("Bump Scale", Float) = 1
		_DetailBumpScale ("Detail Bump Scale", Float) = 1
		
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

			float4 _Tint, _SpecularTint;
			sampler2D _MainTex, _DetailTex;
			sampler2D _NormalMap, _DetailNormalMap;
			float4 _NormalMap_TexelSize;
			float4 _MainTex_ST, _DetailTex_ST;
			float _Shininness, _BumpScale, _DetailBumpScale;

			struct VertexData
			{
				float4 position : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct Interpolators
			{
				float4 position : SV_POSITION;
				float4 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float3 worldPosition : TEXCOORD2;
			};

			Interpolators MyVertexProgram (VertexData v)
			{
				Interpolators i;
				i.position = mul(UNITY_MATRIX_MVP, v.position);
				i.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
				i.uv.zw = TRANSFORM_TEX(v.uv, _DetailTex);
				i.worldPosition = mul(unity_ObjectToWorld, v.position);

				return i;
			}

			// Same as before for adding main and detail normals by means of their partial derivatives,
			// but now applying Whiteout Blending to get more pronounced bumps along steep slopes

			void InitializeFragmentNormal(inout Interpolators i)
			{
				float3 main_normal = UnpackScaleNormal(tex2D(_NormalMap, i.uv.xy), _BumpScale);
				float3 detail_normal = UnpackScaleNormal(tex2D(_DetailNormalMap, i.uv.zw), _DetailBumpScale);

				// i.normal = float3(main_normal.xy + detail_normal.xy, main_normal.z * detail_normal.z);	// Even better than previous method apply Whiteout Blending
																											// This exaggerates X and Y, produces better bumps along steep slopes

				i.normal = BlendNormals(main_normal, detail_normal); // BlendNormals function uses whiteout blending (and already includes normalization)
				i.normal = normalize(i.normal.xzy);
			}

			float4 MyFragmentProgram (Interpolators i) : SV_TARGET
			{
				InitializeFragmentNormal(i);

				float3 light_dir = _WorldSpaceLightPos0.xyz;
				float3 reflection_dir = reflect(-light_dir, i.normal); // Takes the direction of an incoming light ray and reflects it based on a surface normal
				float3 view_dir = normalize(_WorldSpaceCameraPos - i.worldPosition);
				float3 half_vec = normalize(view_dir + light_dir);

				float3 lightColor = _LightColor0.rgb;
				float3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Tint.rgb;
				albedo *= tex2D(_DetailTex, i.uv.zw)*unity_ColorSpaceDouble;
				
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