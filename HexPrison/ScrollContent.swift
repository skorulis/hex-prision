//
//  ScrollContent.swift
//  HexPrison
//
//  Created by Alexander Skorulis on 28/11/2025.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

@MainActor struct ScrollContent {
    let scrollOffset: CGPoint
}

// MARK: - Rendering

extension ScrollContent: View {
    
    var body: some View {
        VStack(spacing: 20) {
            // Example SwiftUI button
            Button(action: { }) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 40)
        }
        .padding()
    }
    
    private var title: String {
        "Tap: \(Int(scrollOffset.x)), \(Int(scrollOffset.y))"
    }
}

// MARK: - Previews

#Preview {
    ScrollContent(scrollOffset: .zero)
}

