//Created by Alexander Skorulis on 1/12/2025.

import Foundation
import SwiftUI

// MARK: - Memory footprint

@MainActor struct UpgradeButton {
    let upgrade: Upgrade
    let isOwned: Bool
    let action: () -> Void
    
    @Environment(\.isEnabled) private var isEnabled
}

// MARK: - Rendering

extension UpgradeButton: View {
    
    var body: some View {
        Button(action: action) {
            if isEnabled {
                content
            } else {
                Image(systemName: "lock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .buttonStyle(HexagonButtonStyle(color: upgrade.color))
    }
    
    private var content: some View {
        upgrade.icon
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct HexagonButtonStyle: ButtonStyle {
    
    let color: Color
    
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            HexagonShape(radius: Hexagon.radius)
                .fill(color)
            
            configuration.label
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.white)
        }
        .frame(width: Hexagon.radius * 2, height: Hexagon.radius * 2)
        .brightness(isEnabled ? 0 : -0.5)
        .brightness(configuration.isPressed ? -0.2 : 0)
        .scaleEffect(configuration.isPressed ? 0.94 : 1)
        .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
}

// MARK: - Previews

#Preview {
    UpgradeButton(upgrade: .memory, isOwned: true, action: {})
    UpgradeButton(upgrade: .memory, isOwned: false, action: {})
}

