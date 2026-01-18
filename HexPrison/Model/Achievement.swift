//Created by Alexander Skorulis on 16/1/2026.

import Foundation
import SwiftUI

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

// MARK: - Identifiable

extension Achievement: Identifiable {
    
    var icon: Image {
        switch self {
        case .earnDots:
            return Image(systemName: "circle.fill")
        case .earnTriangles:
            return Image(systemName: "triangle.fill")
        case .earnHexagons:
            return Image(systemName: "hexagon.fill")
        }
    }
    
    var color: Color {
        switch self {
        case .earnDots(let double), .earnTriangles(let double), .earnHexagons(let double):
            if double < 100 {
                return .white
            } else {
                return .orange
            }
        }
    }
    
    var id: String {
        switch self {
        case let .earnDots(double):
            return "dots-\(double)"
        case let .earnTriangles(double):
            return "triangles-\(double)"
        case let .earnHexagons(double):
            return "hexagons-\(double)"
        }
    }
    
}
