//
//  MyView.swift
//  SwiftUI-test
//
//  Created by Yan Amin on 05.05.26.
//

import SwiftUI
import MetalKit

struct MetalView: NSViewRepresentable {
    
    var mandelbrotRe: Float
    var mandelbrotIm: Float
    var isZooming: Bool
    
    var center: CGPoint
    var box: CGPoint
    
    func makeNSView(context: Context) -> some NSView {
        let view = MTKView()
        
        context.coordinator.renderer = Renderer(view: view)
        view.delegate = context.coordinator.renderer
        
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        context.coordinator.renderer?.mandelbrotRe = mandelbrotRe
        context.coordinator.renderer?.mandelbrotIm = mandelbrotIm
        context.coordinator.renderer?.isZooming = isZooming
        context.coordinator.renderer?.zoomIntoRegion(center: center, box: box)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var renderer: Renderer?
    }
}
