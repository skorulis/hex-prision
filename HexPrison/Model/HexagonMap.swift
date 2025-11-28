//Created by Alexander Skorulis on 28/11/2025.

import Foundation

/// Container for the entire game map
struct HexagonMap {
    
    private var flippedHexagons: [Hexagon.Index: Bool] = [:]
    
    mutating func set(flipped: Bool, index: Hexagon.Index) {
        flippedHexagons[index] = flipped
    }
    
    mutating func toggleFlipped(index: Hexagon.Index) {
        var flipped = flippedHexagons[index] ?? false
        flipped.toggle()
        flippedHexagons[index] = flipped
    }
    
    func get(index: Hexagon.Index) -> Hexagon {
        let flipped = flippedHexagons[index] ?? false
        let hashMod = abs(index.stableHashValue) % 100
        if hashMod >= 99 {
            return .init(
                type: .permanent,
                index: index,
                flipped: flipped,
            )
        }
        
        return .init(
            type: .basic,
            index: index,
            flipped: flipped,
        )
    }
}
