//Created by Alexander Skorulis on 29/1/2026.

import Foundation
import SwiftUI

// MARK: - Memory footprint

@MainActor struct WalletButton {
    let wallet: Wallet
    @State private var isOpen: Bool = false
}

// MARK: - Rendering

extension WalletButton: View {
    
    var body: some View {
        Button(action: toggleOpen) {
            content
                .contentShape(RoundedRectangle(cornerRadius: isOpen ? 24 : .infinity))
        }
        .buttonStyle(.plain)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24).fill(.white)
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isOpen)
    }
    
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 4) {
            HStack {
                if isOpen {
                    Text("Wallet")
                        .font(.headline)
                    Spacer()
                }
                mainValue
            }
            if isOpen {
                expandedContent
            }
        }
        .frame(maxWidth: isOpen ? 120 : nil)
    }
    
    private var mainValue: some View {
        Text(format(wallet.total))
            .font(.headline)
            .foregroundStyle(.black)
    }
    
    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Currency.allCases) { entry in
                HStack {
                    entry.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                    Spacer()
                    Text(format(wallet.amount(entry)))
                }
            }
        }
        .foregroundStyle(.black)
    }
    
    private func format(_ double: Double) -> String {
        CompactNumberFormatter().string(double)
    }
    
    private func toggleOpen() {
        isOpen.toggle()
    }
}

// MARK: - Previews

#Preview {
    ZStack(alignment: .topTrailing) {
        Color.black
        WalletButton(
            wallet: Wallet(balance: [.dot: 100, .hexagon: 200])
        )
        .padding(8)
    }
}

