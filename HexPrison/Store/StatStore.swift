//Created by Alexander Skorulis on 16/1/2026.

import Combine
import Foundation

/// Storage for the players statistics
final class StatStore: ObservableObject {
    
    // Storage for total player earnings over time
    @Published var totalEarnings = Wallet()
    
    // Achievements the player has earned
    @Published var achievements: Set<Achievement> = []
}

