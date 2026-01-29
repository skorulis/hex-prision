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
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isOpen)
    }
    
    @ViewBuilder
    private var content: some View {
        if isOpen {
            expandedContent
        } else {
            collapsedContent
        }
    }
    
    private var collapsedContent: some View {
        Text(mainText)
            .font(.headline)
            .foregroundStyle(.black)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule().fill(Color.white)
            )
            .shadow(radius: 2, y: 1)
    }
    
    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Wallet")
                    .font(.headline)
                Spacer()
                Text(mainText)
                    .font(.headline)
            }
            Divider()
            ForEach(walletEntries, id: \._key) { entry in
                HStack {
                    Text(entry._key)
                    Spacer()
                    Text(CompactNumberFormatter().string(entry._value))
                        .monospacedDigit()
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24).fill(.white)
        )
        .shadow(radius: 8, y: 4)
        .frame(maxWidth: 260, alignment: .leading)
        .foregroundStyle(.black)
    }
    
    private var mainText: String {
        CompactNumberFormatter().string(wallet.total)
    }
    
    // Helper to iterate entries in a stable way without knowing Wallet's exact types
    private var walletEntries: [(_key: String, _value: Double)] {
        // Attempt to expose entries from Wallet. This assumes Wallet has a `balance`-like dictionary.
        // Fallbacks are minimal; adjust mapping to your actual Wallet model.
        if let mirror = Mirror(reflecting: wallet).children.first(where: { $0.label == "balance" }),
           let dict = mirror.value as? [AnyHashable: Any] {
            // Map keys/values to strings and doubles if possible
            return dict.compactMap { kv in
                let keyString: String
                if let key = kv.key as? CustomStringConvertible {
                    keyString = key.description
                } else {
                    keyString = String(describing: kv.key)
                }
                let valueDouble: Double
                if let d = kv.value as? Double {
                    valueDouble = d
                } else if let i = kv.value as? Int { valueDouble = Double(i) }
                else if let f = kv.value as? Float { valueDouble = Double(f) }
                else { return nil }
                return (keyString, valueDouble)
            }
            .sorted { $0._key < $1._key }
        }
        return []
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

