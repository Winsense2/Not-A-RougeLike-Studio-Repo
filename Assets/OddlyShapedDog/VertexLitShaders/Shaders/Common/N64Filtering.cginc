// based on https://forum.unity.com/threads/shader-ideas-for-replicating-n64-bi-linear-filtering.936119/
half4 tex2D_N64(
  sampler2D tex,
  float2 uv,
  float4 texelSize,
  float flip
)
{
  #ifdef _FILTERINGMODE_N64_FLIPPED
  uv.x = 1.0 - uv.x;
  #endif
  // get pixel coords
  float2 textureDimensions = texelSize.zw;
  float2 pixelCoords = uv * textureDimensions;

  // get change rate
  float2 dx = ddx(pixelCoords);
  float2 dy = ddy(pixelCoords);

  // calculate mip level by comparing dot products
  float dxDot = dot(dx, dx);
  float dyDot = dot(dy, dy);
  float mipLevel = 0.5 * log2(max(dxDot, dyDot));

  // keep mip from being negative
  mipLevel = max(0.0, mipLevel);

  // round down mip to power of 2
  float texelScale = pow(2, floor(mipLevel));
  texelSize.xy *= texelScale;
  texelSize.zw /= texelScale;

  // scale uv
  pixelCoords = pixelCoords / texelScale - 0.5;

  // locate nearest point
  float2 uvNearest = frac(pixelCoords);

  // calculate equivalents of point filtered uvs for the three points
  float2 uv1, uv2, uv3;
  uv1 = floor(pixelCoords + uvNearest.yx) + 0.5;
  uv2 = floor(pixelCoords) + float2(1.5, 0.5);
  uv3 = floor(pixelCoords) + float2(0.5, 1.5);

  #ifndef _FILTERINGMODE_N64_FLIPPED
  uv1 = floor(pixelCoords + uvNearest.yx) + 0.5;
  uv2 = floor(pixelCoords) + float2(1.5, 0.5);
  uv3 = floor(pixelCoords) + float2(0.5, 1.5);
  #endif

  uv1 *= texelSize.xy;
  uv2 *= texelSize.xy;
  uv3 *= texelSize.xy;

  #ifdef _FILTERINGMODE_N64_FLIPPED
  uv1.x = 1.0 - uv1.x;
  uv2.x = 1.0 - uv2.x;
  uv3.x = 1.0 - uv3.x;
  #endif

  // sample corresponding points at current mip level
  half4 col1 = tex2Dlod(tex, float4(uv1, 0, mipLevel));
  half4 col2 = tex2Dlod(tex, float4(uv2, 0, mipLevel));
  half4 col3 = tex2Dlod(tex, float4(uv3, 0, mipLevel));

  // determine blend factors
  float blend1 = abs(uvNearest.x + uvNearest.y - 1);
  float blend2 = min(
    abs(uvNearest.x),
    abs(uvNearest.y - 1)
  );
  float blend3 = min(
    abs(uvNearest.x - 1),
    abs(uvNearest.y)
  );

  // blend and return
  return (
    col1 * blend1 +
    col2 * blend2 +
    col3 * blend3
  );
}

// from "Vertex-Lit & Vertex-Colored Shaders" by Oddly Shaped Dog
