//
//  HexagonButton.swift
//  HexPrison
//
//  Created by Alexander Skorulis on 28/11/2025.
//

import Foundation
import SwiftUI

// Hexagon button view
struct HexagonButton: View {
    let index: Hexagon.Index
    let dimming: CGFloat
    let action: (Hexagon.Index) -> Void
    
    var body: some View {
        Button(action: { action(index) }) {
            HexagonShape(radius: Hexagon.radius)
                .fill(Hexagon.color(index: index))
                .frame(width: Hexagon.radius * 2, height: Hexagon.radius * 2)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1 - dimming * 0.4)
        .brightness(-dimming * 0.9)
    }
    
}

// Hexagon shape
struct HexagonShape: Shape {
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // Create a flat-top hexagon
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3 - .pi / 6 // Start at -30 degrees for flat-top
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        return path
    }
}
