//Created by Alexander Skorulis on 4/1/2026.

import Combine
import Foundation

final class PlayerStore: ObservableObject {
    
    @Published var wallet = Wallet()
}
