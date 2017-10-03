//
//  DropScene.swift
//  Drop
//
//  Created by Ibram Uppal on 4/14/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class DropScene: SCNScene, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    let physicsHelper = HelperStruct()
    var stopper = SCNNode()
    var torusNode = SCNNode()
    var triggered = false
    var triggeredTorus = false
    
    enum CollisionCategory : Int {
        case sphere = 1
        case block
        case triggerBlock
        case torus
    }
    
    convenience init(create: Bool) {
        self.init()
        
        physicsWorld.contactDelegate = self
        
        let floorGeo = SCNFloor()
        floorGeo.firstMaterial = physicsHelper.getFloorMaterial()
        let floorNode = SCNNode(geometry: floorGeo)
        floorNode.physicsBody = SCNPhysicsBody.static()
        
        rootNode.addChildNode(floorNode)
        
        // add plank
        let plankTop = physicsHelper.getWoodBlock(width: 1.5)
        plankTop.position = SCNVector3(-0.5, 2, 0)
        plankTop.rotation = SCNVector4(0,0,1,-0.3)
        // assign the category bit mask for thins type of object
        plankTop.physicsBody!.categoryBitMask = CollisionCategory.block.rawValue
        // only collide with items of this category bit mask
        if #available(iOS 9.0, *) {
            plankTop.physicsBody!.contactTestBitMask = CollisionCategory.block.rawValue | CollisionCategory.sphere.rawValue
        } else {
            plankTop.physicsBody!.collisionBitMask = CollisionCategory.block.rawValue | CollisionCategory.sphere.rawValue
        }


        rootNode.addChildNode(plankTop)

        let plankMiddle = physicsHelper.getWoodBlock(width: 2)
        plankMiddle.position = SCNVector3(0.7, 1, 0)
        plankMiddle.physicsBody = SCNPhysicsBody.dynamic()

        // assign the category bit mask for thins type of object
        plankMiddle.physicsBody!.categoryBitMask = CollisionCategory.block.rawValue
        // only collide with items of this category bit mask
        if #available(iOS 9.0, *) {
            plankMiddle.physicsBody!.contactTestBitMask = CollisionCategory.block.rawValue | CollisionCategory.sphere.rawValue
        } else {
            plankMiddle.physicsBody!.collisionBitMask = CollisionCategory.block.rawValue | CollisionCategory.sphere.rawValue
        }

        rootNode.addChildNode(plankMiddle)

        stopper = physicsHelper.getWoodBlock(width: 0.3)
        stopper.position = SCNVector3(0.3, 0.5, 0)

        // assign the category bit mask for thins type of object
        stopper.physicsBody!.categoryBitMask = CollisionCategory.block.rawValue
        // only collide with items of this category bit mask
        if #available(iOS 9.0, *) {
            stopper.physicsBody!.contactTestBitMask = CollisionCategory.block.rawValue
        } else {
            stopper.physicsBody!.collisionBitMask = CollisionCategory.block.rawValue
        }

        rootNode.addChildNode(stopper)

        let moveUp = SCNAction.move(by: SCNVector3(0, 0.5, 0), duration: 2)
        moveUp.timingMode = .easeInEaseOut

        stopper.runAction(moveUp)

        let hinge = SCNPhysicsHingeJoint(body: plankMiddle.physicsBody!, axis: SCNVector3(0,0,1), anchor: SCNVector3(0.75, 0, 0))

        physicsWorld.addBehavior(hinge)

        let plankRight = physicsHelper.getWoodBlock(width: 0.5)
        plankRight.position = SCNVector3(0.75, 0.45, 0)
        plankRight.rotation = SCNVector4(0, 0, 1, 1.57)
        plankRight.physicsBody!.categoryBitMask = CollisionCategory.triggerBlock.rawValue
        if #available(iOS 9.0, *) {
            plankRight.physicsBody!.contactTestBitMask = CollisionCategory.sphere.rawValue
        } else {
            plankRight.physicsBody!.collisionBitMask = CollisionCategory.sphere.rawValue
        }

        plankMiddle.addChildNode(plankRight)

        let sphereGeo = SCNSphere(radius: 0.15)
        sphereGeo.firstMaterial = physicsHelper.getCheckerMaterial()

        let sphereNode = SCNNode(geometry: sphereGeo)
        sphereNode.position = SCNVector3(-0.9, 3, 0)
        sphereNode.physicsBody = SCNPhysicsBody.dynamic()
        // assign the category bit mask for thins type of object
        sphereNode.physicsBody!.categoryBitMask = CollisionCategory.sphere.rawValue
        // only collide with items of this category bit mask
        if #available(iOS 9.0, *) {
            sphereNode.physicsBody!.contactTestBitMask = CollisionCategory.block.rawValue | CollisionCategory.triggerBlock.rawValue | CollisionCategory.torus.rawValue
        } else {
            sphereNode.physicsBody!.collisionBitMask = CollisionCategory.block.rawValue | CollisionCategory.triggerBlock.rawValue | CollisionCategory.torus.rawValue
        }
        sphereNode.physicsBody!.mass = 1
        // how velocitys are interprited for x, y, z
        // in this line we stop the ball from falling off the plank in the z axis
        sphereNode.physicsBody!.velocityFactor = SCNVector3(1,1,0)

        rootNode.addChildNode(sphereNode)
        
        // add the torus
        let torusGeo = SCNTorus(ringRadius: 0.5, pipeRadius: 0.1)
        torusGeo.firstMaterial = physicsHelper.getCheckerMaterial()
        
        torusNode = SCNNode(geometry: torusGeo)
        torusNode.position = SCNVector3(-0.9,0.5,0)
        torusNode.rotation = SCNVector4(0,0,1,-0.77)
        torusNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: torusGeo, options: nil))
        if let body = torusNode.physicsBody {
            torusNode.physicsBody!.categoryBitMask = CollisionCategory.torus.rawValue
            if #available(iOS 9.0, *) {
                body.contactTestBitMask = CollisionCategory.sphere.rawValue
            } else {
                body.collisionBitMask = CollisionCategory.sphere.rawValue
            }
            body.mass = 0.000001
        }
        
        rootNode.addChildNode(torusNode)
        
        setupLightsAndCamera()
        
    }
    
    func setupLightsAndCamera() {
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = false
        cameraNode.position = SCNVector3(x: 0, y: 2, z: 5)
//        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -5)
        
        let lightOne = SCNLight()
        lightOne.type = .spot
        lightOne.spotOuterAngle = 90
        lightOne.attenuationStartDistance = 0.0
        lightOne.attenuationFalloffExponent = 2
        lightOne.attenuationEndDistance = 30
        
        let lightNodeSpot = SCNNode()
        lightNodeSpot.light = lightOne
        lightNodeSpot.position = SCNVector3(x: 0, y: 10, z: 1)
        
        let lightNodeFront = SCNNode()
        lightNodeFront.light = lightOne
        lightNodeFront.position = SCNVector3(x: 0, y: 1, z: 15)
        
        let emptyAtCenter = SCNNode()
        emptyAtCenter.position = SCNVector3Zero
        rootNode.addChildNode(emptyAtCenter)
        
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
        lightNodeFront.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
        cameraNode.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
        rootNode.addChildNode(cameraNode)
        rootNode.addChildNode(lightNodeSpot)
        rootNode.addChildNode(lightNodeFront)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let isASphere = contact.nodeA.physicsBody!.categoryBitMask == CollisionCategory.sphere.rawValue
        let isATrigger = contact.nodeA.physicsBody!.categoryBitMask == CollisionCategory.triggerBlock.rawValue
        let isATorus = contact.nodeA.physicsBody!.categoryBitMask == CollisionCategory.torus.rawValue
        
        let isBSphere = contact.nodeB.physicsBody!.categoryBitMask == CollisionCategory.sphere.rawValue
        let isBTrigger = contact.nodeB.physicsBody!.categoryBitMask == CollisionCategory.triggerBlock.rawValue
        let isBTorus = contact.nodeB.physicsBody!.categoryBitMask == CollisionCategory.torus.rawValue
        
        if (isASphere && isBTrigger) || (isATrigger && isBSphere) {
            if (!triggered) {
                triggered = true
                
                let moveDown = SCNAction.move(by: SCNVector3(stopper.position.x, -0.5, stopper.position.z), duration: 1)
                moveDown.timingMode = .easeInEaseOut
                stopper.runAction(moveDown)
            }
        }
        
        if (isASphere && isBTorus) || (isATorus && isBSphere) {
            if !triggeredTorus {
                triggeredTorus = true
                
                torusNode.geometry?.firstMaterial?.emission.contents = UIColor.red
            }
        }
    }
    
}
