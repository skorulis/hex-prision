//Created by Alexander Skorulis on 1/12/2025.

import Foundation
import SwiftUI

enum Upgrade: CaseIterable, Identifiable {
    
    case memory
    case knowledge
    case notes
    
    static let byIndex: [Hexagon.Index: Upgrade] = {
        return Dictionary(grouping: Upgrade.allCases) { $0.index }
            .mapValues { $0[0] }
    }()
    
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
    
    var cost: Int {
        switch self {
        case .memory:
            return 0
        case .knowledge:
            return 10
        case .notes:
            return 100
        }
    }
    
    var name: String {
        String(describing: self).capitalized
    }
    
    var longDescription: String {
        switch self {
        case .memory:
            return "How did I get here"
        case .knowledge:
            return "Someone must know something"
        case .notes:
            return "Where have I been"
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
