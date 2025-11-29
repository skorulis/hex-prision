//Created by Alexander Skorulis on 29/11/2025.

import Foundation
import Knit
import KnitMacros

final class HexagonEventService {
    
    private var events: [Event] = []
    
    let mapStore: MapStore
    
    private var timer: Timer?
    
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
        resetTimer()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        
        guard let nextEvent else {
            return
        }
        
        let interval = nextEvent.time.timeIntervalSinceNow
        timer = .scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            self?.action(event: nextEvent)
            self?.resetTimer()
        }
    }
    
    private func action(event: Event) {
        clearEvent(index: event.index)
        switch event.type {
        case .lost:
            mapStore.map.setLost(index: event.index)
        }
    }
    
    private var nextEvent: Event? {
        let index = events.enumerated().min(by: { $0.element.time < $1.element.time })
        guard let index else { return nil }
        return events[index.offset]
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
