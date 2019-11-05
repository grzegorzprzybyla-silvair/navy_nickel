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
    var projectionMatrix: Matrix4!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degrees(toRad: 85.0),
                                                            aspectRatio: Float(bounds.size.width / bounds.size.height),
                                                            nearZ: 0.01, farZ: 100.0)
    }
    
    override func gameLoop(timeSinceLastUpdate: CFTimeInterval) {
        node.updateWithDelta(delta: timeSinceLastUpdate)
        autoreleasepool { [weak self] in
            self?.redraw()
        }
    }

    override func redraw() {
        guard let drawable = metalLayer.nextDrawable() else { return }
        let worldModelMatrix = Matrix4()
        worldModelMatrix.translate(0.0, y: 0.0, z: -7.0)
        worldModelMatrix.rotateAroundX(Matrix4.degrees(toRad: 25), y: 0.0, z: 0.0)
        node.render(commandQueue: commandQueue, piplineState: pipeline, drawable: drawable,
                    parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: nil)
    }
}
