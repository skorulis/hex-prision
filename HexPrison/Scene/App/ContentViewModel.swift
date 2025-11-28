//Created by Alexander Skorulis on 28/11/2025.

import Foundation
import Knit
import KnitMacros
import SwiftUI

@Observable final class ContentViewModel {
    
    let mapStore: MapStore
    
    @Resolvable<BaseResolver>
    init(mapStore: MapStore) {
        self.mapStore = mapStore
    }
}

// MARK: - Logic

extension ContentViewModel {}
