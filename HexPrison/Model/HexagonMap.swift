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
    
    mutating func set(shape: BlobShape, index: Hexagon.Index) {
        var status = statuses[index] ?? .normal
        status.shape = shape
        statuses[index] = status
    }
    
    mutating func set(flipped: Bool, index: Hexagon.Index) {
        statuses[index] = flipped ? .flipped : .normal
        updateShapes(index: index)
    }
    
    mutating func setLost(index: Hexagon.Index) {
        statuses[index] = .init(flipped: true, lost: true)
        updateShapes(index: index)
    }
    
    mutating func reset(index: Hexagon.Index) {
        statuses.removeValue(forKey: index)
        updateShapes(index: index)
    }
    
    mutating func toggleFlipped(index: Hexagon.Index) {
        var status = statuses[index] ?? .normal
        status.flipped.toggle()
        statuses[index] = status
        updateShapes(index: index)
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
    
    func getActive() -> [Hexagon.Index] {
        statuses.filter { $0.value.isActive }.map(\.key)
    }
    
    func isActive(index: Hexagon.Index) -> Bool {
        statuses[index]?.isActive == true
    }
    
    private mutating func updateShapes(index: Hexagon.Index) {
        if isActive(index: index) {
            let blob = getBlob(index: index)
            let shape = BlobShape.getShape(blob: blob)
            for idx in blob {
                set(shape: shape, index: idx)
            }
        } else {
            for idx in HexGridMath.adjacentIndices(index: index) {
                if isActive(index: idx) {
                    updateShapes(index: idx)
                }
            }
        }
    }
    
    /// Return all connected hexagons for the conn
    func getBlob(index: Hexagon.Index) -> Set<Hexagon.Index> {
        guard isActive(index: index) else {
            return []
        }
        var result = Set<Hexagon.Index>()
        result.insert(index)
        var toCheck = result
        while let next = toCheck.popFirst() {
            for adj in HexGridMath.adjacentIndices(index: next) {
                if isActive(index: adj) && !result.contains(adj) {
                    result.insert(adj)
                    toCheck.insert(adj)
                }
            }
        }
        
        return result
    }
}

struct RandomNumberGeneratorWithSeed: RandomNumberGenerator {
    init(seed: Int) { srand48(seed) }
    func next() -> UInt64 { return UInt64(drand48() * Double(UInt64.max)) }
}
