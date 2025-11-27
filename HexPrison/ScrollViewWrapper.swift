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
    let content: (ScrollViewport) -> Content
    let config: ScrollViewWrapperConfig
    
    init(
        config: ScrollViewWrapperConfig,
        scrollOffset: Binding<CGPoint>,
        @ViewBuilder content: @escaping (ScrollViewport) -> Content
    ) {
        self._scrollOffset = scrollOffset
        self.content = content
        self.config = config
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.contentSize = config.contentSize
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .black
        scrollView.contentOffset = config.initialOffset

        // Create hosting controller for SwiftUI content
        let hostingController = UIHostingController(rootView: content(.zero(config)))
        hostingController.view.backgroundColor = .clear
        
        // Store hosting controller in coordinator
        context.coordinator.hostingController = hostingController
        
        // Add hosting controller's view to scroll view
        let hostingView = hostingController.view!
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        hostingView.frame = CGRect(origin: .zero, size: .init(width: 1000, height: 1000))
        hostingView.backgroundColor = .black
        scrollView.addSubview(hostingView)
        
        DispatchQueue.main.async {
            // Render the first pass after the frame is set
            context.coordinator.updateViewport(scrollView: scrollView)
        }
        
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
        
        fileprivate func updateViewport(scrollView: UIScrollView) {
            hostingController?.view.frame = .init(
                x: scrollView.contentOffset.x,
                y: scrollView.contentOffset.y,
                width: scrollView.bounds.width,
                height: scrollView.bounds.height
            )
            
            let viewPort = ScrollViewport(
                offset: scrollView.contentOffset,
                size: scrollView.frame.size,
            )
            
            hostingController?.rootView = parent.content(viewPort)
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.scrollOffset = scrollView.contentOffset
            updateViewport(scrollView: scrollView)
        }
    }
}

struct ScrollViewWrapperConfig {
    // Padding applied to the size of the content viewPort
    let padding: CGFloat
    
    // Total size of the viewPort (not yet implemented)
    let contentSize: CGSize
    
    // Offset position to start at
    let initialOffset: CGPoint
    
    static var `default`: Self {
        .init(
            padding: 0,
            contentSize: .init(width: 10000, height: 10000),
            initialOffset: .zero,
            
        )
    }
}

struct ScrollViewport {
    // Absolute UIScrollView offset
    let offset: CGPoint
    
    // Size of the viewport window
    let size: CGSize
    
    // Centre location
    var center: CGPoint {
        .init(x: offset.x + size.width / 2, y: offset.y + size.height / 2)
    }
    
    static func zero(_ config: ScrollViewWrapperConfig) -> Self {
        .init(offset: .zero, size: .zero)
    }
    
}
