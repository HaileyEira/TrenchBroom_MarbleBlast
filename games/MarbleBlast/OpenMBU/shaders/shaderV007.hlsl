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
   float3 reflectVec      : TEXCOORD1;
};


//-----------------------------------------------------------------------------
// Main                                                                        
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float4x4 modelview       : register(C0),
                  uniform float4   inLightColor    : register(C25),
                  uniform float3   inLightVec      : register(C24),
                  uniform float3x3 cubeTrans       : register(C16),
                  uniform float3   cubeEyePos      : register(C19)
)
{
   ConnectData OUT;

   OUT.hpos = mul(modelview, IN.position);
   OUT.shading = saturate( dot(-inLightVec, IN.normal) );
   OUT.shading.w = 1.0;
   OUT.shading *= inLightColor;
   OUT.outTexCoord = IN.texCoord;
   float3 cubeVertPos = mul(cubeTrans, IN.position).xyz;
   float3 cubeNormal = normalize( mul(cubeTrans, IN.normal).xyz );
   float3 eyeToVert = cubeVertPos - cubeEyePos;
   OUT.reflectVec = reflect(eyeToVert, cubeNormal);
   return OUT;
}
