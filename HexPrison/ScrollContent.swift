//
//  ScrollContent.swift
//  HexPrison
//
//  Created by Alexander Skorulis on 28/11/2025.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

@MainActor struct ScrollContent {
    let viewPort: ScrollViewport
}

// MARK: - Rendering

extension ScrollContent: View {
    
    var body: some View {
        if viewPort.size != .zero {
            realContent
        } else {
            EmptyView()
        }
    }
    
    private var realContent: some View {
        HexagonGridView { row, column in
            print("Tapped hexagon at row: \(row), column: \(column)")
        }
        .frame(width: viewPort.size.width, height: viewPort.size.height)
        .border(Color.red)
    }
    
    private var title: String {
        "Tap: \(Int(viewPort.center.x)), \(Int(viewPort.center.y))"
    }
}

// MARK: - Previews

#Preview {
    ScrollContent(
        viewPort: .init(
            offset: .zero,
            size: .init(width: 400, height: 400),
        )
    )
}

