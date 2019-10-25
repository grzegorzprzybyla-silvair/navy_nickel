//
//  BaseMetalView.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła on 25/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import UIKit
import Metal

class BaseMetalView: UIView {
    override class var layerClass: AnyClass { return CAMetalLayer.self }
    var metalLayer: CAMetalLayer { return layer as! CAMetalLayer }
    lazy var device: MTLDevice = {
        let device = MTLCreateSystemDefaultDevice()
        self.metalLayer.device = device
        self.metalLayer.pixelFormat = .bgra8Unorm
        return device!
    }()
    var commandQueue: MTLCommandQueue!
    var pipeline: MTLRenderPipelineState!

    var displayLink: CADisplayLink?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if superview != nil {
            displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidFire(_:)))
            displayLink?.add(to: .main, forMode: .common)
        } else {
            displayLink?.invalidate()
            self.displayLink = nil
        }
    }

    @objc func displayLinkDidFire(_ sender: CADisplayLink) {
        autoreleasepool { [weak self] in
            self?.redraw()
        }
    }

    private func setup() {
        _ = device
        commandQueue = device.makeCommandQueue()
        makePipeline()
    }

    private func makePipeline() {
        guard let library = device.makeDefaultLibrary() else { return }
        let vertexFunc = library.makeFunction(name: "vertex_main")
        let fragmentFunc = library.makeFunction(name: "fragment_main")

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunc
        pipelineDescriptor.fragmentFunction = fragmentFunc
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalLayer.pixelFormat
        do {
            pipeline = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Error: \(error)")
        }
    }
    func redraw() {}
}
