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
    
    mutating func add(currency: Currency, amount: Double) {
        balance[currency] = self.amount(currency) + amount
    }
    
    func amount(_ currency: Currency) -> Double {
        balance[currency] ?? 0
    }
    
    mutating func add(wallet: Wallet) {
        for (key, value) in wallet.balance {
            add(currency: key, amount: value)
        }
    }
}
