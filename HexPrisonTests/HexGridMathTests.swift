//Created by Alexander Skorulis on 30/11/2025.

@testable import HexPrison
import Testing

@MainActor struct HexGridMathTests {
    
    @Test func adjacentIndices_EvenRow() {
        // Test hexagon at even row (row 0, column 2)
        let center = Hexagon.Index(row: 0, column: 2)
        let neighbors = HexGridMath.adjacentIndices(index: center)
        
        #expect(neighbors.count == 6)
        
        let expectedNeighbors: [Hexagon.Index] = [
            .init(row: -1, column: 1),
            .init(row: -1, column: 2),
            .init(row: 0, column: 1),
            .init(row: 0, column: 3),
            .init(row: 1, column: 1),
            .init(row: 1, column: 2),
        ]
        
        let actualNeighbors = neighbors
        #expect(actualNeighbors == expectedNeighbors)
    }
    
    @Test func adjacentIndices_OddRow() {
        let center = Hexagon.Index(row: 1, column: 2)
        let neighbors = HexGridMath.adjacentIndices(index: center)
        
        #expect(neighbors.count == 6)
        
        let expectedNeighbors: Set<Hexagon.Index> = [
            .init(row: 0, column: 2),
            .init(row: 0, column: 3),
            .init(row: 1, column: 1),
            .init(row: 1, column: 3),
            .init(row: 2, column: 2),
            .init(row: 2, column: 3),
        ]
        
        let actualNeighbors = Set(neighbors)
        #expect(actualNeighbors == expectedNeighbors)
    }
    
    @Test func adjacentIndices_Origin() {
        let center = Hexagon.Index(row: 0, column: 0)
        let neighbors = HexGridMath.adjacentIndices(index: center)
        
        #expect(neighbors.count == 6)
        
        let expectedNeighbors: Set<Hexagon.Index> = [
            .init(row: -1, column: -1),
            .init(row: -1, column: 0),
            .init(row: 0, column: -1),
            .init(row: 0, column: 1),
            .init(row: 1, column: -1),
            .init(row: 1, column: 0),
        ]
        
        let actualNeighbors = Set(neighbors)
        #expect(actualNeighbors == expectedNeighbors)
    }
    
    @Test func adjacentIndices_NegativeCoordinates_ReturnsCorrectNeighbors() {
        let center = Hexagon.Index(row: -2, column: -3)
        let neighbors = HexGridMath.adjacentIndices(index: center)
        
        #expect(neighbors.count == 6)
        
        let expectedNeighbors: [Hexagon.Index] = [
            .init(row: -3, column: -4),
            .init(row: -3, column: -3),
            .init(row: -2, column: -4),
            .init(row: -2, column: -2),
            .init(row: -1, column: -4),
            .init(row: -1, column: -3),
        ]
        
        let actualNeighbors = neighbors
        #expect(actualNeighbors == expectedNeighbors)
    }
    
    @Test func ring() {
        let center = Hexagon.Index(row: 6, column: 6)
        let ring = HexGridMath.ringIndices(center: center, radius: 2)
        #expect(ring.count == 12)
    }
    
    @Test func moveFromCenter() {
        let start = Hexagon.Index(row: 16, column: 14)
        
        let left = start.move(direction: .left, amount: 2)
        #expect(left == Hexagon.Index(row: 16, column: 12))
        
        let right = start.move(direction: .right, amount: 2)
        #expect(right == Hexagon.Index(row: 16, column: 16))
        
        let leftTop = start.move(direction: .leftTop, amount: 2)
        #expect(leftTop == Hexagon.Index(row: 14, column: 13))
        
        let rightTop = start.move(direction: .rightTop, amount: 2)
        #expect(rightTop == Hexagon.Index(row: 14, column: 15))
        
        let leftBottom = start.move(direction: .leftBottom, amount: 2)
        #expect(leftBottom == Hexagon.Index(row: 18, column: 13))
        
        let rightBottom = start.move(direction: .rightBottom, amount: 2)
        #expect(rightBottom == Hexagon.Index(row: 18, column: 15))
    }
    
    @Test func moveFromNegativeCoordinates() {
        let start = Hexagon.Index(row: -13, column: -17)
        
        let left = start.move(direction: .left, amount: 2)
        #expect(left == Hexagon.Index(row: -13, column: -19))
        
        let right = start.move(direction: .right, amount: 2)
        #expect(right == Hexagon.Index(row: -13, column: -15))
        
        let leftTop = start.move(direction: .leftTop, amount: 2)
        #expect(leftTop == Hexagon.Index(row: -15, column: -18))
        
        let rightTop = start.move(direction: .rightTop, amount: 2)
        #expect(rightTop == Hexagon.Index(row: -15, column: -16))
        
        let leftBottom = start.move(direction: .leftBottom, amount: 2)
        #expect(leftBottom == Hexagon.Index(row: -11, column: -18))
        
        let rightBottom = start.move(direction: .rightBottom, amount: 2)
        #expect(rightBottom == Hexagon.Index(row: -11, column: -16))
    }
    
}
