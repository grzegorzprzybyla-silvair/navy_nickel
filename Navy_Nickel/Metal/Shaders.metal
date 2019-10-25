//
//  Shaders.metal
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła(S) on 19/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
 
struct VertexIn {
    packed_float4 position;
    packed_float4 color;
};

struct VertexOut {
    float4 postion [[position]];
    float4 color;
};
 
vertex VertexOut vertex_main(const device VertexIn *vertices [[buffer(0)]],
                          const uint vid [[vertex_id]]) {
    VertexIn vertexIn = vertices[vid];

    VertexOut vertexOut;
    vertexOut.postion = float4(vertexIn.position);
    vertexOut.color = float4(vertexIn.color);
    return vertexOut;
}
 
fragment half4 fragment_main(VertexOut interpolated [[stage_in]]) {
    float4 color = interpolated.color;
    return half4(color[0], color[1], color[2], color[3]);
}
