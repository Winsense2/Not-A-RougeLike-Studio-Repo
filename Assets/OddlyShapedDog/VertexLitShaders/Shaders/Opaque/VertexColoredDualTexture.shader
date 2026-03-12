Shader "Vertex-lit & Vertex-colored/Opaque/Dual texture"
{
    Properties
    {
        _Color ("Base color", Color) = (1, 1, 1, 0)
        _MainTex ("Primary texture (RGBA)", 2D) = "black" {}
        _SecondaryTex ("Secondary texture (RGBA)", 2D) = "black" {}
        _MixFactor ("Mix factor", Float) = 0
        _OverlayColor ("OverlayColor", Color) = (1,1,1,0)
        [Toggle] _IsUnlit ("Unlit", Float) = 0.0
		[KeywordEnum(Default, N64, PS1)] _FilteringMode("Texture filtering", Float) = 0.0
        [KeywordEnum(Default, Sphere mapped)] _MappingMode("Texture mapping", Float) = 0.0
    }
    SubShader
    {
        LOD 100

        // default pass
        Pass {
            Tags {
                "RenderType" = "Opaque"
                "LightMode" = "Vertex"
            }

            CGPROGRAM
            #define TEXTURE_BLEND_MODE_IS_ALPHA_BLEND
            #define HAS_SECONDARY_TEXTURE
            #pragma target 2.0
            #pragma multi_compile_fog
            #pragma shader_feature _FILTERINGMODE_DEFAULT _FILTERINGMODE_N64 _FILTERINGMODE_PS1
            #pragma shader_feature _ _MAPPINGMODE_SPHERE_MAPPED
            #pragma multi_compile _ LIGHTMAP_ON
            #include "../Common/VertexShadersCommon.cginc"
            #pragma vertex custom_vert
            #pragma fragment frag

            float _MixFactor;

            half4 frag(custom_v2f i) : SV_Target {
	            half4 texcol1 = sample_texture(_MainTex, i.uv, _MainTex_TexelSize);
	            half4 texcol2 = sample_texture(_SecondaryTex, i.uv2, _SecondaryTex_TexelSize);
                half4 texcol = lerp(texcol1, texcol2, _MixFactor);
                
                return custom_frag_compute_color(
                    i,
                    texcol
                );
            }
            ENDCG
        }

        // pass when baked lightmaps are on
        Pass {
            Tags {
                "RenderType" = "Opaque"
                "LightMode" = "VertexLM"
            }

            CGPROGRAM
            #define TEXTURE_BLEND_MODE_IS_ALPHA_BLEND
            #define HAS_SECONDARY_TEXTURE
            #pragma target 2.0
            #pragma multi_compile_fog
            #include "../Common/VertexShadersCommon.cginc"
            #pragma vertex custom_vert
            #pragma fragment frag

            float _MixFactor;

            half4 frag(custom_v2f i) : SV_Target {
	            half4 texcol1 = sample_texture(_MainTex, i.uv, _MainTex_TexelSize);
	            half4 texcol2 = sample_texture(_SecondaryTex, i.uv3, _SecondaryTex_TexelSize);
                half4 texcol = lerp(texcol1, texcol2, _MixFactor);

                return custom_frag_compute_color(
                    i,
                    texcol
                );
            }
            ENDCG
        }

        UsePass "Legacy Shaders/VertexLit/ShadowCaster"
    }
}

// from "Vertex-Lit & Vertex-Colored Shaders" by Oddly Shaped Dog
