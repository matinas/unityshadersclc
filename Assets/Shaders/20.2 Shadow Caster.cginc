#if !defined(SHADOW_CASTER_INCLUDE)
#define SHADOW_CASTER_INCLUDE

#include "UnityCG.cginc"

float4 MyShadowVertexProgram (float4 position : POSITION, float4 normal : NORMAL) : SV_POSITION
{
	float4 pos = UnityClipSpaceShadowCasterPos(position.xyz, normal); // Support shadows normal bias

	return UnityApplyLinearShadowBias(pos); // Support shadows depth bias
}

half4 MyShadowFragmentProgram () : SV_TARGET
{
	return 0;
}

#endif