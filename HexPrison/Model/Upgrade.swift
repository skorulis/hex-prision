//Created by Alexander Skorulis on 1/12/2025.

import Foundation
import SwiftUI

enum Upgrade: CaseIterable, Identifiable {
    
    case memory
    case knowledge
    case notes
    
    var index: Hexagon.Index {
        switch self {
        case .memory:
            return .init(row: 0, column: 0)
        case .knowledge:
            return .init(row: 1, column: -1)
        case .notes:
            return .init(row: 2, column: -1)
        }
    }
    
    var color: Color {
        switch self {
        case .memory:
            return .yellow
        case .knowledge:
            return .red
        case .notes:
            return .red
        }
    }
    
    var icon: Image {
        switch self {
        case .memory:
            return Image(systemName: "memorychip.fill")
        case .knowledge:
            return Image(systemName: "brain.fill")
        case .notes:
            return Image(systemName: "list.clipboard.fill")
        }
    }
    
    var id: Hexagon.Index { index }
}
