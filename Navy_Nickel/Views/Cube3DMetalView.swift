//
//  Cube3DMetalView.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła on 25/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import Foundation
import Metal

typealias Index = UInt16
let IndexType = MTLIndexType.uint16

class Cube3DMetalView: BaseMetalView {
    var indexBuffer: MTLBuffer!

    func makeBuffers() {
        let vertices: [Vertex] = [
            Vertex(positions: [-1, 1, 1,1], colors: [0,1,1,1]),
            Vertex(positions: [-1,-1, 1,1], colors: [0,0,1,1]),
            Vertex(positions: [1,-1, 1,1], colors: [1,0,1,1]),
            Vertex(positions: [1, 1, 1,1], colors: [1,1,1,1]),
            Vertex(positions: [-1, 1,-1,1], colors: [0,1,0,1]),
            Vertex(positions: [-1,-1,-1,1], colors: [0,0,0,1]),
            Vertex(positions: [1,-1,-1,1], colors: [1,0,0,1]),
            Vertex(positions: [1,1,-1,1], colors: [1,1,0,1])
            ]
//        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.memoryLayoutSize(), options: [])

        let indices: [Index] = [
            3,2,6,6,7,3,
            4,5,1,1,0,4,
            4,0,3,3,7,4,
            1,5,6,6,2,1,
            0,1,2,2,3,0,
            7,6,5,5,4,7
        ]

        indexBuffer = device.makeBuffer(bytes: indices, length: indices.memoryLayoutSize(), options: [])
    }

    override func redraw() {
        
    }
}
