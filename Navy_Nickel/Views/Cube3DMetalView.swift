//
//  Cube3DMetalView.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła on 25/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import Foundation
import Metal

class Cube3DMetalView: BaseMetalView {
    lazy var node: Cube = {
        return Cube(device: self.device)
    }()


    override func redraw() {
        guard let drawable = metalLayer.nextDrawable() else { return }
        node.render(commandQueue: commandQueue, piplineState: pipeline, drawable: drawable, clearColor: nil)
    }
}
