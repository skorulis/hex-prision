//  Created by Alexander Skorulis on 28/11/2025.

import Foundation
import SwiftUI

// Hexagon button view
struct HexagonButton: View {
    let hexagon: Hexagon
    let dimming: CGFloat
    let action: (Hexagon.Index) -> Void
    
    var body: some View {
        Button(action: onPress) {
            content
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1 - dimming * 0.4)
        .brightness(-dimming * 0.9)
    }
    
    private var content: some View {
        ZStack {
            // Front side
            HexagonShape(radius: Hexagon.radius)
                .fill(hexagon.type.color)
                .opacity(hexagon.flipped ? 0 : 1)
            
            // Back side (flipped) - rotated 180 degrees on Y axis
            HexagonShape(radius: Hexagon.radius)
                .fill(hexagon.type.color.opacity(0.5))
                .scaleEffect(x: -1, y: 1) // Mirror horizontally for back side
                .opacity(hexagon.flipped ? 1 : 0)
        }
        .frame(width: Hexagon.radius * 2, height: Hexagon.radius * 2)
        .rotation3DEffect(
            .degrees(hexagon.flipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: hexagon.flipped)
    }
    
    private func onPress() {
        action(hexagon.index)
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
