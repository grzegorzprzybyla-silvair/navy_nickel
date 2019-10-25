//
//  MBEVertex.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła on 25/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import Foundation
import simd

struct Vertex {
    let position: SIMD4<Float>
    let color: SIMD4<Float>
}

extension Vertex {
    init(positions: [Float], colors: [Float]) {
        self.position = SIMD4<Float>(x: positions[0], y: positions[1], z: positions[2], w: positions[3])
        self.color = SIMD4<Float>(x: colors[0], y: colors[1], z: colors[2], w: colors[3])
    }
}
