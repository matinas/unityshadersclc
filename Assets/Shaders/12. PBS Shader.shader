Shader "Custom/PBSShader" {

	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Albedo", 2D) = "white" {}
		_Shininness("Shininness",Range(0,1)) = 0.5
		[Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
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
			#include "UnityPBSLighting.cginc"

			float4 _Tint;
			float4 _SpecularTint;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Shininness;
			float _Metallic;

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

			// Note that we are only supporting Directional Lights to this point
			// TODO: add support to more light types following Multiple Lights tutorial: http://catlikecoding.com/unity/tutorials/rendering/part-5/
			// TODO: once we have this done add this new light types to the shaders with bumpmapping and shadow support

			float4 MyFragmentProgram (Interpolators i) : SV_TARGET
			{
				i.normal = normalize(i.normal); // We renormalize, as linearly interpolating between different unit-length vectors does not result
												// in another unit-length vector. It will be shorter. The error is usually very small though (not done in mobile)

				float3 light_dir = _WorldSpaceLightPos0.xyz;
				float3 view_dir = normalize(_WorldSpaceCameraPos - i.worldPosition);
				float3 light_color = _LightColor0.rgb;
				float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;

				UnityLight light;
				light.color = light_color;
				light.dir = light_dir;
				light.ndotl = DotClamped(i.normal, light_dir);

				UnityIndirect indirectLight;
				indirectLight.diffuse = 0;
				indirectLight.specular = 0;

				float3 specularTint;
				float oneMinusReflectivity;
				albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, specularTint, oneMinusReflectivity);

				return UNITY_BRDF_PBS(albedo, specularTint, oneMinusReflectivity, _Shininness, i.normal, view_dir, light, indirectLight);
			}

			ENDCG
		}
	}
}