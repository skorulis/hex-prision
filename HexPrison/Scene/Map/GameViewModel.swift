//Created by Alexander Skorulis on 1/12/2025.

import ASKCoordinator
import Foundation
import Knit
import KnitMacros
import SwiftUI

@Observable final class GameViewModel: CoordinatorViewModel {
    
    var coordinator: Coordinator?
    let mapViewModel: HexagonMapViewModel
    
    @Resolvable<BaseResolver>
    init(mapViewModel: HexagonMapViewModel) {
        self.mapViewModel = mapViewModel
    }
}

// MARK: - Logic

extension GameViewModel {
    
    func showUpgrades() {
        coordinator?.push(MainPath.upgrades)
    }
    
}
