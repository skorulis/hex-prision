//Created by Alexander Skorulis on 1/12/2025.

import Foundation
import Knit
import KnitMacros
import SwiftUI

@Observable final class UpgradeGridViewModel {
    
    private let upgradeStore: UpgradeStore
    
    @Resolvable<BaseResolver>
    init(upgradeStore: UpgradeStore) {
        self.upgradeStore = upgradeStore
    }
}

// MARK: - Logic

extension UpgradeGridViewModel {
    
    func canPurcahse(upgrade: Upgrade) -> Bool {
        if upgrade.index == .origin {
            return true
        }
        return false
    }
    
}
