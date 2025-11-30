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
        resetTimer()
    }
    
    func clearSame(event: Event) {
        events = events.filter { $0 != event }
    }
    
    func addEvent(index: Hexagon.Index, type: EventType, time: TimeInterval) {
        let event = Event(index: index, time: Date().addingTimeInterval(time), type: type)
        clearSame(event: event)
        events.append(event)
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
        clearSame(event: event)
        switch event.type {
        case .lost:
            mapStore.map.setLost(index: event.index)
            addEvent(index: event.index, type: .recover, time: Constants.recoverTime)
        case .recover:
            mapStore.map.reset(index: event.index)
        case .unpulse:
            mapStore.map.set(pulse: false, index: event.index)
        }
    }
    
    private var nextEvent: Event? {
        let index = events.enumerated().min(by: { $0.element.time < $1.element.time })
        guard let index else { return nil }
        return events[index.offset]
    }
    
}

extension HexagonEventService {
    
    struct Event: Equatable {
        let index: Hexagon.Index
        let time: Date
        let type: EventType
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.index == rhs.index && lhs.type == rhs.type
        }
    }
    
    enum EventType: Equatable {
        // Set the hexagon to lost
        case lost
        
        // The hexagon returns to the default state
        case recover
        
        // Remove pulse effect
        case unpulse
    }
}
