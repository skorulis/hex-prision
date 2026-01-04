//Created by Alexander Skorulis on 4/1/2026.

import Foundation
import Knit
import KnitMacros

final class IncomeService {
    
    private let playerStore: PlayerStore
    private let mapStore: MapStore
    
    private var timer: Timer?
    
    @Resolvable<BaseResolver>
    init(playerStore: PlayerStore, mapStore: MapStore) {
        self.playerStore = playerStore
        self.mapStore = mapStore
    }
}

extension IncomeService {
    
    func start() {
        timer = .scheduledTimer(withTimeInterval: 4, repeats: true, block: { [weak self] _ in
            self?.gainIncome()
        })
    }
    
    func gainIncome() {
        
        let squares = mapStore.map.getActive()
        var gainWallet = Wallet()
        for square in squares {
            gainWallet.add(currency: .dot, amount: 1)
        }
        
        print("Calculating income: \(gainWallet.balance)")
        
        playerStore.wallet.add(wallet: gainWallet)
    }
}
