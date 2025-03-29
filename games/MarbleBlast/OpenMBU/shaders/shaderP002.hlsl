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
   float3 normal          : TEXCOORD1;
   float3 pixPos          : TEXCOORD2;
   float3 eyePos          : TEXCOORD3;
   float4 lightVec        : TEXCOORD4;
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
              uniform float4    specularColor   : register(C0),
              uniform float     specularPower   : register(C1),
              uniform float     visibility      : register(C9)
)
{
   Fragout OUT;

   OUT.col = IN.shading + ambient;
   float4 diffuseColor = tex2D(diffuseMap, IN.texCoord);
   OUT.col *= diffuseColor;

   float3 eyeVec = normalize(IN.eyePos - IN.pixPos);
   float3 halfAng = normalize(eyeVec + IN.lightVec.xyz);
   float specular = saturate( dot(IN.normal.xyz, halfAng) ) * IN.lightVec.w;
   specular = pow(specular, specularPower);
   OUT.col += specularColor * specular * diffuseColor.a;
   OUT.col.a = 1.0;
   OUT.col.a *= visibility;

   return OUT;
}
