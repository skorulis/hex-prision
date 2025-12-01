//Created by Alexander Skorulis on 1/12/2025.

import Foundation
import SwiftUI

// MARK: - Memory footprint

@MainActor struct UpgradeButton {
    let upgrade: Upgrade
}

// MARK: - Rendering

extension UpgradeButton: View {
    
    var body: some View {
        Button(action: {}) {
            content
        }
    }
    
    private var content: some View {
        HexagonShape(radius: Hexagon.radius)
            .fill(upgrade.color)
            .frame(width: Hexagon.radius * 2, height: Hexagon.radius * 2)
    }
}

// MARK: - Previews

#Preview {
    UpgradeButton(upgrade: .memory)
}

