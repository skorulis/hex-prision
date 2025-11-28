//  Created by Alexander Skorulis on 28/11/2025.

import Knit
import SwiftUI

@main
struct HexPrisonApp: App {
    
    private let assembler: ScopedModuleAssembler<BaseResolver> = {
        let assembler = ScopedModuleAssembler<BaseResolver>(
            [
                HexPrisonAssembly(),
            ]
        )
        return assembler
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: assembler.resolver.contentViewModel())
        }
        .environment(\.resolver, assembler.resolver)
    }
}

public extension EnvironmentValues {
    @Entry var resolver: BaseResolver?
}
