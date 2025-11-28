//  Created by Alexander Skorulis on 28/11/2025.

import Foundation
import SwiftUI

enum HexagonType {
    
    // Basic hexagon making up most of the world
    case basic
    
    // Permanent hexagon that stays flipped
    case permanent
    
}

extension HexagonType {
    var color: Color {
        switch self {
        case .basic:
            return .gray
        case .permanent:
            return .cyan
        }
    }
}
