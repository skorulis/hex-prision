//Created by Alexander Skorulis on 1/12/2025.

import ASKCoordinator
import Foundation
import Knit
import SwiftUI

public enum MainPath: CoordinatorPath {
    
    case game
    case upgrades
    
    public var id: String {
        String(describing: self)
    }
}


public struct MainPathRenderer: CoordinatorPathRenderer {
    
    let resolver: BaseResolver
    
    @ViewBuilder
    public func render(path: MainPath, in coordinator: Coordinator) -> some View {
        switch path {
        case .game:
            GameView(viewModel: coordinator.apply(resolver.gameViewModel()))
        case .upgrades:
            UpgradeGridView(viewModel: coordinator.apply(resolver.upgradeGridViewModel()))
        }
    }
}
