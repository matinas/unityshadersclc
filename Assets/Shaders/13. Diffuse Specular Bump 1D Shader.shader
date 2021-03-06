﻿Shader "Custom/DiffuseSpecularBump1DShader" {

	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Albedo", 2D) = "white" {}
		[NoScaleOffset] _HeightMap ("Heights", 2D) = "gray" {}
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

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"
			#include "UnityStandardBRDF.cginc"
			#include "UnityStandardUtils.cginc"

			float4 _Tint;
			float4 _SpecularTint;
			sampler2D _MainTex;
			sampler2D _HeightMap;
			float4 _HeightMap_TexelSize;
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

				i.normal = UnityObjectToWorldNormal(v.normal);
				i.normal = normalize(i.normal);
				
				return i;
			}

			void InitializeFragmentNormal(inout Interpolators i)
			{
				// float h = tex2D(_HeightMap, i.uv);
				// i.normal = float3(0, h, 0);
				
				float2 delta = float2(_HeightMap_TexelSize.x, 0);;
				float h1 = tex2D(_HeightMap, i.uv);
				float h2 = tex2D(_HeightMap, i.uv+delta);
				float3 tangent = float3(1,(h2-h1)*_BumpScale,0);

				i.normal = float3(-tangent.y,tangent.x,tangent.z); // Turn the tangent into an upward-pointing normal vector by rotating it -90 around Z
				
				i.normal = normalize(i.normal); // We renormalize, as linearly interpolating between different unit-length vectors does not result
												// in another unit-length vector. It will be shorter. The error is usually very small though (not done in mobile)
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