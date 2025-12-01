//Created by Alexander Skorulis on 1/12/2025.

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
        ScrollView([.horizontal, .vertical]) {
            grid
        }
        .background(Color.black)
    }
    
    private var grid: some View {
        ZStack {
            ForEach(Upgrade.allCases) { upgrade in
                UpgradeButton(upgrade: upgrade)
                    .position(
                        HexGridMath.position(
                            row: upgrade.index.row,
                            column: upgrade.index.column,
                            offset: .zero
                        )
                    )
            }
        }
        //.offset(x: 100, y: 100)
    }
    
    private func button(upgrade: Upgrade) -> some View {
        Button(action: {}) {
            HexagonShape(radius: Hexagon.radius)
                .fill(upgrade.color)
        }
    }
}

// MARK: - Previews

#Preview {
    let assembler = HexPrisonAssembly.testing()
    UpgradeGridView(viewModel: assembler.resolver.upgradeGridViewModel(),)
}

