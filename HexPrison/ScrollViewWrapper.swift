//
//  ScrollViewWrapper.swift
//  HexPrison
//
//  Created by Alexander Skorulis on 28/11/2025.
//

import SwiftUI
import UIKit

struct ScrollViewWrapper<Content: View>: UIViewRepresentable {
    @Binding var scrollOffset: CGPoint
    let content: (CGPoint) -> Content
    
    init(scrollOffset: Binding<CGPoint>, @ViewBuilder content: @escaping (CGPoint) -> Content) {
        self._scrollOffset = scrollOffset
        self.content = content
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.contentSize = CGSize(width: 10000, height: 10000)
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        // Create hosting controller for SwiftUI content
        let hostingController = UIHostingController(rootView: content(.zero))
        hostingController.view.backgroundColor = .clear
        
        // Store hosting controller in coordinator
        context.coordinator.hostingController = hostingController
        
        // Add hosting controller's view to scroll view
        let hostingView = hostingController.view!
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        hostingView.frame = CGRect(origin: .zero, size: .init(width: 1000, height: 1000))
        scrollView.addSubview(hostingView)
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // Update the hosting controller's root view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollViewWrapper
        var hostingController: UIHostingController<Content>?
        
        init(_ parent: ScrollViewWrapper) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.scrollOffset = scrollView.contentOffset
            hostingController?.rootView = parent.content(scrollView.contentOffset)
        }
    }
}

