//Created by Alexander Skorulis on 4/1/2026.

import Foundation
import SwiftUI

nonisolated enum Currency: Hashable, Codable, CaseIterable, Identifiable {
    
    /// Base currency
    case dot
    
    case triangle
    
    case hexagon
    
    var id: Self { self }
    
    var text: String {
        switch self {
        case .dot:
            return "Dot"
        case .triangle:
            return "Triangle"
        case .hexagon:
            return "Hexagon"
        }
    }
    
    var image: Image {
        switch self {
        case .dot:
            return Image(systemName: "circle.fill")
        case .triangle:
            return Image(systemName: "triangle.fill")
        case .hexagon:
            return Image(systemName: "hexagon.fill")
        }
    }
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
    
    var total: Double {
        return balance.values.reduce(0, +)
    }
}
