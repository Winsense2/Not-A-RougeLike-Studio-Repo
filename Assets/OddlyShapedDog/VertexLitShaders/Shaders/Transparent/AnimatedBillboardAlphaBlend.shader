Shader "Vertex-lit & Vertex-colored/Transparent/Animated Billboard Alpha Blend"
{
  Properties
  {
    _Color ("Base color", Color) = (1, 1, 1, 0)
    _OverlayColor ("OverlayColor", Color) = (1,1,1,0)
    _MainTex ("Texture (RGBA)", 2D) = "black" {}
    _TilingX ("Tiling X", Float) = 1.0
    _TilingY ("Tiling Y", Float) = 1.0
    _Interval ("Interval", Float) = 0.5
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
      #pragma target 2.0
      #pragma multi_compile_fog
      #define IS_ALPHA_BLEND
      #define IS_BILLBOARD
      #define TEXTURE_BLEND_MODE_IS_ALPHA_BLEND
      #pragma shader_feature _FILTERINGMODE_DEFAULT _FILTERINGMODE_N64 _FILTERINGMODE_PS1
      #pragma shader_feature _ _MAPPINGMODE_SPHERE_MAPPED
      #pragma multi_compile _ LIGHTMAP_ON
      #include "../Common/VertexShadersCommon.cginc"
      #pragma vertex custom_vert
      #pragma fragment frag

      float _TilingX;
      float _TilingY;
      float _Interval;

      fixed4 frag(custom_v2f i) : SV_Target
      {
        // determine current frame offset
        int max_t = _TilingX * _TilingY;
        int t = floor(_Time.y / _Interval) % max_t;
        float2 uv_offset = float2(
          t % _TilingX,
          floor(t / _TilingX)
        );

        // determine uv
        float2 uv_scale = 1.0 / float2(_TilingX, _TilingY);
        i.uv = (i.uv + uv_offset) * uv_scale;

        // sample current frame
        return custom_frag_base(i);
      }
      ENDHLSL
    }
  }
}

// from "Vertex-Lit & Vertex-Colored Shaders" by Oddly Shaped Dog
