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
   float4 lightVec        : TEXCOORD1;
   float3 pixPos          : TEXCOORD2;
   float3 eyePos          : TEXCOORD3;
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
              uniform sampler2D bumpMap         : register(S1),
              uniform float4    specularColor   : register(C0),
              uniform float     specularPower   : register(C1),
              uniform float     visibility      : register(C9)
)
{
   Fragout OUT;

   float4 diffuseColor = tex2D(diffuseMap, IN.texCoord);
   OUT.col = diffuseColor;
   float4 bumpNormal = tex2D(bumpMap, IN.texCoord);

   float4 bumpDot = ( dot(bumpNormal.xyz * 2.0 - 1.0, IN.lightVec.xyz) + 1.0 ) * 0.5;
   OUT.col *= (IN.shading * bumpDot) + ambient;

   float3 eyeVec = normalize(IN.eyePos - IN.pixPos);
   float3 halfAng = normalize(eyeVec + IN.lightVec.xyz);
   float specular = saturate( dot(bumpNormal.xyz * 2.0 - 1.0, halfAng) ) * IN.lightVec.w;
   specular = pow(specular, specularPower);
   OUT.col += specularColor * specular * diffuseColor.a;
   OUT.col.a = 1.0;
   OUT.col.a *= visibility;

   return OUT;
}
