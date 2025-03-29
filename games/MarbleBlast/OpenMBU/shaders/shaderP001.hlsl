//*****************************************************************************
// TSE -- HLSL procedural shader                                               
//*****************************************************************************
//-----------------------------------------------------------------------------
// Structures                                                                  
//-----------------------------------------------------------------------------
struct ConnectData
{
   float2 texCoord        : TEXCOORD0;
};


struct Fragout
{
   float4 col : COLOR0;
};


//-----------------------------------------------------------------------------
// Main                                                                        
//-----------------------------------------------------------------------------
Fragout main( ConnectData IN,
              uniform sampler2D diffuseMap      : register(S0),
              uniform float4    lightColor      : register(C2),
              uniform float     visibility      : register(C9)
)
{
   Fragout OUT;

   OUT.col = tex2D(diffuseMap, IN.texCoord);
   OUT.col *= lightColor;
   OUT.col.a *= visibility;

   return OUT;
}
