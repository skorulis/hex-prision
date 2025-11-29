//Created by Alexander Skorulis on 29/11/2025.

import Foundation
import Knit
import KnitMacros

final class HexagonEventService {
    
    private var events: [Event] = []
    
    let mapStore: MapStore
    
    @Resolvable<BaseResolver>
    init(mapStore: MapStore) {
        self.mapStore = mapStore
    }
    
    func clearEvent(index: Hexagon.Index) {
        events = events.filter { $0.index != index }
    }
    
    func addEvent(index: Hexagon.Index, type: EventType, time: Date) {
        clearEvent(index: index)
        events.append(Event(index: index, time: time, type: type))
    }
    
    func resetTimer() {
        
    }
    
}

extension HexagonEventService {
    
    struct Event {
        let index: Hexagon.Index
        let time: Date
        let type: EventType
    }
    
    enum EventType {
        // Set the hexagon to lost
        case lost
    }
}
