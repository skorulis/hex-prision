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
            
            overlay
        }
        .background(Color.black)
    }
    
    private var overlay: some View {
        VStack {
            topButtons
            Spacer()
            bottomButtons
        }
    }
    
    private var topButtons: some View {
        HStack {
            Spacer()
            WalletButton(wallet: viewModel.wallet)
        }
    }
    
    private var bottomButtons: some View {
        HStack(spacing: 8) {
            Spacer()
            achievmentsButton
            upgradeButton
        }
        .padding(.horizontal, 24)
    }
    
    private var achievmentsButton: some View {
        Button(action: viewModel.showAchievements) {
            Image(systemName: "star.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundStyle(Color.white)
        }
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
