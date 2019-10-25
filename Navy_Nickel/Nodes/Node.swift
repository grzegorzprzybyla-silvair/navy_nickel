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

    var positionX: Float = 0.0
    var positionY: Float = 0.0
    var positionZ: Float = 0.0

    var rotationX: Float = 0.0
    var rotationY: Float = 0.0
    var rotationZ: Float = 0.0
    var scale: Float     = 1.0

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

        let modelMatrix = self.modelMatrix()
        let dataSize = MemoryLayout<Float>.stride * Matrix4.numberOfElements()
        let uniformBuffer = device.makeBuffer(length: dataSize, options: [])!
        let bufferPointer = uniformBuffer.contents()
        memcpy(bufferPointer, modelMatrix.raw(), MemoryLayout<Float>.size * Matrix4.numberOfElements())
        renderEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)

        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount, instanceCount: vertexCount/3)
        renderEncoder?.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    func modelMatrix() -> Matrix4 {
        let matrix = Matrix4()
        matrix.translate(positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(rotationX, y: rotationY, z: rotationZ)
        matrix.scale(scale, y: scale, z: scale)
        return matrix
    }
}
