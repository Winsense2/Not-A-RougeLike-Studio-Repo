Shader "Vertex-lit & Vertex-colored/Transparent/Alpha Blend Scrolling"
{
  Properties
  {
    _Color ("Base color", Color) = (1, 1, 1, 0)
    _OverlayColor ("OverlayColor", Color) = (1,1,1,0)
    _MainTex ("Texture (RGBA)", 2D) = "white" {}
    _ScrollSpeedX ("Scroll Speed (X)", Float) = 0.0
    _ScrollSpeedY ("Scroll Speed (Y)", Float) = 0.0
    [Toggle] _IsUnlit ("Unlit", Float) = 0.0
    [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull mode", Int) = 2
    [KeywordEnum(Default, N64)] _FilteringMode("Texture filtering", Float) = 0.0
  }
  SubShader
  {
    Tags
    {
      "Queue" = "Transparent"
      "RenderType" = "Transparent"
      "LightMode" = "ForwardBase"
    }

    Cull [_CullMode]
    ZWrite Off
    Blend One OneMinusSrcAlpha

    Pass
    {
      HLSLPROGRAM
      // shader macros
      #define IS_ALPHA_BLEND
      #define TEXTURE_BLEND_MODE_IS_ALPHA_BLEND
      #pragma multi_compile_fog
      #pragma UNITY_UI_ALPHACLIP
      #pragma shader_feature _FILTERINGMODE_DEFAULT _FILTERINGMODE_N64 _FILTERINGMODE_PS1
      #pragma shader_feature _ _MAPPINGMODE_SPHERE_MAPPED
      #pragma multi_compile _ LIGHTMAP_ON

      // shader code
      #include "../Common/VertexShadersCommon.cginc"
      #pragma vertex custom_vert
      #pragma fragment custom_frag

      float _ScrollSpeedX;
      float _ScrollSpeedY;

      half4 frag(custom_v2f i) : SV_Target
      {
        i.uv += float2(_ScrollSpeedX, _ScrollSpeedY) * _Time.y;
        return custom_frag_base(i);
      }
      ENDHLSL
    }
  }
}

// from "Vertex-Lit & Vertex-Colored Shaders" by Oddly Shaped Dog