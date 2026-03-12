Shader "Vertex-lit & Vertex-colored/Transparent/Billboard Alpha Blend"
{
  Properties
  {
    _Color ("Base color", Color) = (1, 1, 1, 0)
    _OverlayColor ("OverlayColor", Color) = (1,1,1,0)
    _MainTex ("Texture (RGBA)", 2D) = "white" {}
    [Toggle] _IsUnlit ("Unlit", Float) = 0.0
    [KeywordEnum(Default, N64, PS1)] _FilteringMode("Texture filtering", Float) = 0.0
  }
  SubShader
  {
    Tags
    {
      "Queue" = "Transparent"
      "IgnoreProjector" = "True"
      "RenderType" = "Transparent"
      "LightMode" = "Vertex"
    }

    ZWrite Off
    Blend One OneMinusSrcAlpha

    Pass
    {
      HLSLPROGRAM
      // shader macros
      #define IS_BILLBOARD
      #define IS_ALPHA_BLEND
      #define TEXTURE_BLEND_MODE_IS_ALPHA_BLEND
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