//Created by Alexander Skorulis on 4/1/2026.

import Foundation

nonisolated enum Currency: Hashable, Codable {
    
    /// Base currency
    case dot
}

struct Wallet: Codable {
 
    // The current balance
    private(set) var balance: [Currency: Double]
    
    init(balance: [Currency: Double] = [:]) {
        self.balance = balance
    }
}
