//
//  MyView.swift
//  SwiftUI-test
//
//  Created by Yan Amin on 05.05.26.
//

import SwiftUI
import MetalKit

struct MetalView: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
        let view = MTKView()
        
        context.coordinator.renderer = Renderer(view: view)
        view.delegate = context.coordinator.renderer
        
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var renderer: Renderer?
    }
}
