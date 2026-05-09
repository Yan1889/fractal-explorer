//
//  Shaders.metal
//  SwiftUI-test
//
//  Created by Yan Amin on 05.05.26.
//

#include <metal_stdlib>

using namespace metal;


struct VertexIn {
    float2 pos [[attribute(0)]];
};

struct VertexOut {
    float4 pos [[position]];
    float2 texCoord;
};

vertex VertexOut vertexShader(VertexIn in [[stage_in]]) {
    return VertexOut {
        .pos = float4(in.pos, 0.0f, 1.0f),
        .texCoord = float2(in.pos.x / 2.0 + 0.5, -in.pos.y / 2.0 + 0.5)
    };
}

struct Complex {
    float re, im;
    
    float len() const;
    float len_sq() const;
};

inline Complex operator+(Complex a, Complex b) {
    return { a.re + b.re, a.im + b.im };
}

inline Complex operator*(Complex a, Complex b) {
    return { a.re * b.re - a.im * b.im, a.re * b.im + a.im * b.re };
}

inline float Complex::len() const {
    return sqrt(len_sq());
}

inline float Complex::len_sq() const {
    return re * re + im * im;
}

constant float4 palette[] = {
    float4(0.0, 0.0, 0.0, 1.0),
    float4(0.0, 0.02, 0.35, 1.0),
    float4(0.0, 0.08, 0.55, 1.0),
    float4(0.0, 0.18, 0.72, 1.0),
    float4(0.10, 0.45, 0.95, 1.0),
    float4(0.45, 0.82, 1.0, 1.0),
    float4(0.80, 0.96, 1.0, 1.0),
    float4(1.0, 1.0, 1.0, 1.0)
};

constant constexpr int COLOR_COUNT = sizeof(palette) / sizeof(palette[0]);

struct FragUniforms {
    float2 viewportSize;
    Complex mandelbrotConstant;
    float2 mandelbrotCenter;
    float mandelbrotWidth;
};

Complex iterate(Complex z, constant FragUniforms &uniforms) {
    return z * z + uniforms.mandelbrotConstant;
}

fragment float4 fragmentShader(float4 position [[position]],
                               constant FragUniforms &uniforms [[buffer(0)]]) {
    
    float2 ndc;
    ndc.x = (position.x / uniforms.viewportSize.x) * 2.0 - 1.0;
    ndc.y = 1.0 - (position.y / uniforms.viewportSize.y) * 2.0;
    
    float2 complex_plane = ndc * uniforms.mandelbrotWidth + uniforms.mandelbrotCenter;
    
    Complex z = Complex{
        complex_plane.x,
        complex_plane.y
    };
    
    int max_iterations = 300;
    
    for (int i = 0; i < max_iterations; i++) {
        z = iterate(z, uniforms);
        
        if (z.len_sq() > 2 * 2) {
            // v < 0 < max_iterations
            float v = i + 1 - log(log(z.len())) / log(2.0);
            
            // 0 < t < 1
            // float t = v / (float) max_iterations;
            float t = pow(v / (float)max_iterations, 0.2);
            
            int color_A_idx = (int) (t * (COLOR_COUNT - 1) + 0);
            int color_B_idx = (int) (t * (COLOR_COUNT - 1) + 1);
            float x = t * (COLOR_COUNT - 1) - color_A_idx;
            
            float4 A = palette[color_A_idx];
            float4 B = palette[color_B_idx];
            
            return (1 - x) * A + x * B;
        }
    }
    return float4(0.0, 0.0, 0.0, 1.0);
}

/*
fragment float4 fragmentShader(VertexOut in [[stage_in]], texture2d<float> tex [[texture(0)]]) {
    constexpr sampler s(address::clamp_to_edge, filter::linear);
    return tex.sample(s, in.texCoord);
}
*/
