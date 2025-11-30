//Created by Alexander Skorulis on 30/11/2025.

import Foundation

nonisolated enum HexGridMath {
    
    static let horizontalSpacing = Hexagon.width + Hexagon.spacing
    static let verticalSpacing = Hexagon.radius * 1.5 + Hexagon.spacing
    
    // Convert pixel X position (in world coordinates) to hexagon column index
    nonisolated static func pixelToColumn(x: CGFloat) -> Int {
        // Account for the initial grid offset
        let adjustedX = x - (Hexagon.width / 2 + Hexagon.spacing / 2)
        return Int(floor(adjustedX / horizontalSpacing))
    }
    
    // Convert pixel Y position (in world coordinates) to hexagon row index
    nonisolated static func pixelToRow(y: CGFloat) -> Int {
        // Account for the initial grid offset
        let adjustedY = y - (Hexagon.radius + Hexagon.spacing / 2)
        return Int(floor(adjustedY / verticalSpacing))
    }
    
    static func toIndex(point: CGPoint) -> Hexagon.Index {
        let column = Self.pixelToColumn(x: point.x)
        let row = Self.pixelToRow(y: point.y)
        return .init(row: row, column: column)
    }
    
    /// Returns an array of all adjacent hexagon indices (6 neighbors)
    /// - Parameter index: The hexagon index to find neighbors for
    /// - Returns: Array of Hexagon.Index values representing all 6 adjacent hexagons
    static func adjacentIndices(index: Hexagon.Index) -> [Hexagon.Index] {
        let row = index.row
        let col = index.column
        
        var offset = (row + 1) % 2
        if row < 0 {
            offset += 2
        }
        
        return [
            // Top-left and top-right neighbors (row above)
            .init(row: row - 1, column: col - offset),
            .init(row: row - 1, column: col + 1 - offset),
            // Left and right neighbors (same row)
            .init(row: row, column: col - 1),
            .init(row: row, column: col + 1),
            // Bottom-left and bottom-right neighbors (row below)
            .init(row: row + 1, column: col - offset),
            .init(row: row + 1, column: col + 1 - offset),
        ]
    }
}
