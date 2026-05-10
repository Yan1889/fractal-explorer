//
//  GC_operators.swift
//  SwiftUI-test
//
//  Created by Yan Amin on 10.05.26.
//

import Foundation

extension CGPoint {
    static func + (a: Self, b: Self) -> Self {
        return Self(
            x: a.x + b.x,
            y: a.y + b.y,
        );
    }
    
    static func - (a: Self, b: Self) -> Self {
        return Self(
            x: a.x - b.x,
            y: a.y - b.y,
        );
    }
    
    static prefix func - (a: Self) -> Self {
        return Self(
            x: -a.x,
            y: -a.y,
        );
    }
    
    static func * (a: Self, b: Self) -> Self {
        return Self(
            x: a.x * b.x,
            y: a.y * b.y,
        );
    }
    
    static func * (v: Self, s: CGFloat) -> Self {
        return Self(
            x: v.x * s,
            y: v.y * s,
        );
    }
    
    static func / (v: Self, s: CGFloat) -> Self {
        return Self(
            x: v.x / s,
            y: v.y / s,
        );
    }
}
