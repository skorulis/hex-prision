//Created by Alexander Skorulis on 4/1/2026.

@testable import HexPrison
import Testing

@MainActor struct HexagonMapTests {
    
    @Test func blob() {
        var map = HexagonMap()
        let i1 = Hexagon.Index(row: 6, column: 2)
        let i2 = Hexagon.Index(row: 5, column: 2)
        let i3 = Hexagon.Index(row: 6, column: 3)
        let i4 = Hexagon.Index(row: 7, column: 2)
        
        // Starts empty
        #expect(map.getBlob(index: i1) == [])
        
        // With 1 item set the blob is just that item
        map.set(flipped: true, index: i1)
        #expect(map.getBlob(index: i1) == [i1])
        
        // the 2 items are connected
        map.set(flipped: true, index: i2)
        #expect(map.getBlob(index: i1) == [i1, i2])
        
        map.set(flipped: true, index: i3)
        map.set(flipped: true, index: i4)
        #expect(map.getBlob(index: i1) == [i1, i2, i3, i4])
    }
    
    @Test func unconnectedBlob() {
        var map = HexagonMap()
        
        let i1 = Hexagon.Index(row: 0, column: 0)
        let i2 = Hexagon.Index(row: 2, column: 2)
        
        map.set(flipped: true, index: i1)
        map.set(flipped: true, index: i2)
        
        #expect(map.getBlob(index: i1) == [i1])
        #expect(map.getBlob(index: i2) == [i2])
    }
}
