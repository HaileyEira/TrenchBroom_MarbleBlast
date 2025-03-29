//*****************************************************************************
// TSE -- HLSL procedural shader                                               
//*****************************************************************************
//-----------------------------------------------------------------------------
// Structures                                                                  
//-----------------------------------------------------------------------------
struct VertData
{
   float2 texCoord        : TEXCOORD0;
   float2 lmCoord         : TEXCOORD1;
   float3 T               : TEXCOORD2;
   float3 B               : TEXCOORD3;
   float3 N               : TEXCOORD4;
   float3 normal          : NORMAL;
   float4 position        : POSITION;
};


struct ConnectData
{
   float4 hpos            : POSITION;
   float4 shading         : COLOR;
   float2 outTexCoord     : TEXCOORD0;
   float3 outNormal       : TEXCOORD1;
   float3 pos             : TEXCOORD2;
   float3 outEyePos       : TEXCOORD3;
   float4 outLightVec     : TEXCOORD4;
};


//-----------------------------------------------------------------------------
// Main                                                                        
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float4x4 modelview       : register(C0),
                  uniform float4   inLightColor    : register(C25),
                  uniform float3   inLightVec      : register(C24),
                  uniform float3   eyePos          : register(C20)
)
{
   ConnectData OUT;

   OUT.hpos = mul(modelview, IN.position);
   OUT.shading = saturate( dot(-inLightVec, IN.normal) );
   OUT.shading.w = 1.0;
   OUT.shading *= inLightColor;
   OUT.outTexCoord = IN.texCoord;

   OUT.outNormal = IN.normal;
   OUT.pos = IN.position.xyz;
   OUT.outEyePos.xyz = eyePos.xyz;
   OUT.outLightVec.xyz = -inLightVec;
   OUT.outLightVec.w = step( -0.5, dot( -inLightVec, IN.normal ) );   return OUT;
}
