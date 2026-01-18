//Created by Alexander Skorulis on 18/1/2026.

import ASKCoordinator
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
            titleBar: {
                TitleBar(
                    title: "Achievements",
                    backAction: { viewModel.coordinator?.pop() }
                )
            },
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
            ZStack(alignment: .center) {
                Color.black
                
                achievement.icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(achievement.color)
                    .brightness(hasReached(achievement: achievement) ? 0 : -0.5)
                
                VStack {
                    Spacer()
                    Text(achievement.text)
                        .foregroundStyle(Color.white)
                }
                
            }
            .frame(width: 72, height: 72)
            .border(Color.white, width: 2)
            
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

