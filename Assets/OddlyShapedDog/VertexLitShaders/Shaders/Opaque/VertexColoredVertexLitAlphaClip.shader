Shader "Vertex-lit & Vertex-colored/Opaque/Alpha Clip Texture"
{
    Properties
    {
        _Color ("Base color", Color) = (1, 1, 1, 0)
        _OverlayColor ("OverlayColor", Color) = (1,1,1,0)
        _MainTex ("Texture (RGBA)", 2D) = "black" {}
        _AlphaCutoff ("Alpha cutoff", Float) = 0.5
        [Toggle] _IsUnlit ("Unlit", Float) = 0.0
		[KeywordEnum(Default, N64, PS1)] _FilteringMode("Texture filtering", Float) = 0.0
        [KeywordEnum(Default, Sphere mapped)] _MappingMode("Texture mapping", Float) = 0.0
    }
    SubShader
    {
        Tags {
            "RenderType" = "Opaque"
            "LightMode" = "Vertex"
        }
        LOD 100

        Pass {
            HLSLPROGRAM
            #define TEXTURE_BLEND_MODE_IS_ALPHA_CLIP
            #pragma target 2.0
            #pragma multi_compile_fog
            #pragma shader_feature _FILTERINGMODE_DEFAULT _FILTERINGMODE_N64 _FILTERINGMODE_PS1
            #pragma shader_feature _ _MAPPINGMODE_SPHERE_MAPPED
            #pragma multi_compile _ LIGHTMAP_ON
            #include "../Common/VertexShadersCommon.cginc"
            #pragma vertex custom_vert
            #pragma fragment custom_frag
            ENDHLSL
        }

        UsePass "Legacy Shaders/VertexLit/ShadowCaster"
    }
}

// from "Vertex-Lit & Vertex-Colored Shaders" by Oddly Shaped Dog
