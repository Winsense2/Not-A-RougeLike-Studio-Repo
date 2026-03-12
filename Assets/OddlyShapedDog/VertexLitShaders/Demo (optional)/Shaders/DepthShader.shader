Shader "Vertex-lit & Vertex-colored/Demo/Camera Depth Texture" {
	Properties
	{
        _Threshold ("Threshold", Float) = 0.0
	}
    SubShader {
        Tags { "RenderType"="Transparent" }
        Pass {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 depth : TEXCOORD1;
            };

            sampler2D _CameraDepthTexture;
            float _Threshold;
            
            inline float computeDepth(v2f i)
            {
                float zdepth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv.xy);

                zdepth += _Threshold;

                // 0..1 linear depth, 0 at camera, 1 at far plane.
                float depth = Linear01Depth(zdepth);
            #if defined(UNITY_REVERSED_Z)
                depth = 1 - depth;
            #endif
                depth = pow(depth, 2.0);

                return depth;
            }

            v2f vert (appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_UV(v.texcoord.xy);
                UNITY_TRANSFER_DEPTH(o.depth);
                return o;
            }

            half4 frag(v2f i) : SV_Target {
                //UNITY_OUTPUT_DEPTH(i.depth);
                return computeDepth(i);
            }
            ENDCG
        }
    }
}