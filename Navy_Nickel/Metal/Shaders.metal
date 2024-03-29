//
//  Shaders.metal
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła(S) on 19/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#import "../Lights/Common.h"

struct VertexIn {
    packed_float4 position;
    packed_float4 color;
};

struct VertexOut {
    float4 postion [[position]];
    float4 color;
};

struct BaseUniforms {
    float4x4 modelMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut traingle_vertex_main(const device VertexIn *vertices [[buffer(0)]],
                          const uint vid [[vertex_id]]) {
    VertexIn vertexIn = vertices[vid];

    VertexOut vertexOut;
    vertexOut.postion = float4(vertexIn.position);
    vertexOut.color = float4(vertexIn.color);
    return vertexOut;
}

fragment half4 triangle_fragment_main(VertexOut interpolated [[stage_in]]) {
    float4 color = interpolated.color;
    return half4(color[0], color[1], color[2], color[3]);
}


vertex VertexOut base_vertex_main(const device VertexIn *vertices [[buffer(0)]],
                             const device BaseUniforms&  uniforms [[ buffer(1) ]],
                             const uint vid [[vertex_id]]) {
    VertexIn vertexIn = vertices[vid];

    float4x4 mvMatrix = uniforms.modelMatrix;
    
    float4x4 proj_Matrix = uniforms.projectionMatrix;

    VertexOut vertexOut;
    vertexOut.postion = proj_Matrix * mvMatrix * float4(vertexIn.position);
    vertexOut.color = float4(vertexIn.color);
    return vertexOut;
}
 
fragment half4 base_fragment_main(VertexOut interpolated [[stage_in]]) {
    float4 color = interpolated.color;
    return half4(color[0], color[1], color[2], color[3]);
}


struct LightVertexIn {
    float4 position [[attribute(0)]];
    float3 normal [[attribute(1)]];
};

struct LightVertexOut {
    float4 position [[position]];
    float3 worldPosition;
    float3 worldNormal;
};

vertex LightVertexOut vertex_main(const LightVertexIn vertexIn [[stage_in]],
                             constant Uniforms &uniforms [[buffer(1)]])
{
    LightVertexOut out {
        .position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertexIn.position,
        .worldPosition = (uniforms.modelMatrix * vertexIn.position).xyz,
        .worldNormal = uniforms.normalMatrix * vertexIn.normal
    };
    return out;
}

fragment float4 fragment_main(LightVertexOut in [[stage_in]],
                              constant Light *lights [[buffer(2)]],
                              constant FragmentUniforms &fragmentUniforms [[buffer(3)]]) {
    float3 baseColor = float3(0, 0, 1);
    float3 diffuseColor = 0;
    float3 ambientColor = 0;

    float3 specularColor = 0;
    float materialShininess = 32;
    float3 materialSpecularColor = float3(1, 1, 1);

    float3 normalDirection = normalize(in.worldNormal);
    for (uint i = 0; i < fragmentUniforms.lightCount; i++) {
        Light light = lights[i];
        if (light.type == Sunlight) {
            float3 lightDirection = normalize(-light.position);
            float diffuseIntensity = saturate(-dot(lightDirection, normalDirection));
            diffuseColor += light.color * baseColor * diffuseIntensity;
            if (diffuseIntensity > 0) {
                float3 reflection = reflect(lightDirection, normalDirection);
                float3 cameraDirection = normalize(in.worldPosition - fragmentUniforms.cameraPosition);
                float specularIntensity = pow(saturate(-dot(reflection, cameraDirection)), materialShininess);
                specularColor += light.specularColor * materialSpecularColor * specularIntensity;
            }
        }  else if (light.type == Ambientlight) {
            ambientColor += light.color * light.intensity;
        }

    }

    float3 color = diffuseColor + ambientColor + specularColor;
    return float4(color, 1);
}


