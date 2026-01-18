//Created by Alexander Skorulis on 4/1/2026.

import Foundation
import Knit
import KnitMacros

final class IncomeService {
    
    private let playerStore: PlayerStore
    private let mapStore: MapStore
    private let statStore: StatStore
    
    private var timer: Timer?
    
    @Resolvable<BaseResolver>
    init(playerStore: PlayerStore, mapStore: MapStore, statStore: StatStore) {
        self.playerStore = playerStore
        self.mapStore = mapStore
        self.statStore = statStore
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
        for index in squares {
            let status = mapStore.map.status(index: index)
            gainWallet.add(currency: status.shape.currency, amount: 1)
        }
        
        playerStore.wallet.add(wallet: gainWallet)
        statStore.totalEarnings.add(wallet: gainWallet)
    }
}
