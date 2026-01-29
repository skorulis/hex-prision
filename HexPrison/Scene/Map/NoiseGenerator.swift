// Created by Xcode Assistant on 29/1/2026

import Foundation

public final class NoiseGenerator {
    public var seed: UInt64
    public var frequency: Double
    public var octaves: Int
    public var persistence: Double
    public var lacunarity: Double

    public init(seed: UInt64 = 0xDEADBEEF, frequency: Double = 1.0, octaves: Int = 1, persistence: Double = 0.5, lacunarity: Double = 2.0) {
        self.seed = seed
        self.frequency = frequency
        self.octaves = max(1, octaves)
        self.persistence = persistence
        self.lacunarity = lacunarity
    }
}

public extension NoiseGenerator {
    /// Returns a deterministic noise value in the range [-1, 1] for the given coordinate.
    func value(x: Double, y: Double) -> Double {
        // Fractal Brownian Motion (fBm) over value noise
        var total = 0.0
        var amplitude = 1.0
        var freq = frequency
        var maxAmplitude = 0.0

        for _ in 0..<octaves {
            total += amplitude * valueNoise2D(x * freq, y * freq)
            maxAmplitude += amplitude
            amplitude *= persistence
            freq *= lacunarity
        }

        // Normalize to [-1, 1]
        if maxAmplitude > 0 {
            total /= maxAmplitude
        }
        return total
    }

    /// Convenience that maps the [-1, 1] output to [0, 1].
    func value01(x: Double, y: Double) -> Double {
        let v = value(x: x, y: y)
        return 0.5 * (v + 1.0)
    }
}

private extension NoiseGenerator {
    // Hash a 2D integer coordinate into a pseudo-random Double in [-1, 1]
    func hash2D(_ xi: Int64, _ yi: Int64) -> Double {
        // 64-bit mix based on splitmix64
        var z = UInt64(bitPattern: xi &* 0x9E3779B97F4A7C1) &+ UInt64(bitPattern: yi &* 0xC2B2AE3D27D4EB4) &+ seed
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        z = z ^ (z >> 31)
        // Map to [0,1]
        let u = Double(z) / Double(UInt64.max)
        // Map to [-1,1]
        return u * 2.0 - 1.0
    }

    // Smoothstep function for interpolation
    @inline(__always)
    func smoothstep(_ t: Double) -> Double {
        // Quintic smoothing for better continuity: 6t^5 - 15t^4 + 10t^3
        return t * t * t * (t * (t * 6 - 15) + 10)
    }

    // Bilinear interpolation between four corners
    @inline(__always)
    func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double { a + (b - a) * t }

    func valueNoise2D(_ x: Double, _ y: Double) -> Double {
        // Determine integer lattice cell
        let xi0 = Int64(floor(x))
        let yi0 = Int64(floor(y))
        let xi1 = xi0 &+ 1
        let yi1 = yi0 &+ 1

        // Local coordinates within the cell
        let tx = x - floor(x)
        let ty = y - floor(y)

        // Smooth weights
        let sx = smoothstep(tx)
        let sy = smoothstep(ty)

        // Corner values from hash
        let c00 = hash2D(xi0, yi0)
        let c10 = hash2D(xi1, yi0)
        let c01 = hash2D(xi0, yi1)
        let c11 = hash2D(xi1, yi1)

        // Interpolate along x then y
        let ix0 = lerp(c00, c10, sx)
        let ix1 = lerp(c01, c11, sx)
        let v = lerp(ix0, ix1, sy)
        return v
    }
}
