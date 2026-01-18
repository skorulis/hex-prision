//Created by Alexander Skorulis on 18/1/2026.

import ASKCoordinator
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

struct ToastPathWrapper<Content: View>: View {
    @State var isVisible: Bool = false
    let content: () -> Content
    
    @Environment(\.dismissCustomOverlay) private var onDismiss
    
    var body: some View {
        EmptyView()
//        ZStack {
//            if isVisible {
//                Toast(
//                    onDismiss: maybeDismiss,
//                    content: content
//                )
//                .transition(.opacity)
//            }
//        }
//        .animation(.easeInOut(duration: 0.15), value: isVisible)
//        .onAppear {
//            isVisible = true
//        }
    }
    
    private func maybeDismiss() {
        onDismiss()
    }
    
}
