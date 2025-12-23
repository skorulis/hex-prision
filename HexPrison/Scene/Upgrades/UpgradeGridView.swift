//Created by Alexander Skorulis on 1/12/2025.

import ASKCoordinator
import Foundation
import Knit
import SwiftUI

// MARK: - Memory footprint

@MainActor struct UpgradeGridView {
    @State var viewModel: UpgradeGridViewModel
}

// MARK: - Rendering

extension UpgradeGridView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            TitleBar(
                title: "Upgrades",
                backAction: { viewModel.coordinator?.pop() }
            )
            ScrollView([.horizontal, .vertical]) {
                grid
            }
            .background(Color.black)
            maybeSelectionView
        }
        .navigationBarHidden(true)
    }
    
    private var grid: some View {
        ZStack {
            ForEach(Upgrade.allCases) { upgrade in
                UpgradeButton(
                    upgrade: upgrade,
                    isOwned: isPurchased(upgrade: upgrade),
                    action: { viewModel.selection = upgrade}
                )
                    .position(
                        HexGridMath.position(
                            row: upgrade.index.row,
                            column: upgrade.index.column,
                            offset: .zero
                        )
                    )
                    .disabled(!viewModel.canPurcahse(upgrade: upgrade))
            }
        }
        //.offset(x: 100, y: 100)
    }
    
    @ViewBuilder
    private var maybeSelectionView: some View {
        if let selection = viewModel.selection {
            UpgradeDetailsPanel(
                upgrade: selection,
                money: 0,
                isPurchased: isPurchased(upgrade: selection),
                onBuy: { viewModel.purchase(upgrade: selection) }
            )
        }
    }
    
    func isPurchased(upgrade: Upgrade) -> Bool {
        return viewModel.purchased.contains(upgrade)
    }
}

// MARK: - Previews

#Preview {
    let assembler = HexPrisonAssembly.testing()
    UpgradeGridView(viewModel: assembler.resolver.upgradeGridViewModel(),)
}

