//Created by Alexander Skorulis on 1/12/2025.

import Combine
import Foundation

final class UpgradeStore: ObservableObject {
    
    @Published var purchased: Set<Upgrade> = []
    
    init() {}
    
    func buy(upgrade: Upgrade) {
        purchased.insert(upgrade)
    }
    
}
