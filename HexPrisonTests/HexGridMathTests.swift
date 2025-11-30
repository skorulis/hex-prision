//Created by Alexander Skorulis on 30/11/2025.

@testable import HexPrison
import Testing

@MainActor struct HexGridMathTests {
    
    @Test func adjacentIndices_EvenRow() async throws {
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
    
    @Test func adjacentIndices_OddRow() async throws {
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
    
    @Test func adjacentIndices_Origin() async throws {
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
    
    @Test func adjacentIndices_NegativeCoordinates_ReturnsCorrectNeighbors() async throws {
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
    
}
