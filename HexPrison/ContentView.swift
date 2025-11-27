//
//  ContentView.swift
//  HexPrison
//
//  Created by Alexander Skorulis on 28/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var scrollOffset: CGPoint = .zero
    
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
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray5))
            
            // ScrollView wrapper
            ScrollViewWrapper(scrollOffset: $scrollOffset)
        }
    }
}

#Preview {
    ContentView()
}
