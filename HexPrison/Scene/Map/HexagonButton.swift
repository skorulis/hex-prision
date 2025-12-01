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
        .scaleEffect( (1 - dimming * 0.4) * (hexagon.status.lost ? 0.3 : 1) )
        .scaleEffect(hexagon.status.pulse ? 0.9 : 1)
        .brightness(-dimming * 0.9)
        .opacity(hexagon.status.lost ? 0 : 1)
        .animation(.easeOut(duration: 0.6), value: hexagon.status.lost)
        .animation(.easeInOut(duration: Constants.pulseDuration), value: hexagon.status.pulse)
    }
    
    private var content: some View {
        ZStack {
            // Front side
            HexagonShape(radius: Hexagon.radius)
                .fill(hexagon.type.color)
                .brightness(-0.1)
                .opacity(hexagon.status.flipped ? 0 : 1)
            
            back
        }
        .frame(width: Hexagon.radius * 2, height: Hexagon.radius * 2)
        .rotation3DEffect(
            .degrees(hexagon.status.flipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: hexagon.status.flipped)
    }
    
    private var back: some View {
        ZStack(alignment: .center) {
            // Back side (flipped) - rotated 180 degrees on Y axis
            HexagonShape(radius: Hexagon.radius)
                .fill(hexagon.type.color)
            
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.white)
        }
        .scaleEffect(x: -1, y: 1) // Mirror horizontally for back side
        .opacity(hexagon.status.flipped ? 1 : 0)
    }
    
    private func onPress() {
        action(hexagon.index)
    }
    
}
