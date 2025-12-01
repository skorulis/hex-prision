//  Created by Alexander Skorulis on 28/11/2025.

import SwiftUI

struct HexagonGridView: View {
    let offset: CGPoint
    let map: HexagonMap
    let onHexagonTapped: (Hexagon.Index) -> Void
    
    init(
        map: HexagonMap,
        offset: CGPoint,
        onHexagonTapped: @escaping (Hexagon.Index) -> Void
    ) {
        self.map = map
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
                        let position = HexGridMath.position(
                            row: row,
                            column: column,
                            offset: offset
                        )
                        let dimming = calculateDimming(
                            position: position,
                            viewportCenter: viewportCenter,
                            frameSize: geometry.size,
                        )
                        
                        HexagonButton(
                            hexagon: map.get(index: .init(row: row, column: column)),
                            dimming: dimming,
                            action: onHexagonTapped,
                        )
                        .position(position)
                    }
                }
            }
        }
    }
    
    // Calculate which hexagons are visible in the viewport
    private func calculateVisibleRange(viewportSize: CGSize) -> Hexagon.VisibleRange {
        // Convert viewport bounds to world coordinates
        let worldFrame = CGRect(
            origin: .init(x: offset.x, y: offset.y),
            size: .init(width: viewportSize.width, height: viewportSize.height),
        )
        // Add extra padding so the edge isn't visible
        .insetBy(dx: -Hexagon.radius, dy: -Hexagon.radius)
        
        // Find the hexagon indices that cover this world coordinate range
        
        let startColumn = HexGridMath.pixelToColumn(x: worldFrame.minX)
        let startRow = HexGridMath.pixelToRow(y: worldFrame.minY)
        let endColumn = HexGridMath.pixelToColumn(x: worldFrame.maxX) + 1
        let endRow = HexGridMath.pixelToRow(y: worldFrame.maxY) + 1
        
        // Ensure ranges are valid (start <= end)
        let clampedStartColumn = min(startColumn, endColumn)
        let clampedEndColumn = max(startColumn, endColumn)
        let clampedStartRow = min(startRow, endRow)
        let clampedEndRow = max(startRow, endRow)
        
        return .init(
            rows: clampedStartRow..<clampedEndRow,
            columns: clampedStartColumn..<clampedEndColumn
        )
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
    HexagonGridView(map: .init(), offset: .zero) { index in
        print("Tapped hexagon at row: \(index.row), column: \(index.column)")
    }
    .background(Color.black)
}
