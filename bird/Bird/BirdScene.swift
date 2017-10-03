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


class BirdScene: SCNScene, SCNSceneRendererDelegate {
    
    let emptyGrassOne = SCNNode()
    let emptyGrassTwo = SCNNode()
    var runningUpdate = true
    var timeLast: Double?
    let speedConstant = -0.7

    
    convenience init(create: Bool) {
        self.init()
        
        setupCameraAndLights()
        
        setUpScenery()
        
        addTheGrass()
        
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
    }
    
    func moveGrass(node: SCNNode, dt: Double) {
        node.position.x += Float(dt * speedConstant)
        if node.position.x <= -4.5 {
            node.position.x = 4.5
        }
    }
    
    func addTheGrass() {
        emptyGrassOne.scale = SCNVector3.init(easyScale: 0.15)
        emptyGrassOne.position = SCNVector3(4.5, -1.3, 0)
        
        emptyGrassTwo.scale = SCNVector3.init(easyScale: 0.15)
        emptyGrassTwo.position = SCNVector3(0, -1.3, 0)
        
        if let propsScene = SCNScene(named: "art.scnassets/Props.dae") {
            if let grassOne = propsScene.rootNode.childNode(withName: "Ground", recursively: true) {
                grassOne.position = SCNVector3(-5.0, 0, 0)
                let grassTwo = grassOne.clone()
                grassTwo.position = SCNVector3(-5.0, 0, 0)
                
                emptyGrassOne.addChildNode(grassOne)
                emptyGrassTwo.addChildNode(grassTwo)
                
                rootNode.addChildNode(emptyGrassOne)
                rootNode.addChildNode(emptyGrassTwo)
            }
            
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


