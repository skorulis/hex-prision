//  Created by Alexander Skorulis on 28/11/2025.

import Foundation
import SwiftUI

struct Hexagon {
    
    let type: HexagonType
    let index: Index
    
    // Radius of each hexagon (center to vertex)
    static let radius: CGFloat = 30
    
    static let width = Hexagon.radius * sqrt(3)
    
    // Space between hexagons
    static let spacing: CGFloat = 6
}

extension Hexagon {
    struct Index: Hashable {
        let row: Int
        let column: Int
    }
    
    // Visible range of hexagons
    struct VisibleRange {
        let rows: Range<Int>
        let columns: Range<Int>
    }
}
