//Created by Alexander Skorulis on 18/1/2026.

import Knit
import Foundation
import SwiftUI

// MARK: - Memory footprint

@MainActor struct AchievementListView {
    
    @State var viewModel: AchievementListViewModel
}

// MARK: - Rendering

extension AchievementListView: View {
    
    var body: some View {
        PageLayout(
            titleBar: { TitleBar(title: "Achievements") },
            content: { content }
        )
    }
    
    private var content: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
            ForEach(Achievement.all) { ach in
                button(for: ach)
            }
        }
    }
    
    private func button(for achievement: Achievement) -> some View {
        Button(action: {}) {
            ZStack {
                achievement.icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(achievement.color)
            }
            .frame(width: 72, height: 72)
            .border(Color.white, width: 2)
            .brightness(hasReached(achievement: achievement) ? 0 : -0.5)
        }
    }
    
    private func hasReached(achievement: Achievement) -> Bool {
        return viewModel.achievements.contains(achievement)
    }
}

// MARK: - Previews

#Preview {
    let assembler = HexPrisonAssembly.testing()
    AchievementListView(viewModel: assembler.resolver.achievementListViewModel())
}

