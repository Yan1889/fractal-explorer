//
//  Renderer.swift
//  SwiftUI-test
//
//  Created by Yan Amin on 05.05.26.
//

import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    var device: MTLDevice
    var lib: MTLLibrary
    var commandQueue: MTLCommandQueue
    
    var renderPSO: MTLRenderPipelineState!
    var triangleBuffer: MTLBuffer!
    var squareBuffer: MTLBuffer!
    
    var wallTexture: MTLTexture!
    
    init(view: MTKView) {
        device = MTLCreateSystemDefaultDevice()!
        view.device = device
        
        commandQueue = device.makeCommandQueue()!
        lib = device.makeDefaultLibrary()!
        
        super.init()
        
        setupPipeline()
        setupBuffers()
        setupTextures()
    }
    
    func setupPipeline() {
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].format = .float2
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.layouts[0].stride = 2 * MemoryLayout<Float>.size
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.label = "Triangle render pipeline"
        renderPipelineDescriptor.vertexFunction = lib.makeFunction(name: "vertexShader")
        renderPipelineDescriptor.fragmentFunction = lib.makeFunction(name: "fragmentShader")
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        
        do {
            renderPSO = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch let err {
            fatalError("failed to create render pipeline state object: \(err)")
        }
    }
    
    func setupBuffers() {
        let triangleVertices: [Float] = [
            -0.5, -0.5,
             0.5, -0.5,
             0.0, 0.5,
        ]
        
        let squareVertices: [Float] = [
            -1.0, -1.0,
             1.0,  1.0,
            -1.0,  1.0,
            
            -1.0, -1.0,
             1.0, -1.0,
             1.0,  1.0,
        ]
        
        triangleBuffer = device.makeBuffer(
            bytes: triangleVertices,
            length: 3 * 2 * MemoryLayout<Float>.size,
            options: [],
        )!
        
        squareBuffer = device.makeBuffer(
            bytes: squareVertices,
            length: 6 * 2 * MemoryLayout<Float>.size,
            options: []
        )!
    }
    
    func setupTextures() {
        let loader = MTKTextureLoader(device: device)
        let url = Bundle.main.url(forResource: "wall", withExtension: "jpg")!
        wallTexture = try! loader.newTexture(URL: url, options: [.SRGB: true])
    }
    
    var mandelbrotRe: Float = 0.0
    var mandelbrotIm: Float = 0.0
    var isZooming: Bool = false
    
    var mandelbrotWidth: Float = 3.0
    
    func draw(in view: MTKView) {
        view.colorPixelFormat = .bgra8Unorm
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        let renderPassDescriptor = view.currentRenderPassDescriptor!
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1.0)
        renderPassDescriptor.colorAttachments[0].texture = view.currentDrawable!.texture
        
        let encoder: MTLRenderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        encoder.setRenderPipelineState(renderPSO)
        
        encoder.setFragmentTexture(wallTexture, index: 0)
        
        struct Uniforms {
            let viewportSize: SIMD2<Float>
            let mandelbrotConstant: SIMD2<Float>
            let mandelbrotCenter: SIMD2<Float>
            let mandelbrotWidth: Float
        }
        
        var uniforms = Uniforms(
            viewportSize: SIMD2<Float>(
                Float(view.drawableSize.width),
                Float(view.drawableSize.height),
            ),
            // mandelbrotConstant: SIMD2<Float>(-0.8, 0.156),
            mandelbrotConstant: SIMD2<Float>(mandelbrotRe, mandelbrotIm),
            // mandelbrotCenter: SIMD2<Float>(-0.743645887037151, 0.131823904205330),
            mandelbrotCenter: SIMD2<Float>(-0.8, -1.0),
            mandelbrotWidth: mandelbrotWidth,
        )
        
        if (isZooming) {
            mandelbrotWidth *= 0.99
        }
        
        
        encoder.setFragmentBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 0)
        encoder.setVertexBuffer(squareBuffer, offset: 0, index: 0)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        
        encoder.endEncoding()
        
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
}
