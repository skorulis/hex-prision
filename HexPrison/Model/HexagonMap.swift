//Created by Alexander Skorulis on 28/11/2025.

import Foundation

/// Container for the entire game map
struct HexagonMap {
    
    private var statuses: [Hexagon.Index: Hexagon.Status] = [:]
    
    mutating func set(pulse: Bool, index: Hexagon.Index) {
        var status = statuses[index] ?? .normal
        status.pulse = pulse
        statuses[index] = status
    }
    
    mutating func set(flipped: Bool, index: Hexagon.Index) {
        statuses[index] = flipped ? .flipped : .normal
    }
    
    mutating func setLost(index: Hexagon.Index) {
        statuses[index] = .init(flipped: true, lost: true)
    }
    
    mutating func reset(index: Hexagon.Index) {
        statuses.removeValue(forKey: index)
    }
    
    mutating func toggleFlipped(index: Hexagon.Index) {
        var status = statuses[index] ?? .normal
        status.flipped.toggle()
        statuses[index] = status
    }
    
    func get(index: Hexagon.Index) -> Hexagon {
        let status = statuses[index] ?? .normal
        let type = getType(index: index)
        return .init(
            type: type,
            index: index,
            status: status,
        )
    }
    
    private func getType(index: Hexagon.Index) -> HexagonType {
        let hashRand = RandomNumberGeneratorWithSeed(seed: index.stableHashValue).next()
        let hashMod = hashRand % 100
        if hashMod == 44 {
            return .permanent
        } else if hashMod == 43 {
            return .clue
        } else {
            return .basic
        }
    }
}

struct RandomNumberGeneratorWithSeed: RandomNumberGenerator {
    init(seed: Int) { srand48(seed) }
    func next() -> UInt64 { return UInt64(drand48() * Double(UInt64.max)) }
}
