//
//  Triangle.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła on 25/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import Foundation
import Metal

class Triangle: Node {
    init(device: MTLDevice) {
        let vertex = [
            Vertex(position: [0, 0.5, 0, 1], color: [1, 0, 0, 1]),
            Vertex(position: [-0.5,-0.5, 0, 1], color: [0, 1,0,1]),
            Vertex(position: [0.5,  -0.5, 0, 1], color: [0, 0, 1, 1])
        ]
        super.init(name: "Traingle", device: device, verticies: vertex)
    }
}
