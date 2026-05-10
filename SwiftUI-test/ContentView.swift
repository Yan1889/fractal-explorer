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
    
    @State var mouseStartLoc: CGPoint = .zero
    @State var mouseCurrLoc: CGPoint = .zero
    
    @State var center: CGPoint = .zero
    @State var box: CGPoint = CGPoint(x: 2, y: 2)
    
    var body: some View {
        VStack {
            ControlPanelView(mandelbrotRe: $mandelbrotRe, mandelbrotIm: $mandelbrotIm, isZooming: $isZooming)
                .frame(width: 900, height: 50)
            
            ZStack {
                MetalView(
                    mandelbrotRe: mandelbrotRe,
                    mandelbrotIm: mandelbrotIm,
                    isZooming: isZooming,
                    center: center,
                    box: box,
                )
                    .frame(width: 900, height: 700)
                    .gesture(
                        DragGesture()
                            .onChanged { m in
                                mouseStartLoc = m.startLocation
                                mouseCurrLoc = m.location
                            }
                            .onEnded { m in
                                center.x = (mouseCurrLoc + mouseStartLoc).x / 900.0 - 1.0
                                center.y = (mouseCurrLoc + mouseStartLoc).y / 700.0 - 1.0
                                box.x = (mouseCurrLoc - mouseStartLoc).x / 900.0
                                box.y = (mouseCurrLoc - mouseStartLoc).y / 700.0
                                
                                mouseStartLoc = .zero
                                mouseCurrLoc = .zero
                            }
                    )
                
                Rectangle()
                    .fill(.white.opacity(0.5))
                    .frame(
                        width: (mouseCurrLoc - mouseStartLoc).x,
                        height: (mouseCurrLoc - mouseStartLoc).y,
                    )
                    .position((mouseCurrLoc + mouseStartLoc) * 0.5)
            }
            .frame(width: 900)
        }
    }
}
