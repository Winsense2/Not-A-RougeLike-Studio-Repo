Shader "Vertex-lit & Vertex-colored/Opaque/Modulate Texture Scrolling"
{
    Properties
    {
        _Color ("Base color", Color) = (1, 1, 1, 0)
        _OverlayColor ("Overlay Color", Color) = (1, 1, 1, 0)
        _MainTex ("Texture (RGBA)", 2D) = "black" {}
        _ScrollSpeedX ("Scroll Speed (X)", Float) = 0.0
        _ScrollSpeedY ("Scroll Speed (Y)", Float) = 0.0
        [Toggle] _IsUnlit ("Unlit", Float) = 0.0
		[KeywordEnum(Default, N64)] _FilteringMode("Texture filtering", Float) = 0.0
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
            #pragma target 2.0
            #pragma multi_compile_fog
            #define TEXTURE_BLEND_MODE_IS_MODULATE
            #pragma shader_feature _FILTERINGMODE_DEFAULT _FILTERINGMODE_N64 _FILTERINGMODE_PS1
            #pragma shader_feature _ _MAPPINGMODE_SPHERE_MAPPED
            #pragma multi_compile _ LIGHTMAP_ON
            #include "../Common/VertexShadersCommon.cginc"
            #pragma vertex custom_vert
            #pragma fragment frag

            float _ScrollSpeedX;
            float _ScrollSpeedY;

            half4 frag(custom_v2f i) : SV_Target {
                i.uv += float2(_ScrollSpeedX, _ScrollSpeedY) * _Time.y;
                return custom_frag_base(i);
            }

            ENDHLSL
        }
    }
}

// from "Vertex-Lit & Vertex-Colored Shaders" by Oddly Shaped Dog
