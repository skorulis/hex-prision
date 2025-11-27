//
//  ContentView.swift
//  HexPrison
//
//  Created by Alexander Skorulis on 28/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var scrollOffset: CGPoint = .zero
    @State private var buttonTapCount: Int = 0
    
    var body: some View {
        VStack {
            // Label showing current scroll offset
            VStack(alignment: .leading, spacing: 8) {
                Text("Scroll Position")
                    .font(.headline)
                Text("X: \(Int(scrollOffset.x))")
                    .font(.body)
                    .foregroundColor(.secondary)
                Text("Y: \(Int(scrollOffset.y))")
                    .font(.body)
                    .foregroundColor(.secondary)
                Text("Button Taps: \(buttonTapCount)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray5))
            
            // ScrollView wrapper with SwiftUI content
            ScrollViewWrapper(scrollOffset: $scrollOffset) { offset in
                ScrollContent(scrollOffset: offset)
            }
        }
    }
}

#Preview {
    ContentView()
}
