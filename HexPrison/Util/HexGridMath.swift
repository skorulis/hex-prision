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
    
    // Calculate position for a hexagon at given row and column, accounting for offset
    static func position(row: Int, column: Int, offset: CGPoint) -> CGPoint {
        // Center-to-center horizontal spacing
        let horizontalSpacing = Hexagon.width + Hexagon.spacing
        // Center-to-center vertical spacing
        let verticalSpacing = Hexagon.radius * 1.5 + Hexagon.spacing
        
        // Start position: account for hexagon radius so first hex doesn't get clipped
        let startX = Hexagon.width / 2 + Hexagon.spacing / 2
        let startY = Hexagon.radius + Hexagon.spacing / 2
        
        // Offset every other row by half the horizontal spacing for proper hex grid
        let xOffset: CGFloat = row % 2 == 0 ? 0 : horizontalSpacing / 2
        
        // Calculate base position
        let baseX = startX + CGFloat(column) * horizontalSpacing + xOffset
        let baseY = startY + CGFloat(row) * verticalSpacing
        
        // Apply the offset to move the grid
        return CGPoint(x: baseX - offset.x, y: baseY - offset.y)
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
    
    /// Returns an array of all hexagon indices in a ring around a central point
    /// - Parameters:
    ///   - center: The central hexagon index
    ///   - radius: The radius of the ring (distance from center). For radius 1, this returns the same as adjacentIndices
    /// - Returns: Array of Hexagon.Index values representing all hexagons in the ring
    static func ringIndices(center: Hexagon.Index, radius: Int) -> [Hexagon.Index] {
        guard radius > 0 else {
            return [center]
        }
        
        var indices: [Hexagon.Index] = []
        let directions: [Hexagon.Direction] = [.rightTop, .right, .rightBottom, .leftBottom, .left, .leftTop]
        
        var currentIndex = center.move(direction: .left, amount: radius)
        for direction in directions {
            for _ in 1...radius {
                currentIndex = currentIndex.move(direction: direction, amount: 1)
                indices.append(currentIndex)
            }
        }
        
        return indices
    }
    
    /// Calculate the sum of offsets for a range of consecutive rows (closed-form formula)
    /// Offset formula: offset = (row + 1) % 2 + (row < 0 ? 2 : 0)
    /// Even rows contribute 1, odd rows contribute 0 (for non-negative)
    /// Negative rows add 2 to their base offset
    private static func sumOffsets(startRow: Int, count: Int, direction: Int) -> Int {
        guard count > 0 else { return 0 }
        
        let step = direction < 0 ? -1 : 1
        let endRow = startRow + (count - 1) * step
        
        // Count even rows: ceil(count/2) if start is even, floor(count/2) if start is odd
        let evenCount = (count + (startRow % 2 == 0 ? 1 : 0)) / 2
        
        // Calculate negative row adjustment: +2 for each negative row in the range
        var sum = evenCount
        if endRow < 0 {
            let negativeEnd = min(endRow, -1)
            let negativeCount = negativeEnd - endRow + 1
            sum += negativeCount * 2
        }
        
        return sum - (startRow < 0 ? 2 : 0)
    }
    
    /// Move from the start index in a straight line along a given direction
    static func move(index: Hexagon.Index, direction: Hexagon.Direction, amount: Int) -> Hexagon.Index {
        
        let row: Int
        switch direction {
        case .left, .right:
            row = index.row
        case .leftTop, .rightTop:
            row = index.row - amount
        case .leftBottom, .rightBottom:
            row = index.row + amount
            
        }
        
        var column: Int
        switch direction {
        case .left:
            column = index.column - amount
        case .right:
            column = index.column + amount
        case .leftTop:
            // Column decreases by sum of offsets from rows we step through (moving up)
            let offsetSum = sumOffsets(startRow: index.row, count: amount, direction: -1)
            column = index.column - offsetSum
        case .rightTop:
            // Column increases by (amount - sum of offsets) from rows we step through
            let offsetSum = sumOffsets(startRow: index.row, count: amount, direction: -1)
            column = index.column + amount - offsetSum
        case .leftBottom:
            // Column decreases by sum of offsets from rows we step through (moving down)
            let offsetSum = sumOffsets(startRow: index.row, count: amount, direction: 1)
            column = index.column - offsetSum
        case .rightBottom:
            // Column increases by (amount - sum of offsets) from rows we step through
            let offsetSum = sumOffsets(startRow: index.row, count: amount, direction: 1)
            column = index.column + amount - offsetSum
        }
        
        return .init(row: row, column: column)
    }
    
    /// Convert a set of indexes into ordered rows
    static func rows(indexes: [Hexagon.Index]) -> [Int: [Hexagon.Index]] {
        var result = [Int: [Hexagon.Index]]()
        for index in indexes {
            var array = result[index.row] ?? []
            array.append(index)
            result[index.row] = array
        }
        
        return result.mapValues { $0.sorted(by: { $0.column < $1.column })}
    }
}
