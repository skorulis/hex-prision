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
            let visibleRange = calculateVisibleRange(viewportSize: geometry.size, offset: offset)
            let viewportCenter = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            ZStack {
                ForEach(visibleRange.rows, id: \.self) { row in
                    ForEach(visibleRange.columns, id: \.self) { column in
                        let position = hexPosition(row: row, column: column, offset: offset, in: geometry.size)
                        let sphereEffect = calculateSphereEffect(
                            position: position,
                            viewportCenter: viewportCenter,
                            frameSize: geometry.size,
                        )
                        
                        HexagonButton(
                            index: .init(row: row, column: column),
                            action: onHexagonTapped,
                        )
                        .scaleEffect(sphereEffect.scale)
                        .rotation3DEffect(
                            .degrees(sphereEffect.rotationX),
                            axis: (x: 1, y: 0, z: 0),
                            perspective: 0.5
                        )
                        .rotation3DEffect(
                            .degrees(sphereEffect.rotationY),
                            axis: (x: 0, y: 1, z: 0),
                            perspective: 0.5
                        )
                        .opacity(sphereEffect.opacity)
                        .brightness(sphereEffect.brightness)
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
    private func calculateVisibleRange(viewportSize: CGSize, offset: CGPoint) -> VisibleRange {
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
    private func hexPosition(row: Int, column: Int, offset: CGPoint, in size: CGSize) -> CGPoint {
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
        let rotationX: CGFloat
        let rotationY: CGFloat
        let opacity: CGFloat
        let brightness: CGFloat
    }
    
    private func calculateSphereEffect(
        position: CGPoint,
        viewportCenter: CGPoint,
        frameSize: CGSize,
    ) -> SphereEffect {
        let maxDistance = sqrt(pow(frameSize.width / 2, 2) + pow(frameSize.height / 2, 2))
        
        // Calculate distance from center
        let dx = position.x - viewportCenter.x
        let dy = position.y - viewportCenter.y
        let distance = sqrt(dx * dx + dy * dy)
        
        // Normalize distance (0 = center, 1 = edge)
        let normalizedDistance = min(distance / maxDistance, 1.0)
        
        // Sphere curvature effect: stronger near edges
        // Use a smooth curve (ease-in-out) for more natural look
        let curvature = normalizedDistance * normalizedDistance
        
        // Scale: hexagons get smaller as they approach edges
        // Range from 1.0 (center) to 0.6 (edge)
        let scale = 1.0 - (curvature * 0.4)
        
        // Rotation: tilt hexagons based on their position relative to center
        // Maximum rotation of 45 degrees at edges
        let maxRotation: CGFloat = 45
        let rotationX = -dy / maxDistance * maxRotation * curvature
        let rotationY = dx / maxDistance * maxRotation * curvature
        
        // Opacity: slightly fade hexagons near edges for depth
        // Range from 1.0 (center) to 0.7 (edge)
        let opacity = 1.0 - (curvature * 0.3)
        
        // Brightness: darken hexagons near edges to simulate shadow
        // Range from 0.0 (center) to -0.2 (edge)
        let brightness = -curvature * 0.2
        
        return SphereEffect(
            scale: scale,
            rotationX: rotationX,
            rotationY: rotationY,
            opacity: opacity,
            brightness: brightness
        )
    }
}

// MARK: - Previews

#Preview {
    HexagonGridView(offset: .zero) { index in
        print("Tapped hexagon at row: \(index.row), column: \(index.column)")
    }
    .background(Color.black)
}
