//
//  Traingle2DMetalView.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła on 25/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import UIKit
import Metal

class Traingle2DMetalView: BaseMetalView {

    override var vertexFunctionName: String { "traingle_vertex_main" }
    override var fragmentFuncName: String { "triangle_fragment_main" }

    lazy var objectToDraw: Triangle = {
        return Triangle(device: self.device)
    }()
    var projectionMatrix: Matrix4!

    override func layoutSubviews() {
        super.layoutSubviews()
        projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degrees(toRad: 85.0),
                                                            aspectRatio: Float(bounds.size.width / bounds.size.height),
                                                            nearZ: 0.01, farZ: 100.0)
    }

    override func redraw() {
        guard let drawable = metalLayer.nextDrawable() else { return }
        let worldModelMatrix = Matrix4()
        objectToDraw.render(commandQueue: commandQueue, piplineState: pipeline, drawable: drawable,
                            parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: nil)
    }
}
