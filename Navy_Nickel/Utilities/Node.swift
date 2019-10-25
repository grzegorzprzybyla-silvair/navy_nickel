//
//  Node.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła on 25/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import Foundation
import Metal
import QuartzCore

class Node {
    let device: MTLDevice
    let name: String
    var vertexCount: Int
    var vertexBuffer: MTLBuffer

    init(name: String, device: MTLDevice, verticies: [Vertex]) {
        self.device = device
        self.name = name

        vertexBuffer = device.makeBuffer(bytes: verticies, length: verticies.memoryLayoutSize(), options: [])!
        vertexCount = verticies.count
    }

    func render(commandQueue: MTLCommandQueue, piplineState: MTLRenderPipelineState, drawable: CAMetalDrawable, clearColor: MTLClearColor?) {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1)

        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }

        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder?.setRenderPipelineState(piplineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount, instanceCount: vertexCount/3)
        renderEncoder?.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
