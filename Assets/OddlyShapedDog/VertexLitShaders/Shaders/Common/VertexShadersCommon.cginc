/**
 * VERTEX SHADERS COMMON
 * =====================
 *
 * This file is a library of constants and functions used
 * by all shaders in the "Vertex-Lit & Vertex-Colored Shaders"
 * shader pack by Oddly Shaped Dog.
 *
 * Any changes you make to this file will apply to ALL
 * shaders in the "Vertex-Lit & Vertex-Colored" category.
 */


/* * * * * * * * * * * * * * *
 * FEATURES                  *
 * * * * * * * * * * * * * * */

#define USING_FOG (defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2))


/* * * * * * * * * * * * * * *
 * IMPORTS                   *
 * * * * * * * * * * * * * * */

#include "UnityCG.cginc"
#include "AutoLight.cginc"

#ifdef _FILTERINGMODE_N64
#include "N64Filtering.cginc"
#endif



/* * * * * * * * * * * * * * *
 * DATA STRUCTURES           *
 * * * * * * * * * * * * * * */

struct custom_v2f
{
    float4 vertex: SV_POSITION;
    fixed4 color : COLOR0;

    // primary UVs
    #ifndef _FILTERINGMODE_PS1
    float2 uv : TEXCOORD0;
    #else
    noperspective float2 uv : TEXCOORD0;
    #endif

    // secondary texture UVs
    #if defined(HAS_SECONDARY_TEXTURE)
    #ifndef _FILTERINGMODE_PS1
    float2 uv2 : TEXCOORD1;
    #else
    noperspective float2 uv2 : TEXCOORD1;
    #endif
    #endif
    float3 lighting : COLOR1;
    UNITY_FOG_COORDS(2)
    UNITY_VERTEX_OUTPUT_STEREO
};

// WIP
struct custom_v2f_lm
{
    float2 uv0 : TEXCOORD0;
    float2 uv1 : TEXCOORD1;
    float2 uv2 : TEXCOORD2;
    #if USING_FOG
    fixed fog : TEXCOORD3;
    #endif
    float4 pos : SV_POSITION;
    UNITY_VERTEX_OUTPUT_STEREO
};


/* * * * * * * * * * * * * * *
 * UNIFORMS                  *
 * * * * * * * * * * * * * * */

sampler2D _MainTex;
float4 _MainTex_ST;
float4 _MainTex_TexelSize;
fixed4 _Color;
fixed4 _OverlayColor;
float _IsUnlit;

#ifdef VLS_ENABLE_EMISSIVE
fixed4 _Emission;
#endif

float4 unity_Lightmap_ST;

#ifdef HAS_SECONDARY_TEXTURE
sampler2D _SecondaryTex;
float4 _SecondaryTex_ST;
float4 _SecondaryTex_TexelSize;
#endif

#if defined(IS_ALPHA_CLIPPED) || defined(TEXTURE_BLEND_MODE_IS_ALPHA_CLIP)
float _AlphaCutoff;
#endif


/* * * * * * * * * * * * * * *
 * UTILITY FUNCTIONS         *
 * * * * * * * * * * * * * * */

half4 colorOpMultiply(half4 a, half4 b)
{
    half4 resultColor = half4(0, 0, 0, 0);
    resultColor.rgb = a.rgb * (1.0 - b.a) + (a.rgb * b.rgb * b.a);
    resultColor.a = a.a;
    return resultColor;
}

half4 colorOpSrcOver(half4 a, half4 b)
{
    half4 resultColor = half4(0, 0, 0, 0);
    resultColor.rgb = b.a * b.rgb + (1.0 - b.a) * a.rgb;
    resultColor.a = clamp(a.a + b.a, 0.0, 1.0);
    return resultColor;
}

half4 colorOpSrcClipOver(half4 a, half4 b, float threshold)
{
    if (b.a > threshold)
    {
        return b;
    }
    return a;
}

inline half4 sample_texture(sampler2D tex, float2 uv, float4 texelSize)
{
    #ifdef _FILTERINGMODE_N64
    return tex2D_N64(tex, uv, texelSize, 0.0);
    #else
    return tex2D(tex, uv);
    #endif
}

float4 billboard_vertex(appdata_full v)
{
    float3 vertexPos = mul((float3x3)unity_ObjectToWorld, v.vertex.xyz);
    float4 worldPos = float4(unity_ObjectToWorld._m03, unity_ObjectToWorld._m13,
                             unity_ObjectToWorld._m23, 1.0);
    float4 viewPos = mul(UNITY_MATRIX_V, worldPos) + float4(vertexPos, 0);
    float4 vertex = mul(UNITY_MATRIX_P, viewPos);
    return vertex;
}

float3 billboard_normal()
{
    float3 objectWorldOrigin = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
    float3 worldNormal = normalize(_WorldSpaceCameraPos - objectWorldOrigin);
    return mul((float3x3)unity_WorldToObject, worldNormal).xyz;
}


/* * * * * * * * * * * * * * *
 * VERTEX SHADER             *
 * * * * * * * * * * * * * * */

custom_v2f custom_vert_base(appdata_full v)
{
    custom_v2f o;

    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    o.vertex = UnityObjectToClipPos(v.vertex);

    #if !defined(IS_SPHERE_MAPPED) && !defined(_MAPPINGMODE_SPHERE_MAPPED)
    // default mapping
    o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
    #ifdef HAS_SECONDARY_TEXTURE
        o.uv2 = TRANSFORM_TEX (v.texcoord, _SecondaryTex);
    #ifdef _FILTERINGMODE_PS1
        o.uv2 *= o.vertex.w;
    #endif
    #endif
    #else
    // sphere mapping
    float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
    float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
    float3 worldNormal = UnityObjectToWorldNormal(v.normal);
    float3 reflectionVector = normalize(reflect(worldViewDir, worldNormal));
    reflectionVector.y *= -1;
    float2 envUV = 0.5 + 0.5 * (
        reflectionVector.xy /
        sqrt(
            2.0 *
            (reflectionVector.z + 1)
        )
    );
    o.uv = TRANSFORM_TEX(envUV, _MainTex);
    #endif

    // optional lightmap support
    // TODO

    o.color = v.color;

    // needed for lighting
    float4 objectSpacePos = v.vertex;
    float3 objectSpaceNormal = v.normal;

    #ifdef IS_BILLBOARD
    // make vertex face camera
    o.vertex = billboard_vertex(v);

    // align normal to billboard
    // to ensure correct lighting
    objectSpaceNormal = billboard_normal();
    #endif

    // fall back to default vertex-lit diffuse lighting
    half3 lightcol = ShadeVertexLights(
        objectSpacePos,
        objectSpaceNormal
    );
    o.lighting = lerp(lightcol, half3(1, 1, 1), _IsUnlit);

    UNITY_TRANSFER_FOG(o, o.vertex);

    return o;
}

custom_v2f custom_vert(appdata_full v)
{
    return custom_vert_base(v);
}

// WIP
custom_v2f_lm custom_vert_lightmap(appdata_full v)
{
    custom_v2f_lm o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    o.uv0 = v.texcoord1.xy * unity_Lightmap_ST.xy + unity_Lightmap_ST.zw;
    o.uv1 = v.texcoord1.xy * unity_Lightmap_ST.xy + unity_Lightmap_ST.zw;
    o.uv2 = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;

    #if USING_FOG
    float3 eyePos = UnityObjectToViewPos(v.vertex);
    float fogCoord = length(eyePos.xyz);
    UNITY_CALC_FOG_FACTOR_RAW(fogCoord);
    o.fog = saturate(unityFogFactor);
    #endif

    o.pos = UnityObjectToClipPos(v.vertex);
    return o;
}


/* * * * * * * * * * * * * * *
 * FRAGMENT SHADER           *
* * * * * * * * * * * * * * */

half4 custom_frag_compute_color(
    custom_v2f i,
    half4 texcol
)
{
    half4 col = half4(0.0, 0.0, 0.0, 1.0);
    #ifdef IS_ALPHA_BLEND
    col.a = 0.0;
    #endif

    // start with the model's vertex colors
    col.rgb = i.color.rgb;

    // override with optional base color
    // (100% transparent by default)
    col = colorOpSrcOver(col, _Color);

    // set transparency
    #ifdef IS_ALPHA_CLIPPED
    clip(texcol.a - _AlphaCutoff);
    col.a = 1.0;
    #endif
    #ifdef IS_ALPHA_BLEND
    col.rgb *= texcol.a;
    col.a = _Color.a * texcol.a;
    #endif

    // overlay texture
    #ifdef TEXTURE_BLEND_MODE_IS_MODULATE
    col = colorOpMultiply(col, texcol);
    #endif
    #ifdef TEXTURE_BLEND_MODE_IS_ALPHA_BLEND
    col = colorOpSrcOver(col, texcol);
    #endif
    #ifdef TEXTURE_BLEND_MODE_IS_ALPHA_CLIP
    col = colorOpSrcClipOver(col, texcol, _AlphaCutoff);
    #endif

    // apply lighting
    #ifndef IS_UNLIT
    col.rgb = col.rgb * i.lighting;
    #endif

    // apply optional overlay color
    col.rgb = colorOpSrcOver(col, _OverlayColor).rgb;

    // apply fog
    UNITY_APPLY_FOG_COLOR(
        i.fogCoord,
        col,
        unity_FogColor
    );

    return col;
}

half4 custom_frag_base(custom_v2f i)
{
    // sample the texture
    half4 texcol = sample_texture(_MainTex, i.uv, _MainTex_TexelSize);

    return custom_frag_compute_color(i, texcol);
}

half4 custom_frag(custom_v2f i) : SV_Target
{
    return custom_frag_base(i);
}

// WIP
half4 custom_frag_lightmap(custom_v2f_lm v) : SV_Target
{
    half4 col;

    fixed4 tex = UNITY_SAMPLE_TEX2D(unity_Lightmap, v.uv0.xy);
    // tex = UNITY_SAMPLE_SHADOW(unity_Lightmap, v.uv0.xy);
    half4 bakedColor = half4(DecodeLightmap(tex), 1.0);

    col = bakedColor * _Color;

    tex = tex2D(_MainTex, v.uv2.xy);
    col.rgb = tex.rgb * col.rgb;
    col.a = 1.0f;

    #if USING_FOG
    col.rgb = lerp(unity_FogColor.rgb, col.rgb, v.fog);
    #endif

    col.rgb = half4(1.0, 0.0, 1.0, 1.0);
    return half4(1.0, 1.0, 0.0, 1.0);

    return col;
}

// from "Vertex-Lit & Vertex-Colored Shaders" by Oddly Shaped Dog
