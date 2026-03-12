Shader "Vertex-lit & Vertex-colored/Transparent/Alpha Clip"
{
  Properties
  {
    _Color ("Base color", Color) = (1, 1, 1, 0)
    _OverlayColor ("OverlayColor", Color) = (1,1,1,0)
    _MainTex ("Texture (RGBA)", 2D) = "white" {}
    _AlphaCutoff ("Alpha cutoff", Float) = 0.5
    [Toggle] _IsUnlit ("Unlit", Float) = 0.0
    [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull mode", Int) = 2
    [KeywordEnum(Default, N64, PS1)] _FilteringMode("Texture filtering", Float) = 0.0
  }
  SubShader
  {
    Tags
    {
      "Queue" = "AlphaTest"
      "RenderType" = "TransparentCutout"
      "LightMode" = "Vertex"
    }

    Cull [_CullMode]

    Pass
    {
      HLSLPROGRAM
      // shader macros
      #define IS_ALPHA_CLIPPED
      #define TEXTURE_BLEND_MODE_IS_ALPHA_CLIP
      #pragma multi_compile_fog
      #pragma shader_feature _FILTERINGMODE_DEFAULT _FILTERINGMODE_N64 _FILTERINGMODE_PS1
      #pragma shader_feature _ _MAPPINGMODE_SPHERE_MAPPED
      #pragma multi_compile _ LIGHTMAP_ON

      // shader code
      #include "../Common/VertexShadersCommon.cginc"
      #pragma vertex custom_vert
      #pragma fragment custom_frag
      ENDHLSL
    }
  }
}

// from "Vertex-Lit & Vertex-Colored Shaders" by Oddly Shaped Dog