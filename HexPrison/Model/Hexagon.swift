//  Created by Alexander Skorulis on 28/11/2025.

import Foundation
import SwiftUI

nonisolated struct Hexagon {
    
    let type: HexagonType
    let index: Index
    let status: Status
    
    // Radius of each hexagon (center to vertex)
    static let radius: CGFloat = 30
    
    static let width = Hexagon.radius * sqrt(3)
    
    // Space between hexagons
    static let spacing: CGFloat = 6
}

// MARK: - Inner Types

extension Hexagon {
    
    struct Status {
        var flipped: Bool
        var lost: Bool
        var pulse: Bool
        
        init(flipped: Bool = false, lost: Bool = false, pulse: Bool = false) {
            self.flipped = flipped
            self.lost = lost
            self.pulse = pulse
        }
        
        static var normal: Self { .init(flipped: false, lost: false) }
        static var flipped: Self { .init(flipped: true, lost: false) }
    }
    
    nonisolated struct Index: nonisolated Hashable, Identifiable {
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
        
        func move(direction: Direction, amount: Int) -> Self {
            HexGridMath.move(index: self, direction: direction, amount: amount)
        }
    }
    
    /// Visible range of hexagons
    struct VisibleRange {
        let rows: Range<Int>
        let columns: Range<Int>
    }
    
    /// Direction from this hexagon
    enum Direction {
        case left, right
        case leftTop, rightTop
        case leftBottom, rightBottom
    }
}
