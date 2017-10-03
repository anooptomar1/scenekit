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

class BirdScene: SCNScene {

    convenience init(create: Bool) {
        self.init()
        
        setupCameraAndLights()
        
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


