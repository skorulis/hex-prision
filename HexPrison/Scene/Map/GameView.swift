//Created by Alexander Skorulis on 1/12/2025.

import Foundation
import Knit
import SwiftUI

// MARK: - Memory footprint

struct GameView: View {
    @State private var scrollOffset: CGPoint = .zero
    
    @State var viewModel: GameViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // ScrollView wrapper with SwiftUI content
            ScrollViewWrapper(
                config: .default,
                scrollOffset: $scrollOffset
            ) { offset in
                HexagonMapView(viewModel: viewModel.mapViewModel, viewPort: offset)
            }
            .ignoresSafeArea()
            
            bottomButtons
        }
        .background(Color.black)
    }
    
    private var bottomButtons: some View {
        HStack {
            Spacer()
            upgradeButton
        }
        .padding(.horizontal, 24)
    }
    
    private var upgradeButton: some View {
        Button(action: viewModel.showUpgrades) {
            Image(systemName: "arrow.up.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundStyle(Color.white)
        }
    }
}

#Preview {
    let assembler = HexPrisonAssembly.testing()
    GameView(viewModel: assembler.resolver.gameViewModel())
}
