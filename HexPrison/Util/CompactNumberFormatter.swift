//  Created by Alexander Skorulis on 14/9/2025.

import Foundation

nonisolated struct CompactNumberFormatter {
    
    static let shared = CompactNumberFormatter()
    
    nonisolated init() {}
    
    nonisolated func string(_ double: Double) -> String {
        let absValue = abs(double)
        let scale = Scale.allCases.first(where: { $0.limit > absValue}) ?? Scale.exa
        let toFormat = double / scale.divisor
        return "\(String(format: "%.1f", toFormat))\(scale.abbreviation)"
    }
    
    static func string(_ double: Double) -> String {
        shared.string(double)
    }
    
}

extension CompactNumberFormatter {
    private typealias LOOKUP = (range: Range<Double>, divisor: Double, scale: Scale)
}

extension CompactNumberFormatter {
    nonisolated enum Scale: Int, CaseIterable {
        case none = 0
        case kilo = 1
        case mega = 2
        case giga = 3
        case tera = 4
        case peta = 5
        case exa = 6

        var limit: Double {
            switch self {
            case .none:
                return 1000
            case .kilo:
                return 1_000_000
            case .mega:
                return 1_000_000_000
            case .giga:
                return 1_000_000_000_000
            case .tera:
                return 1_000_000_000_000_000
            case .peta:
                return 1_000_000_000_000_000_000
            case .exa:
                return .greatestFiniteMagnitude
            }
        }
        
        var divisor: Double {
            switch self {
            case .none:
                return 1
            case .kilo:
                return 1000
            case .mega:
                return 1_000_000
            case .giga:
                return 1_000_000_000
            case .tera:
                return 1_000_000_000_000
            case .peta:
                return 1_000_000_000_000_000
            case .exa:
                return 1_000_000_000_000_000_000
            }
        }

        var abbreviation: String {
            switch self {
            case .none:
                return ""
            case .kilo:
                return "K"
            case .mega:
                return "M"
            case .giga:
                return "B"
            case .tera:
                return "T"
            case .peta:
                return "q"
            case .exa:
                return "Q"
            }
        }
    }
}
