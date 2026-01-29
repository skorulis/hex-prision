//Created by Alexander Skorulis on 18/1/2026.

import ASKCoordinator
import Foundation
import SwiftUI

// MARK: - Memory footprint

@MainActor struct WalletView {
    @State var viewModel: WalletViewModel
}

// MARK: - Rendering

extension WalletView: View {
    
    var body: some View {
        PageLayout(
            titleBar: {
                TitleBar(
                    title: "Achievements",
                    backAction: { viewModel.coordinator?.pop() }
                )
            },
            content: {
                EmptyView()
            }
        )
    }
}

// MARK: - Previews

//#Preview {
//    let assembler = HexPrisonAssembly.testing()
//    WalletView(viewModel: assembler.resolver.walletViewModel())
//}
