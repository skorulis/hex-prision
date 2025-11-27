//
//  HexagonGridView.swift
//  HexPrison
//
//  Created by Alexander Skorulis on 28/11/2025.
//

import SwiftUI

struct HexagonGridView: View {
    let hexRadius: CGFloat = 20 // Radius of each hexagon (center to vertex)
    let spacing: CGFloat = 5 // Space between hexagons
    let onHexagonTapped: ((Int, Int) -> Void)? // Optional callback for hexagon taps
    
    init(onHexagonTapped: ((Int, Int) -> Void)? = nil) {
        self.onHexagonTapped = onHexagonTapped
    }
    
    var body: some View {
        GeometryReader { geometry in
            let columns = calculateColumns(in: geometry.size.width)
            let rows = calculateRows(in: geometry.size.height)
            
            ZStack {
                ForEach(0..<rows, id: \.self) { row in
                    ForEach(0..<columns, id: \.self) { column in
                        HexagonButton(
                            radius: hexRadius,
                            action: {
                                onHexagonTapped?(row, column)
                            }
                        )
                        .position(hexPosition(row: row, column: column, in: geometry.size))
                    }
                }
            }
        }
    }
    
    // Calculate number of columns that fit in the width
    private func calculateColumns(in width: CGFloat) -> Int {
        // Horizontal center-to-center distance: flat-to-flat width + spacing
        // Flat-to-flat width = sqrt(3) * radius
        let horizontalSpacing = hexRadius * sqrt(3) + spacing
        return max(1, Int((width + spacing) / horizontalSpacing))
    }
    
    // Calculate number of rows that fit in the height
    private func calculateRows(in height: CGFloat) -> Int {
        // Vertical center-to-center distance: point-to-point height / 2 + spacing
        // Point-to-point height = 2 * radius, so vertical spacing = radius + spacing
        // Actually for flat-top hexagons: vertical spacing = 1.5 * radius + spacing
        let verticalSpacing = hexRadius * 1.5 + spacing
        return max(1, Int((height + spacing) / verticalSpacing))
    }
    
    // Calculate position for a hexagon at given row and column
    private func hexPosition(row: Int, column: Int, in size: CGSize) -> CGPoint {
        // Flat-to-flat width of a hexagon
        let hexWidth = hexRadius * sqrt(3)
        // Center-to-center horizontal spacing
        let horizontalSpacing = hexWidth + spacing
        // Center-to-center vertical spacing
        let verticalSpacing = hexRadius * 1.5 + spacing
        
        // Start position: account for hexagon radius so first hex doesn't get clipped
        let startX = hexWidth / 2 + spacing / 2
        let startY = hexRadius + spacing / 2
        
        // Offset every other row by half the horizontal spacing for proper hex grid
        let xOffset: CGFloat = row % 2 == 0 ? 0 : horizontalSpacing / 2
        
        let x = startX + CGFloat(column) * horizontalSpacing + xOffset
        let y = startY + CGFloat(row) * verticalSpacing
        
        return CGPoint(x: x, y: y)
    }
}

// Hexagon button view
struct HexagonButton: View {
    let radius: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HexagonShape(radius: radius)
                .fill(Color.gray)
                .frame(width: radius * 2, height: radius * 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Hexagon shape
struct HexagonShape: Shape {
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // Create a flat-top hexagon
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3 - .pi / 6 // Start at -30 degrees for flat-top
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Previews

#Preview {
    HexagonGridView { row, column in
        print("Tapped hexagon at row: \(row), column: \(column)")
    }
    .background(Color.black)
}
