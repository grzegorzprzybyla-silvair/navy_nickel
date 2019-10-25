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
    lazy var objectToDraw: Triangle = {
        return Triangle(device: self.device)
    }()

    override func redraw() {
        guard let drawable = metalLayer.nextDrawable() else { return }
        objectToDraw.render(commandQueue: commandQueue, piplineState: pipeline, drawable: drawable, clearColor: nil)
    }
}
