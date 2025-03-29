//*****************************************************************************
// TSE -- HLSL procedural shader                                               
//*****************************************************************************
//-----------------------------------------------------------------------------
// Structures                                                                  
//-----------------------------------------------------------------------------
struct ConnectData
{
   float4 shading         : COLOR;
   float2 texCoord        : TEXCOORD0;
   float3 reflectVec      : TEXCOORD1;
};


struct Fragout
{
   float4 col : COLOR0;
};


//-----------------------------------------------------------------------------
// Main                                                                        
//-----------------------------------------------------------------------------
Fragout main( ConnectData IN,
              uniform float4    ambient         : register(C3),
              uniform sampler2D diffuseMap      : register(S0),
              uniform samplerCUBE cubeMap         : register(S1),
              uniform float     visibility      : register(C9)
)
{
   Fragout OUT;

   OUT.col = IN.shading + ambient;
   float4 diffuseColor = tex2D(diffuseMap, IN.texCoord);
   OUT.col *= diffuseColor;
   OUT.col += diffuseColor.a * texCUBE(cubeMap, IN.reflectVec);
   OUT.col.a *= visibility;

   return OUT;
}
