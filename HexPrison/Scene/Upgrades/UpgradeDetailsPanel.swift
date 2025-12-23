//Created by Alexander Skorulis on 4/12/2025.

import Foundation
import SwiftUI

// MARK: - Memory footprint

@MainActor struct UpgradeDetailsPanel {
    let upgrade: Upgrade
    let money: Int
    let isPurchased: Bool
    let onBuy: () -> Void
}

// MARK: - Rendering

extension UpgradeDetailsPanel: View {
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(upgrade.longDescription)
            }
            Spacer()
            maybeBuyButton
        }
        .foregroundStyle(Color.white)
        .padding(16)
        .background(Color.gray.opacity(0.2))
        .background(Color.black)
    }
    
    @ViewBuilder
    private var maybeBuyButton: some View {
        if !isPurchased {
            Button(action: onBuy) {
                Text("Buy")
            }
            .buttonStyle(RectangleButtonStyle())
            .disabled(upgrade.cost > money)
        }
    }
    
    private var title: String {
        "\(upgrade.name)   \(upgrade.cost)c"
    }
}

// MARK: - Previews

#Preview {
    VStack {
        Spacer()
        UpgradeDetailsPanel(
            upgrade: .knowledge,
            money: 10,
            isPurchased: false,
            onBuy: {}
        )
    }
    .background(Color.black)
    
}

