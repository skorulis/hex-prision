//Created by Alexander Skorulis on 28/11/2025.

import Foundation
import Knit

final class HexPrisonAssembly: AutoInitModuleAssembly {
    static var dependencies: [any Knit.ModuleAssembly.Type] = []
    
    typealias TargetResolver = BaseResolver
    
    init() {}
    
    @MainActor func assemble(container: Container<TargetResolver>) {
        registerServices(container: container)
        registerStores(container: container)
        registerViewModels(container: container)
    }
    
    @MainActor
    private func registerServices(container: Container<TargetResolver>) {
        container.register(HexagonEventService.self) { HexagonEventService.make(resolver: $0) }
            .inObjectScope(.container)
    }
    
    @MainActor
    private func registerStores(container: Container<TargetResolver>) {
        container.register(MapStore.self) { _ in
            MapStore()
        }
        .inObjectScope(.container)
    }
    
    @MainActor
    private func registerViewModels(container: Container<TargetResolver>) {
        container.register(ContentViewModel.self) { ContentViewModel.make(resolver: $0) }
        container.register(HexagonMapViewModel.self) { HexagonMapViewModel.make(resolver: $0) }
        container.register(UpgradeGridViewModel.self) { UpgradeGridViewModel.make(resolver: $0) }
    }
}

extension HexPrisonAssembly {
    @MainActor static func testing() -> ScopedModuleAssembler<BaseResolver> {
        ScopedModuleAssembler<BaseResolver>([HexPrisonAssembly()])
    }
}
