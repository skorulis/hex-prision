//Created by Alexander Skorulis on 28/11/2025.

import Foundation

/// Container for the entire game map
struct HexagonMap {
    
    func get(index: Hexagon.Index) -> Hexagon {
        let hashMod = abs(index.hashValue) % 100
        if hashMod >= 99 {
            return .init(type: .permanent, index: index)
        }
        
        return .init(type: .basic, index: index)
    }
}
