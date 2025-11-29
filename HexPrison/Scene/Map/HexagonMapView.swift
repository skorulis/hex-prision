//  Created by Alexander Skorulis on 28/11/2025.

import Foundation
import Knit
import SwiftUI

// MARK: - Memory footprint

@MainActor struct HexagonMapView {
    @State var viewModel: HexagonMapViewModel
    let viewPort: ScrollViewport
}

// MARK: - Rendering

extension HexagonMapView: View {
    
    var body: some View {
        if viewPort.size != .zero {
            realContent
        } else {
            EmptyView()
        }
    }
    
    private var realContent: some View {
        HexagonGridView(
            map: viewModel.map,
            offset: .init(
                x: viewPort.offset.x - Constants.baseOffset,
                y: viewPort.offset.y - Constants.baseOffset
            )
        ) { index in
            viewModel.toggle(index: index)
            print("Tapped hexagon at row: \(index.row), column: \(index.column)")
        }
        .frame(width: viewPort.size.width, height: viewPort.size.height)
    }
    
    private var title: String {
        "Tap: \(Int(viewPort.center.x)), \(Int(viewPort.center.y))"
    }
}

// MARK: - Previews

#Preview {
    let assembler = HexPrisonAssembly.testing()
    HexagonMapView(
        viewModel: assembler.resolver.hexagonMapViewModel(),
        viewPort: .init(
            offset: .zero,
            size: .init(width: 400, height: 400),
        ),
    )
}

