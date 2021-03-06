//
//  BirdScene.swift
//  Bird
//
//  Created by Ibram Uppal on 5/24/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit


class BirdScene: SCNScene, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    
    let emptyGrassOne = SCNNode()
    let emptyGrassTwo = SCNNode()
    var runningUpdate = true
    var timeLast: Double?
    let speedConstant = -0.7
    
    var emptyPipeOne = SCNNode()
    var emptyPipeTwo = SCNNode()
    var emptyPipeThree = SCNNode()
    var emptyPipeFour = SCNNode()
    
    let emptyBird = SCNNode()
    var bird = SCNNode()
    
    var rotationSequence = SCNAction()
    
    enum CollisionCat:Int {
        case bird = 1
        case pipe
        case floor
    }

    
    convenience init(create: Bool) {
        self.init()
        
        // 5 meteres per second
        physicsWorld.gravity = SCNVector3(0, -4.5, 0)
        physicsWorld.contactDelegate = self
        
        setBirdRotationActions()
        
        setupCameraAndLights()
        
        setUpScenery()
        
        addItemsToScene()
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let dt: Double
        
        if runningUpdate {
            if let lt = timeLast {
                dt = time - lt
            } else {
                dt = 0
            }
        } else {
            dt = 0
        }
        
        timeLast = time
        
        moveGrass(node: emptyGrassOne, dt: dt)
        moveGrass(node: emptyGrassTwo, dt: dt)
        
        movePipe(node: emptyPipeOne, dt: dt)
        movePipe(node: emptyPipeTwo, dt: dt)
        movePipe(node: emptyPipeThree, dt: dt)
        movePipe(node: emptyPipeFour, dt: dt)
        
    }
    
    func moveGrass(node: SCNNode, dt: Double) {
        node.position.x += Float(dt * speedConstant)
        if node.position.x <= -4.5 {
            node.position.x = 4.5
        }
    }
    
    func movePipe(node: SCNNode, dt: Double) {
        node.position.x += Float(dt * speedConstant)
        if node.position.x <= -2 {
            node.position.x = 2
            node.position.y = getRandomHeight()
        }
    }
    
    func getRandomHeight() -> Float {
        var newHeight = Float(arc4random_uniform(13))
        // value from 0 to -1.3
        newHeight /= -10.0
        return newHeight
    }
    
    func setBirdRotationActions() {
        let rotationAction = SCNAction.rotate(toAxisAngle: SCNVector4(1,0,0,0.78), duration: 0)
        let rotationActionTwo = SCNAction.rotate(toAxisAngle: SCNVector4(1,0,0,-1.57), duration: 2)
        rotationActionTwo.timingMode = .easeOut
        
        rotationSequence = SCNAction.sequence([rotationAction, rotationActionTwo])
    }
    
    func addItemsToScene() {
        
        if let propsScene = SCNScene(named: "art.scnassets/Props.dae") {
            
            addGrass(usingScene: propsScene)
            
            addPipes(usingScene: propsScene)
            
        }
        
        addBird()
    }
    
    func addBird() {
        if let scene = SCNScene(named: "art.scnassets/FlappyBird.dae") {
            bird = scene.rootNode.childNode(withName: "Bird", recursively: true)!
            emptyBird.addChildNode(bird)
            emptyBird.scale = SCNVector3.init(easyScale: 0.08)
            emptyBird.rotation = SCNVector4(0, 1, 0, -1.57)
            emptyBird.position = SCNVector3(-0.3, 0, 0)
            
            // collistion is easier
            let birdCollide = SCNSphere(radius: 0.05)
            emptyBird.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: birdCollide, options: nil))
            
            if let body = emptyBird.physicsBody {
                body.mass = 5
                body.velocityFactor = SCNVector3(1,1,0)
                body.angularVelocityFactor = SCNVector3Zero
                body.categoryBitMask = CollisionCat.bird.rawValue
                if #available(iOS 9.0, *) {
                    body.contactTestBitMask = CollisionCat.floor.rawValue | CollisionCat.pipe.rawValue
                } else {
                    body.collisionBitMask = CollisionCat.floor.rawValue | CollisionCat.pipe.rawValue
                }
                
            }
            
            rootNode.addChildNode(emptyBird)
        }
    }
    
    func addGrass(usingScene scene: SCNScene) {
        
        emptyGrassOne.scale = SCNVector3.init(easyScale: 0.15)
        emptyGrassOne.position = SCNVector3(4.5, -1.3, 0)
        
        emptyGrassTwo.scale = SCNVector3.init(easyScale: 0.15)
        emptyGrassTwo.position = SCNVector3(0, -1.3, 0)
        
        if let grassOne = scene.rootNode.childNode(withName: "Ground", recursively: true) {
            grassOne.position = SCNVector3(-5.0, 0, 0)
            let grassTwo = grassOne.clone()
            grassTwo.position = SCNVector3(-5.0, 0, 0)
            
            emptyGrassOne.addChildNode(grassOne)
            emptyGrassTwo.addChildNode(grassTwo)
            
            rootNode.addChildNode(emptyGrassOne)
            rootNode.addChildNode(emptyGrassTwo)
        }
    }
    
    func addPipePhysics(toPipe pipe: SCNNode) {
        pipe.physicsBody = SCNPhysicsBody.kinematic()
        
        if let body = pipe.physicsBody {
            body.mass = 1000
            body.categoryBitMask = CollisionCat.pipe.rawValue
            if #available(iOS 9.0, *) {
                body.contactTestBitMask = CollisionCat.bird.rawValue
            } else {
                body.collisionBitMask = CollisionCat.bird.rawValue
            }
        }
    }
    
    func addPipes(usingScene scene: SCNScene) {
        if let pipe = scene.rootNode.childNode(withName: "Pipe", recursively: true) {
            let topPipe = pipe.clone()
            topPipe.rotation = SCNVector4(0,0,1,3.14)
            topPipe.position = SCNVector3(0,13,0)
            
            let emptyPipe = SCNNode()
            emptyPipe.addChildNode(pipe)
            emptyPipe.addChildNode(topPipe)
            
            emptyPipe.scale = SCNVector3.init(easyScale: 0.15)
            
            emptyPipeOne = emptyPipe.clone()
            emptyPipeOne.position = SCNVector3(2, getRandomHeight(), 0)
            addPipePhysics(toPipe: emptyPipeOne)
            
            emptyPipeTwo = emptyPipe.clone()
            emptyPipeTwo.position = SCNVector3(3, getRandomHeight(), 0)
            addPipePhysics(toPipe: emptyPipeTwo)
            
            emptyPipeThree = emptyPipe.clone()
            emptyPipeThree.position = SCNVector3(4, getRandomHeight(), 0)
            addPipePhysics(toPipe: emptyPipeThree)
            
            emptyPipeFour = emptyPipe.clone()
            emptyPipeFour.position = SCNVector3(5, getRandomHeight(), 0)
            addPipePhysics(toPipe: emptyPipeFour)
            
            rootNode.addChildNode(emptyPipeOne)
            rootNode.addChildNode(emptyPipeTwo)
            rootNode.addChildNode(emptyPipeThree)
            rootNode.addChildNode(emptyPipeFour)
        }
    }
    
    func setUpScenery() {
        let blockBottom = SCNBox(width: 4, height: 0.5, length: 0.4, chamferRadius: 0)
        if let boxMat = blockBottom.firstMaterial {
            boxMat.diffuse.contents = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1)
            boxMat.specular.contents = UIColor.black
            boxMat.emission.contents = UIColor(red: 0.58, green: 0.4, blue: 0.125, alpha: 1)
        }
        let bottomNode = SCNNode(geometry: blockBottom)
        let emptySand = SCNNode()
        emptySand.addChildNode(bottomNode)
        emptySand.position.y = -1.63
        rootNode.addChildNode(emptySand)
        
        let collideFloor = SCNNode(geometry: blockBottom)
        collideFloor.opacity = 0
        collideFloor.physicsBody = SCNPhysicsBody.kinematic()
        if let floorBody = collideFloor.physicsBody {
            floorBody.mass = 1000
            floorBody.categoryBitMask = CollisionCat.floor.rawValue
            if #available(iOS 9.0, *) {
                floorBody.contactTestBitMask = CollisionCat.bird.rawValue
            } else {
                floorBody.collisionBitMask = CollisionCat.bird.rawValue
            }
        }
        collideFloor.position.y = -1.36
        
        rootNode.addChildNode(collideFloor)
    }
    
    func setupCameraAndLights() {
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = false
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -3)
        
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
        
        let ambiLight = SCNNode()
        ambiLight.light = SCNLight()
        ambiLight.light!.type = .ambient
        ambiLight.light!.color = UIColor(white: 0.05, alpha: 1)
        rootNode.addChildNode(ambiLight)
        
    }


}


