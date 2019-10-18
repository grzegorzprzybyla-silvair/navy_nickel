//
//  MBEMetalView.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła(S) on 18/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import UIKit
import Metal

class MBEMetalView: UIView {
    override class var layerClass: AnyClass { return CAMetalLayer.self }
    var metalLayer: CAMetalLayer { return layer as! CAMetalLayer }
    private lazy var device: MTLDevice = {
        let device = MTLCreateSystemDefaultDevice()
        self.metalLayer.device = device
        self.metalLayer.pixelFormat = .bgra8Unorm
        return device!
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        _ = device
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = device
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        redraw()
    }
    
    private func redraw() {
        guard let drawable = metalLayer.nextDrawable() else { return }
        let texture = drawable.texture
        let passDescriptor = MTLRenderPassDescriptor()
        passDescriptor.colorAttachments[0].texture = texture
        passDescriptor.colorAttachments[0].loadAction = .clear
        passDescriptor.colorAttachments[0].storeAction = .store
        passDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        let commandQueue = device.makeCommandQueue()
        let commandBuffer = commandQueue?.makeCommandBuffer()
        let encoder = commandBuffer?.makeRenderCommandEncoder(descriptor: passDescriptor)
        encoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
