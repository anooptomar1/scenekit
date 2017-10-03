//
//  GalaxyScene.swift
//  Galaxy
//
//  Created by Ibram Uppal on 4/11/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GalaxyScene: SCNScene {
    
    convenience init(create:Bool) {
        self.init()
        
        setupCameraAndLights()
        
        let sun = SCNSphere(radius: 1)
        let sunColor = UIColor(red: 1, green: 0xd0/255.0, blue: 0x15/255.0, alpha: 1)
        sun.firstMaterial!.diffuse.contents = sunColor
        sun.firstMaterial!.normal.contents = #imageLiteral(resourceName: "Ground")
        sun.firstMaterial!.specular.contents = UIColor.black
        sun.firstMaterial!.emission.contents = sunColor
        
        let sunLight = SCNLight()
        sunLight.type = .omni
        sunLight.attenuationStartDistance = 0
        sunLight.attenuationFalloffExponent = 2
        sunLight.attenuationEndDistance = 20
        
        let sunNode = SCNNode(geometry: sun)
        sunNode.light = sunLight
        // which cat of nodes can be effected by the light
        sunNode.categoryBitMask = 2
        
        rootNode.addChildNode(sunNode)
        
        sunNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(Double.pi * 2), around: SCNVector3(0,1,0), duration: 60)))
        
    }
    
    func setupCameraAndLights() {
    
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = false
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -8)
        
        self.rootNode.addChildNode(cameraNode)
        
        let lightNodeSpot = SCNNode()
        lightNodeSpot.light = SCNLight()
        lightNodeSpot.light!.type = .spot
        lightNodeSpot.position = SCNVector3(x: 30, y: 30, z: 30)
        lightNodeSpot.light!.categoryBitMask = 2
        
        let empty = SCNNode()
        empty.position = SCNVector3(x: 10, y: 4, z: 4)
        self.rootNode.addChildNode(empty)
        
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: empty)]
        cameraNode.addChildNode(lightNodeSpot)
    
    }
    
}
