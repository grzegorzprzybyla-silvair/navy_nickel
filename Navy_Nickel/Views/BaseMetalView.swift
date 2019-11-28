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

    var vertexFunctionName: String { return "base_vertex_main" }
    var fragmentFuncName: String { return "base_fragment_main" }

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
    var lastFrameTimestamp: CFTimeInterval = 0.0

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
            
          if lastFrameTimestamp == 0.0 {
            lastFrameTimestamp = sender.timestamp
          }
            
          let elapsed: CFTimeInterval = sender.timestamp - lastFrameTimestamp
          lastFrameTimestamp = sender.timestamp
            
          gameLoop(timeSinceLastUpdate: elapsed)
    }

    func gameLoop(timeSinceLastUpdate: CFTimeInterval) {
    }

    private func setup() {
        _ = device
        commandQueue = device.makeCommandQueue()
        makePipeline()
    }

    private func makePipeline() {
        guard let library = device.makeDefaultLibrary() else { return }
        let vertexFunc = library.makeFunction(name: vertexFunctionName)
        let fragmentFunc = library.makeFunction(name: fragmentFuncName)

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
