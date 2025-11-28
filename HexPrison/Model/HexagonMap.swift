//Created by Alexander Skorulis on 28/11/2025.

import Foundation

/// Container for the entire game map
struct HexagonMap {
    
    func get(index: Hexagon.Index) -> Hexagon {
        .init(type: .basic, index: index)
    }
}
