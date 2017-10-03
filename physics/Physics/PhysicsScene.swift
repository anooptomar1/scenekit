//
//  PhysicsScene.swift
//  Physics
//
//  Created by Ibram Uppal on 11/15/15.
//  Copyright © 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

let physicsHelper = HelperStruct()

class PhysicsScene: SCNScene, SCNSceneRendererDelegate {
    
    convenience init(create: Bool) {
        self.init()
        
        setupLightsAndCamera()
        
        // gareth gravity
        self.physicsWorld.gravity = SCNVector3(0, 0, 0)
        
        let floorGeo = SCNFloor()
        floorGeo.firstMaterial = physicsHelper.getFloorMaterial()
        
        let floorNode = SCNNode(geometry: floorGeo)
        
        floorNode.physicsBody = SCNPhysicsBody.static()
        rootNode.addChildNode(floorNode)
        
        let invisiPlane = physicsHelper.getPhysicsPlane()
        let planePosScaler = Float(physicsHelper.planeScaler)
        let planeOpacity:CGFloat = 0
        
        let invisiplaneFront = SCNNode(geometry: invisiPlane)
        invisiplaneFront.opacity = planeOpacity
        invisiplaneFront.position = SCNVector3(0,0,planePosScaler)
        invisiplaneFront.physicsBody = physicsHelper.getPlanePhysicsBody()
        rootNode.addChildNode(invisiplaneFront)
        
        let invisiplaneLeft = SCNNode(geometry: invisiPlane)
        invisiplaneLeft.opacity = planeOpacity
        invisiplaneLeft.position = SCNVector3(-planePosScaler,0,0)
        invisiplaneLeft.rotation = SCNVector4(0,1,0,GLKMathDegreesToRadians(90))
        invisiplaneLeft.physicsBody = physicsHelper.getPlanePhysicsBody()
        rootNode.addChildNode(invisiplaneLeft)
        
        let invisiplaneRight = SCNNode(geometry: invisiPlane)
        invisiplaneRight.opacity = planeOpacity
        invisiplaneRight.position = SCNVector3(planePosScaler,0,0)
        invisiplaneRight.rotation = SCNVector4(0,1,0,-GLKMathDegreesToRadians(90))
        invisiplaneRight.physicsBody = physicsHelper.getPlanePhysicsBody()
        rootNode.addChildNode(invisiplaneRight)

        let invisiplaneBack = SCNNode(geometry: invisiPlane)
        invisiplaneBack.opacity = planeOpacity
        invisiplaneBack.position = SCNVector3(0,0,-planePosScaler)
        invisiplaneBack.physicsBody = physicsHelper.getPlanePhysicsBody()
        rootNode.addChildNode(invisiplaneBack)

        let invisiplaneTop = SCNNode(geometry: invisiPlane)
        invisiplaneTop.opacity = planeOpacity
        invisiplaneTop.position = SCNVector3(0,planePosScaler,0)
        invisiplaneTop.rotation = SCNVector4(1,0,0,GLKMathDegreesToRadians(90))
        invisiplaneTop.physicsBody = physicsHelper.getPlanePhysicsBody()
        rootNode.addChildNode(invisiplaneTop)
        
        var i = 1
        floorNode.runAction(
            SCNAction.repeat(
                SCNAction.sequence(
                    [
                        SCNAction.run({ (node) in
                            if i > 15 {
                                i = 1
                            }
                            self.rootNode.addChildNode(physicsHelper.getSphere(increase: Float(i)))
                            i += 1
                        }),
                        SCNAction.wait(duration: 0.01)
                    ]
                )
            , count: 200)
        )
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
//
////        print(sphere.physicsBody?.velocity.y)
//    }
    
    func setupLightsAndCamera() {
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = false
        cameraNode.position = SCNVector3(x: 0, y: 2, z: 5)
        
//        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -5)
        
        let lightNodeSpot = SCNNode()
        lightNodeSpot.light = SCNLight()
        lightNodeSpot.light!.type = .spot
        lightNodeSpot.light!.spotOuterAngle = 90
        lightNodeSpot.light!.attenuationStartDistance = 0.0
        lightNodeSpot.light!.attenuationFalloffExponent = 2
        lightNodeSpot.light!.attenuationEndDistance = 30
        lightNodeSpot.position = SCNVector3(x: 0, y: 10, z: 1)
        
        let emptyAtCenter = SCNNode()
        emptyAtCenter.position = SCNVector3Zero
        rootNode.addChildNode(emptyAtCenter)
        
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
        cameraNode.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
        rootNode.addChildNode(cameraNode)
        rootNode.addChildNode(lightNodeSpot)
        
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        cameraNode.camera!.usesOrthographicProjection = false
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
//        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -8)
//
//        cameraNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(Double.pi * 2), around: SCNVector3(0,1,0), duration: 10)))
//
//        self.rootNode.addChildNode(cameraNode)
//
//        let lightNodeSpot = SCNNode()
//        lightNodeSpot.light = SCNLight()
//        lightNodeSpot.light!.type = .spot
//        lightNodeSpot.position = SCNVector3(x: 30, y: 30, z: 30)
//        lightNodeSpot.light!.categoryBitMask = 2
//
//        let empty = SCNNode()
//        empty.position = SCNVector3(x: 10, y: 4, z: 4)
//        self.rootNode.addChildNode(empty)
//
//        lightNodeSpot.constraints = [SCNLookAtConstraint(target: empty)]
//        cameraNode.addChildNode(lightNodeSpot)
        
    }
    
}
