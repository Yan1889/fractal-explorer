//
//  ContentView.swift
//  SwiftUI-test
//
//  Created by Yan Amin on 05.05.26.
//

import SwiftUI

struct ContentView: View {
    
    @State var mandelbrotRe: Float = -0.8
    @State var mandelbrotIm: Float = 0.156
    @State var isZooming: Bool = false
    
    var body: some View {
        VStack {
            ControlPanelView(mandelbrotRe: $mandelbrotRe, mandelbrotIm: $mandelbrotIm, isZooming: $isZooming)
                .frame(width: 900, height: 50)
            
            MetalView(mandelbrotRe: mandelbrotRe, mandelbrotIm: mandelbrotIm, isZooming: isZooming)
                .frame(width: 900, height: 700)
        }
    }
}
