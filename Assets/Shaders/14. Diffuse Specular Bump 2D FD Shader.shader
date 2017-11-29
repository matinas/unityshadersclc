Shader "Custom/DiffuseSpecularBump2DFDShader" {

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
				// We use the Finite Difference (FD) method to calculate the tangents (sample current texel and the texel to the right)

				float2 du = float2(_HeightMap_TexelSize.x, 0);
				float u1 = tex2D(_HeightMap, i.uv);
				float u2 = tex2D(_HeightMap, i.uv+du);
				float3 tanu = float3(1,(u2-u1)*_BumpScale,0);

				float2 dv = float2(0, _HeightMap_TexelSize.y);
				float v1 = tex2D(_HeightMap, i.uv);
				float v2 = tex2D(_HeightMap, i.uv+dv);
				float3 tanv = float3(0,(v2-v1)*_BumpScale,1);

				i.normal = cross(tanv,tanu);
				// i.normal = float3((u1-u2)*_BumpScale, 1, (v1-v2)*_BumpScale); // Same as above. Dot product calculated manually with the algebraic formula

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