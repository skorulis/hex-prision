//Created by Alexander Skorulis on 18/1/2026.

import ASKCoordinator
import Knit
import SwiftUI

enum ToastPath: CoordinatorPath {
 
    case unlockAchievement(Achievement)
    
    public var id: String {
        String(describing: self)
    }
}

extension CustomOverlay.Name {
    static let toast = CustomOverlay.Name("toast")
}

struct ToastPathRenderer: CoordinatorPathRenderer {
    
    let resolver: BaseResolver
    
    @ViewBuilder
    func render(path: ToastPath, in coordinator: Coordinator) -> some View {
        switch path {
        case let .unlockAchievement(achievement):
            DefaultToastContent(text: "Achievement Unlocked: \(achievement.description)")
        }
    }
}

struct ToastPathWrapper<Content: View>: View {
    @State var isVisible: Bool = false
    let content: () -> Content
    
    @Environment(\.dismissCustomOverlay) private var onDismiss
    
    var body: some View {
        ZStack {
            if isVisible {
                VStack {
                    Spacer()
                    Toast(content: content)
                }
                .transition(.opacity)
                .task {
                    do {
                        try await Task.sleep(nanoseconds: 3_000_000_000)
                    } catch {
                        print("Task cancelled")
                    }
                    onDismiss()
                }
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isVisible)
        .onAppear {
            isVisible = true
        }
    }
    
    private func maybeDismiss() {
        onDismiss()
    }
    
}
