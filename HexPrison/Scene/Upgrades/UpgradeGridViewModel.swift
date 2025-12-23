//Created by Alexander Skorulis on 1/12/2025.

import ASKCoordinator
import Combine
import Foundation
import Knit
import KnitMacros
import SwiftUI

@Observable final class UpgradeGridViewModel: CoordinatorViewModel {
    
    var coordinator: Coordinator?
    private let upgradeStore: UpgradeStore
    
    var purchased: Set<Upgrade>
    var cancellables: Set<AnyCancellable> = []
    
    var selection: Upgrade?
    
    @Resolvable<BaseResolver>
    init(upgradeStore: UpgradeStore) {
        self.upgradeStore = upgradeStore
        self.purchased = upgradeStore.purchased
        upgradeStore.$purchased.sink { [unowned self] value in
            self.purchased = value
        }
        .store(in: &cancellables)
    }
}

// MARK: - Logic

extension UpgradeGridViewModel {
    
    func purchase(upgrade: Upgrade) {
        upgradeStore.purchased.insert(upgrade)
    }
    
    func canPurcahse(upgrade: Upgrade) -> Bool {
        if upgrade.index == .origin {
            return true
        }
        let adjacent = HexGridMath.adjacentIndices(index: upgrade.index)
        for index in adjacent {
            guard let other = Upgrade.byIndex[index] else { continue }
            if upgradeStore.purchased.contains(other) {
                return true
            }
        }
        
        return false
    }
    
}
