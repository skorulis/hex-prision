//Created by Alexander Skorulis on 29/11/2025.

import Foundation
import Knit
import KnitMacros
import SwiftUI

@Observable final class HexagonMapViewModel {
    
    private let mapStore: MapStore
    var map: HexagonMap
    
    @Resolvable<BaseResolver>
    init(mapStore: MapStore) {
        self.mapStore = mapStore
        self.map = mapStore.map
    }
}

// MARK: - Logic

extension HexagonMapViewModel {
    
    func toggle(index: Hexagon.Index) {
        map.toggleFlipped(index: index)
    }
}
