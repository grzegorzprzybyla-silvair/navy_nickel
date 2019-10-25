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
   override func makeBuffers() {
        let vertex: [Vertex] = [
            Vertex(position: [0, 0.5, 0, 1], color: [1, 0, 0, 1]),
            Vertex(position: [-0.5,-0.5, 0, 1], color: [0, 1,0,1]),
            Vertex(position: [0.5,  -0.5, 0, 1], color: [0, 0, 1, 1])
        ]

        vertexBuffer = device.makeBuffer(bytes: vertex, length: vertex.memoryLayoutSize(), options: [])
    }

    override func makePipeline() {
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

    override func redraw() {
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
