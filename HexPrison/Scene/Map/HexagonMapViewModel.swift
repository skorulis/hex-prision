//Created by Alexander Skorulis on 29/11/2025.

import Combine
import Foundation
import Knit
import KnitMacros
import SwiftUI

@Observable final class HexagonMapViewModel {
    
    private let hexagonEventService: HexagonEventService
    
    private let mapStore: MapStore
    private(set) var map: HexagonMap
    private var cancellables: Set<AnyCancellable> = []
    
    @Resolvable<BaseResolver>
    init(mapStore: MapStore, hexagonEventService: HexagonEventService) {
        self.mapStore = mapStore
        self.map = mapStore.map
        self.hexagonEventService = hexagonEventService
        
        mapStore.$map.sink { [unowned self] value in
            self.map = value
        }
        .store(in: &cancellables)
    }
}

// MARK: - Logic

extension HexagonMapViewModel {
    
    func toggle(index: Hexagon.Index) {
        mapStore.map.toggleFlipped(index: index)
        let hex = mapStore.map.get(index: index)
        if hex.status.flipped && hex.type != .permanent {
            hexagonEventService.addEvent(
                index: index,
                type: .lost,
                time: Date().addingTimeInterval(5)
            )
        } else {
            hexagonEventService.clearEvent(index: index)
        }
    }
}
