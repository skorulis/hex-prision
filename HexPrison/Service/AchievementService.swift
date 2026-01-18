//Created by Alexander Skorulis on 16/1/2026.

import Combine
import Foundation
import Knit
import KnitMacros

final class AchievementService {
    
    private let stateStore: StatStore
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var currentEarnings: Wallet = Wallet()
    
    @Resolvable<BaseResolver>
    init(statStore: StatStore) {
        self.stateStore = statStore
        
        stateStore.$totalEarnings.sink { [unowned self] in
            self.currentEarnings = $0
            self.checkAchievements()
        }
        .store(in: &cancellables)
    }
    
    private func checkAchievements() {
        for achievement in Achievement.all {
            guard !stateStore.achievements.contains(achievement) else {
                continue
            }
            if hasCompleted(achievement: achievement) {
                stateStore.achievements.insert(achievement)
            }
        }
    }
    
    private func hasCompleted(achievement: Achievement) -> Bool {
        switch achievement {
        case let .earnDots(double):
            return currentEarnings.amount(.dot) >= double
        case let .earnTriangles(double):
            return currentEarnings.amount(.triangle) >= double
        case let .earnHexagons(double):
            return currentEarnings.amount(.hexagon) >= double
        }
    }
}
