//Created by Alexander Skorulis on 16/1/2026.

import Foundation

enum Achievement: Equatable, Hashable {
    case earnDots(Double)
    case earnTriangles(Double)
    case earnHexagons(Double)
    
    var description: String {
        switch self {
        case let .earnDots(int):
            return "Earn \(int) dots"
        case let .earnTriangles(int):
            return "Earn \(int) triangles"
        case let .earnHexagons(int):
            return "Earn \(int) hexagons"
        }
    }
}

extension Achievement {
    
    static var all: [Achievement] {
        earnings
    }
    
    static var earnings: [Achievement] {
        [
            .earnDots(1),
            .earnDots(100),
            .earnDots(10000),
            .earnDots(1000000),
            
            .earnTriangles(1),
            .earnTriangles(100),
            .earnTriangles(10000),
            .earnTriangles(1000000),
            
            .earnHexagons(1),
            .earnHexagons(100),
            .earnHexagons(10000),
            .earnHexagons(1000000),
        ]
    }
}
