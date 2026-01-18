//Created by Alexander Skorulis on 18/1/2026.

import ASKCoordinator
import Combine
import Foundation
import Knit
import KnitMacros
import SwiftUI

@Observable final class AchievementListViewModel: CoordinatorViewModel {
    
    var coordinator: Coordinator?
    var achievements: Set<Achievement> = []
    private var cancellables: Set<AnyCancellable> = []
    
    @Resolvable<BaseResolver>
    init(statStore: StatStore) {
        achievements = statStore.achievements
        statStore.$achievements.sink { [unowned self] in
            self.achievements = $0
        }
        .store(in: &cancellables)
    }
}

// MARK: - Logic

extension AchievementListViewModel {}
