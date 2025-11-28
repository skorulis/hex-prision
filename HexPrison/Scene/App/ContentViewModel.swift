//Created by Alexander Skorulis on 28/11/2025.

import Foundation
import Knit
import KnitMacros
import SwiftUI

@Observable final class ContentViewModel {
    
    let mapViewModel: HexagonMapViewModel
    
    @Resolvable<BaseResolver>
    init(mapViewModel: HexagonMapViewModel) {
        self.mapViewModel = mapViewModel
    }
}

// MARK: - Logic

extension ContentViewModel {}
