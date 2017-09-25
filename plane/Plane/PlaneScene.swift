//
//  PlaneScene.swift
//  Plane
//
//  Created by Ibram Uppal on 4/4/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class PlaneScene: SCNScene, SCNSceneRendererDelegate {
    
    let planeAttatch = SCNNode()
    
    convenience init(create: Bool) {
        self.init()
        
        setupCameraLightsAndExtras()
        
        let planeScene = SCNScene(named: "art.scnassets/SimplePlane.dae")
        
        // get the plane and the propeller
        let plane = planeScene?.rootNode.childNode(withName: "Plane", recursively: true)
        let propella = planeScene?.rootNode.childNode(withName: "Propeller", recursively: true)
        
        plane?.name = "Plane"
        propella?.name = "Propella"
        planeAttatch.name = "Empty"
        
        // empty node to attach
        planeAttatch.addChildNode(plane!)
        planeAttatch.addChildNode(propella!)
        
        
        rootNode.addChildNode(planeAttatch)
    }
    
    func setupCameraLightsAndExtras() {
        
        //CAMERA AND LIGHTS
        ///////////////////
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = false
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -5)
        
        let lightNodeSpot = SCNNode()
        lightNodeSpot.light = SCNLight()
        lightNodeSpot.light!.type = .spot
        lightNodeSpot.position = SCNVector3(x: 30, y: 30, z: 30)
        
        let empty = SCNNode()
        empty.position = SCNVector3Zero
        
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: empty)]
        
        rootNode.addChildNode(empty)
        rootNode.addChildNode(cameraNode)
        rootNode.addChildNode(lightNodeSpot)
        
        //EXTRA NODES
        /////////////
        
        let clouds = SCNParticleSystem(named: "Clouds.scnp", inDirectory: "")!
        let cloudsEmitter = SCNNode()
        cloudsEmitter.position = SCNVector3(x: 0, y: -4, z: -3)
        cloudsEmitter.addParticleSystem(clouds)

        rootNode.addChildNode(cloudsEmitter)
    
    }
    
}
