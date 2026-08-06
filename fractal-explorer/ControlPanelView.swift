//
//  ControlPanelView.swift
//  SwiftUI-test
//
//  Created by Yan Amin on 09.05.26.
//

import SwiftUI

struct ControlPanelView: View {
    
    @Binding var mandelbrotRe: Float
    @Binding var mandelbrotIm: Float
    @Binding var isZooming: Bool
    
    var body: some View {
        HStack {
            TextField("Enter Re(z)", value: $mandelbrotRe, format: .number)
                .frame(width: 200)
            TextField("Enter Im(z)", value: $mandelbrotIm, format: .number)
                .frame(width: 200)
            
            Toggle("Zoom", isOn: $isZooming)
            
            Spacer()
            
            Text("z = \(mandelbrotRe) + \(mandelbrotIm)i")
                .frame(width: 200)
        }
    }
}
