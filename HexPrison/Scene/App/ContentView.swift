//
//  ContentView.swift
//  HexPrison
//
//  Created by Alexander Skorulis on 28/11/2025.
//

import ASKCoordinator
import Knit
import SwiftUI

struct ContentView: View {
    @Environment(\.resolver) private var resolver
    @State var coordinator = Coordinator(root: MainPath.game)
    @State var viewModel: ContentViewModel
    
    var body: some View {
        CoordinatorView(coordinator: coordinator)
            .with(renderer: resolver!.mainPathRenderer())
    }
}

#Preview {
    let assembler = HexPrisonAssembly.testing()
    ContentView(viewModel: assembler.resolver.contentViewModel())
        .environment(\.resolver, assembler.resolver)
}
