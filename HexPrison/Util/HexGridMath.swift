//Created by Alexander Skorulis on 30/11/2025.

import Foundation

enum HexGridMath {
    
    static let horizontalSpacing = Hexagon.width + Hexagon.spacing
    static let verticalSpacing = Hexagon.radius * 1.5 + Hexagon.spacing
    
    // Convert pixel X position (in world coordinates) to hexagon column index
    static func pixelToColumn(x: CGFloat) -> Int {
        // Account for the initial grid offset
        let adjustedX = x - (Hexagon.width / 2 + Hexagon.spacing / 2)
        return Int(floor(adjustedX / horizontalSpacing))
    }
    
    // Convert pixel Y position (in world coordinates) to hexagon row index
    static func pixelToRow(y: CGFloat) -> Int {
        // Account for the initial grid offset
        let adjustedY = y - (Hexagon.radius + Hexagon.spacing / 2)
        return Int(floor(adjustedY / verticalSpacing))
    }
    
    static func toIndex(point: CGPoint) -> Hexagon.Index {
        let column = Self.pixelToColumn(x: point.x)
        let row = Self.pixelToRow(y: point.y)
        return .init(row: row, column: column)
    }
}
