//Created by Alexander Skorulis on 28/11/2025.

import Foundation

/// Container for the entire game map
struct HexagonMap {
    
    private var statuses: [Hexagon.Index: Hexagon.Status] = [:]
    
    mutating func set(flipped: Bool, index: Hexagon.Index) {
        statuses[index] = flipped ? .flipped : .normal
    }
    
    mutating func toggleFlipped(index: Hexagon.Index) {
        var status = statuses[index] ?? .normal
        status.lost.toggle()
        statuses[index] = status
    }
    
    func get(index: Hexagon.Index) -> Hexagon {
        let status = statuses[index] ?? .normal
        let type = getType(index: index)
        return .init(
            type: type,
            index: index,
            status: status,
        )
    }
    
    private func getType(index: Hexagon.Index) -> HexagonType {
        let hashMod = abs(index.stableHashValue) % 100
        if hashMod >= 99 {
            return .permanent
        } else {
            return .basic
        }
    }
}
