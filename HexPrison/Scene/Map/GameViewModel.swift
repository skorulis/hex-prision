//Created by Alexander Skorulis on 1/12/2025.

import ASKCoordinator
import Combine
import Foundation
import Knit
import KnitMacros
import SwiftUI

@Observable final class GameViewModel: CoordinatorViewModel {
    
    var coordinator: Coordinator?
    let mapViewModel: HexagonMapViewModel
    
    private var achievements: Set<Achievement> = []
    private var cancellables: Set<AnyCancellable> = []
    
    private(set) var wallet: Wallet
    
    @Resolvable<BaseResolver>
    init(
        mapViewModel: HexagonMapViewModel,
        playerStore: PlayerStore,
        statStore: StatStore,
    ) {
        self.mapViewModel = mapViewModel
        self.wallet = playerStore.wallet
        
        self.achievements = statStore.achievements
        statStore.$achievements.sink { [unowned self] newValue in
            let newlyAdded = newValue.subtracting(self.achievements)
            self.achievements = newValue
            
            for new in newlyAdded {
                showToast(achievement: new)
            }
        }
        .store(in: &cancellables)
        
        playerStore.$wallet.sink { [unowned self] in
            self.wallet = $0
        }
        .store(in: &cancellables)
    }
}

// MARK: - Logic

extension GameViewModel {
    
    private func showToast(achievement: Achievement) {
        coordinator?.custom(overlay: .toast, ToastPath.unlockAchievement(achievement))
    }
    
    func showUpgrades() {
        coordinator?.push(MainPath.upgrades)
    }
    
    func showAchievements() {
        coordinator?.push(MainPath.achievements)
    }
    
}
