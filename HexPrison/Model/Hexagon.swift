//  Created by Alexander Skorulis on 28/11/2025.

import Foundation
import SwiftUI

struct Hexagon {
    
    let type: HexagonType
    let index: Index
    let flipped: Bool
    
    // Radius of each hexagon (center to vertex)
    static let radius: CGFloat = 30
    
    static let width = Hexagon.radius * sqrt(3)
    
    // Space between hexagons
    static let spacing: CGFloat = 6
}

extension Hexagon {
    struct Index: Hashable, Identifiable {
        let row: Int
        let column: Int
        
        /// Stable, deterministic hash independent of Swift's randomised hasher.
        /// Use this whenever the hash must be the same between application runs.
        var stableHashValue: Int {
            var hash = 17
            hash = hash &* 31 &+ row
            hash = hash &* 31 &+ column
            return hash
        }
        
        var id: String {
            "\(row)-\(column)"
        }
    }
    
    // Visible range of hexagons
    struct VisibleRange {
        let rows: Range<Int>
        let columns: Range<Int>
    }
}
