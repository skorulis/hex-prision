//
//  HexagonGridView.swift
//  HexPrison
//
//  Created by Alexander Skorulis on 28/11/2025.
//

import SwiftUI

struct HexagonGridView: View {
    let offset: CGPoint
    let onHexagonTapped: (Hexagon.Index) -> Void
    
    init(offset: CGPoint, onHexagonTapped: @escaping (Hexagon.Index) -> Void) {
        self.offset = offset
        self.onHexagonTapped = onHexagonTapped
    }
    
    var body: some View {
        GeometryReader { geometry in
            let visibleRange = calculateVisibleRange(viewportSize: geometry.size)
            let viewportCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            ZStack {
                ForEach(visibleRange.rows, id: \.self) { row in
                    ForEach(visibleRange.columns, id: \.self) { column in
                        let position = hexPosition(row: row, column: column, in: geometry.size)
                        let dimming = calculateDimming(
                            position: position,
                            viewportCenter: viewportCenter,
                            frameSize: geometry.size,
                        )
                        
                        HexagonButton(
                            index: .init(row: row, column: column),
                            dimming: dimming,
                            action: onHexagonTapped,
                        )
                        .position(position)
                    }
                }
            }
        }
    }
    
    // Visible range of hexagons
    private struct VisibleRange {
        let rows: Range<Int>
        let columns: Range<Int>
    }
    
    // Calculate which hexagons are visible in the viewport
    private func calculateVisibleRange(viewportSize: CGSize) -> VisibleRange {
        let hexWidth = Hexagon.radius * sqrt(3)
        let horizontalSpacing = hexWidth + Hexagon.spacing
        let verticalSpacing = Hexagon.radius * 1.5 + Hexagon.spacing
        
        // Convert viewport bounds to world coordinates
        // Viewport is at screen position (0, 0) with size viewportSize
        // World coordinates = screen coordinates - offset
        let worldMinX = -offset.x
        let worldMinY = -offset.y
        let worldMaxX = worldMinX + viewportSize.width
        let worldMaxY = worldMinY + viewportSize.height
        
        // Find the hexagon indices that cover this world coordinate range
        // Account for hexagon size by expanding the range
        let hexRadius = Hexagon.radius
        let expandedMinX = worldMinX - hexRadius
        let expandedMinY = worldMinY - hexRadius
        let expandedMaxX = worldMaxX + hexRadius
        let expandedMaxY = worldMaxY + hexRadius
        
        let startColumn = pixelToColumn(x: expandedMinX, horizontalSpacing: horizontalSpacing)
        let startRow = pixelToRow(y: expandedMinY, verticalSpacing: verticalSpacing)
        let endColumn = pixelToColumn(x: expandedMaxX, horizontalSpacing: horizontalSpacing) + 1
        let endRow = pixelToRow(y: expandedMaxY, verticalSpacing: verticalSpacing) + 1
        
        // Ensure ranges are valid (start <= end)
        let clampedStartColumn = min(startColumn, endColumn)
        let clampedEndColumn = max(startColumn, endColumn)
        let clampedStartRow = min(startRow, endRow)
        let clampedEndRow = max(startRow, endRow)
        
        return VisibleRange(
            rows: clampedStartRow..<clampedEndRow,
            columns: clampedStartColumn..<clampedEndColumn
        )
    }
    
    // Convert pixel X position (in world coordinates) to hexagon column index
    private func pixelToColumn(x: CGFloat, horizontalSpacing: CGFloat) -> Int {
        let hexWidth = Hexagon.radius * sqrt(3)
        // Account for the initial grid offset
        let adjustedX = x - (hexWidth / 2 + Hexagon.spacing / 2)
        return Int(floor(adjustedX / horizontalSpacing))
    }
    
    // Convert pixel Y position (in world coordinates) to hexagon row index
    private func pixelToRow(y: CGFloat, verticalSpacing: CGFloat) -> Int {
        // Account for the initial grid offset
        let adjustedY = y - (Hexagon.radius + Hexagon.spacing / 2)
        return Int(floor(adjustedY / verticalSpacing))
    }
    
    // Calculate position for a hexagon at given row and column, accounting for offset
    private func hexPosition(row: Int, column: Int, in size: CGSize) -> CGPoint {
        // Flat-to-flat width of a hexagon
        let hexWidth = Hexagon.radius * sqrt(3)
        // Center-to-center horizontal spacing
        let horizontalSpacing = hexWidth + Hexagon.spacing
        // Center-to-center vertical spacing
        let verticalSpacing = Hexagon.radius * 1.5 + Hexagon.spacing
        
        // Start position: account for hexagon radius so first hex doesn't get clipped
        let startX = hexWidth / 2 + Hexagon.spacing / 2
        let startY = Hexagon.radius + Hexagon.spacing / 2
        
        // Offset every other row by half the horizontal spacing for proper hex grid
        let xOffset: CGFloat = row % 2 == 0 ? 0 : horizontalSpacing / 2
        
        // Calculate base position
        let baseX = startX + CGFloat(column) * horizontalSpacing + xOffset
        let baseY = startY + CGFloat(row) * verticalSpacing
        
        // Apply the offset to move the grid
        return CGPoint(x: baseX + offset.x, y: baseY + offset.y)
    }
    
    // Calculate sphere effect parameters based on distance from viewport center
    private struct SphereEffect {
        let scale: CGFloat
        let brightness: CGFloat
    }
    
    private func calculateDimming(
        position: CGPoint,
        viewportCenter: CGPoint,
        frameSize: CGSize,
    ) -> CGFloat {
        // Calculate distance from center
        let dx = abs(position.x - viewportCenter.x) / frameSize.width
        let dy = abs(position.y - viewportCenter.y) / frameSize.height
        let maxDistance = max(dx, dy)
        
        // Use a smooth curve (ease-in-out) for more natural look
        return maxDistance * maxDistance
    }
}

// MARK: - Previews

#Preview {
    HexagonGridView(offset: .zero) { index in
        print("Tapped hexagon at row: \(index.row), column: \(index.column)")
    }
    .background(Color.black)
}
