//Created by Alexander Skorulis on 28/11/2025.

import Combine
import Foundation

final class MapStore: ObservableObject {
    
    @Published var map = HexagonMap()
}
