//
//  Cube3DMetalView.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła on 25/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import Foundation
import Metal

// https://www.raywenderlich.com/728-metal-tutorial-with-swift-3-part-2-moving-to-3d#toc-anchor-009
class Cube3DMetalView: BaseMetalView {
    lazy var node: Cube = {
        return Cube(device: self.device)
    }()


    override func redraw() {
        guard let drawable = metalLayer.nextDrawable() else { return }
        node.positionX = -0.25
        node.positionY = -0.25
        node.positionZ = -0.25
        node.rotationZ = Matrix4.degrees(toRad: 45)
        node.scale = 0.5
        node.render(commandQueue: commandQueue, piplineState: pipeline, drawable: drawable, clearColor: nil)
    }
}
