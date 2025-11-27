//
//  ScrollViewWrapper.swift
//  HexPrison
//
//  Created by Alexander Skorulis on 28/11/2025.
//

import SwiftUI
import UIKit

struct ScrollViewWrapper: UIViewRepresentable {
    @Binding var scrollOffset: CGPoint
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        // Add a simple view to visualize the scrollable content
        let contentView = UIView()
        contentView.backgroundColor = .systemGray6
        contentView.frame = CGRect(origin: .zero, size: scrollView.contentSize)
        scrollView.addSubview(contentView)
        
        // Add some visual markers to see scrolling
        for i in 0..<10 {
            let marker = UIView(frame: CGRect(x: CGFloat(i * 100), y: 0, width: 2, height: 1000))
            marker.backgroundColor = .systemBlue
            contentView.addSubview(marker)
            
            let marker2 = UIView(frame: CGRect(x: 0, y: CGFloat(i * 100), width: 1000, height: 2))
            marker2.backgroundColor = .systemBlue
            contentView.addSubview(marker2)
        }
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // Update if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollViewWrapper
        
        init(_ parent: ScrollViewWrapper) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.scrollOffset = scrollView.contentOffset
        }
    }
}

