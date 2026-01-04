//Created by Alexander Skorulis on 4/1/2026.

import Foundation

enum BlobShape {
    // No specified shape
    case none
    
    // Any triangle shape
    case triangle
    
    // Any hexagon shape
    case hexagon
}

extension BlobShape {
    
    static func getShape(blob: Set<Hexagon.Index>) -> BlobShape {
        if blob.count == 3 {
            if checkTriangle(blob: blob) {
                return .triangle
            }
        }
        return .none
    }
    
    private static func checkTriangle(blob: Set<Hexagon.Index>) -> Bool {
        let rows = HexGridMath.rows(indexes: Array(blob))
        let keys = Array(rows.keys).sorted()
        if keys.count != 2 {
            return false
        }
        guard keys[1] == keys[0] + 1 else {
            return false
        }
        let singleRowKey: Int
        let doubleRowKey: Int
        if (rows[keys[0]] ?? []).count == 1 {
            singleRowKey = keys[0]
            doubleRowKey = keys[1]
        } else {
            singleRowKey = keys[1]
            doubleRowKey = keys[0]
        }
        let singleIndex = rows[singleRowKey]![0]
        let others = rows[doubleRowKey]!
        let adjacent = HexGridMath.adjacentIndices(index: singleIndex)
        return others.allSatisfy { index in
            adjacent.contains(index)
        }
    }
}
