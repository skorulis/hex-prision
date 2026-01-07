//Created by Alexander Skorulis on 4/1/2026.

@testable import HexPrison
import Testing

@MainActor struct BlobShapeTests {
    
    @Test func none() {
        let shape = BlobShape.getShape(
            blob: [
                Hexagon.Index(row: 4, column: 2),
                Hexagon.Index(row: 5, column: 2)
            ]
        )
        
        #expect(shape == .none)
    }
    
    @Test func triangle() {
        let shape = BlobShape.getShape(
            blob: [
                Hexagon.Index(row: 6, column: 2),
                Hexagon.Index(row: 7, column: 1),
                Hexagon.Index(row: 7, column: 2),
            ]
        )
        
        #expect(shape == .triangle)
    }
    
    @Test func hexagon() {
        let shape = BlobShape.getShape(
            blob: [
                Hexagon.Index(row: 6, column: 2),
                Hexagon.Index(row: 6, column: 3),
                Hexagon.Index(row: 7, column: 1),
                Hexagon.Index(row: 7, column: 2),
                Hexagon.Index(row: 7, column: 3),
                Hexagon.Index(row: 8, column: 2),
                Hexagon.Index(row: 8, column: 3),
            ]
        )
        
        #expect(shape == .hexagon)
    }
}
