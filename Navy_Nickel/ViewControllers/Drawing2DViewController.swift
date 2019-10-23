//
//  Drawing2DViewController.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła(S) on 19/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import UIKit
import Metal
import simd

class Drawing2DViewController: UIViewController {
    override func loadView() {
        let view = MBEMetalView()
        self.view = view
    }
}

extension Drawing2DViewController {
    class MBEMetalView: UIView {
        override class var layerClass: AnyClass { return CAMetalLayer.self }
        var metalLayer: CAMetalLayer { return layer as! CAMetalLayer }
        private lazy var device: MTLDevice = {
            let device = MTLCreateSystemDefaultDevice()
            self.metalLayer.device = device
            self.metalLayer.pixelFormat = .bgra8Unorm
            return device!
        }()
        var vertexBuffer: MTLBuffer!
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
        
        @objc private func displayLinkDidFire(_ sender: CADisplayLink) {
            autoreleasepool { [weak self] in
                self?.redraw()
            }
        }
        
        private func setup() {
            _ = device
            commandQueue = device.makeCommandQueue()
            makeBuffers()
            makePipeline()
        }
        struct Vertex {
            let position: SIMD4<Float>
            let color: SIMD4<Float>
        }
        
        private func makeBuffers() {
            let vertex: [Vertex] = [
                Vertex(position: SIMD4<Float>(x: 0, y: 0.5, z: 0, w: 1), color: SIMD4<Float>(x: 1, y: 0, z: 0, w: 1)),
                Vertex(position: SIMD4<Float>(x: -0.5, y: -0.5, z: 0, w: 1), color: SIMD4<Float>(x: 0, y: 1, z: 0, w: 1)),
                Vertex(position: SIMD4<Float>(x: 0.5, y: -0.5, z: 0, w: 1), color: SIMD4<Float>(x: 0, y: 0, z: 1, w: 1)),
            ]
            
            vertexBuffer = device.makeBuffer(bytes: vertex, length: vertex.sizeOf(), options: [])
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
        
        private func redraw() {
            guard let drawable = metalLayer.nextDrawable() else { return }
            let texture = drawable.texture
            let passDescriptor = MTLRenderPassDescriptor()
            passDescriptor.colorAttachments[0].texture = texture
            passDescriptor.colorAttachments[0].loadAction = .clear
            passDescriptor.colorAttachments[0].storeAction = .store
            passDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
            
            let commandBuffer = commandQueue!.makeCommandBuffer()
            let encoder = commandBuffer!.makeRenderCommandEncoder(descriptor: passDescriptor)!
            encoder.setRenderPipelineState(pipeline)
            encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
            encoder.endEncoding()
            
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }
}
