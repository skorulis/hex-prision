//Created by Alexander Skorulis on 18/1/2026.

import ASKCoordinator
import Combine
import Foundation
import Knit
import KnitMacros
import SwiftUI

@Observable final class WalletViewModel: CoordinatorViewModel {
    
    var coordinator: Coordinator?
    var wallet: Wallet
    private var cancellables: Set<AnyCancellable> = []
    
    @Resolvable<BaseResolver>
    init(playerStore: PlayerStore) {
        self.wallet = playerStore.wallet
        
        playerStore.$wallet.sink { wallet in
            self.wallet = wallet
        }
        .store(in: &cancellables)
    }
}

// MARK: - Logic

extension WalletViewModel {}
