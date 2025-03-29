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
   float4 outLightVec     : TEXCOORD1;
   float3 reflectVec      : TEXCOORD2;
   float3 pos             : TEXCOORD3;
   float3 outEyePos       : TEXCOORD4;
};


//-----------------------------------------------------------------------------
// Main                                                                        
//-----------------------------------------------------------------------------
ConnectData main( VertData IN,
                  uniform float4x4 modelview       : register(C0),
                  uniform float4   inLightColor    : register(C25),
                  uniform float3   inLightVec      : register(C24),
                  uniform float3x3 cubeTrans       : register(C16),
                  uniform float3   cubeEyePos      : register(C19),
                  uniform float3   eyePos          : register(C20)
)
{
   ConnectData OUT;

   OUT.hpos = mul(modelview, IN.position);
   OUT.shading = inLightColor;
   OUT.outTexCoord = IN.texCoord;

   float3x3 objToTangentSpace;
   objToTangentSpace[0] = IN.T;
   objToTangentSpace[1] = IN.B;
   objToTangentSpace[2] = IN.N;

   OUT.outLightVec.xyz = -inLightVec;
   OUT.outLightVec.xyz = mul(objToTangentSpace, OUT.outLightVec);
   float3 cubeVertPos = mul(cubeTrans, IN.position).xyz;
   float3 cubeNormal = normalize( mul(cubeTrans, IN.normal).xyz );
   float3 eyeToVert = cubeVertPos - cubeEyePos;
   OUT.reflectVec = reflect(eyeToVert, cubeNormal);
   OUT.pos = mul(objToTangentSpace, IN.position.xyz / 100.0);;
   OUT.outEyePos.xyz = mul(objToTangentSpace, eyePos.xyz / 100.0);;
   OUT.outLightVec.w = step( -0.5, dot( -inLightVec, IN.normal ) );   return OUT;
}
