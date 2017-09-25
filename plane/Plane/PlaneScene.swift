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
    // when ws the last frame run and the diff in time
    var timeLast: Double?
    let speedConstant = 1.5
    var planeLocationRotation: Double = 0.0
    
    var obsticles =  Obsticles()
    
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
        
        let rotationAction = SCNAction.rotate(by: CGFloat(Double.pi * 2), around: SCNVector3(0,0,1), duration: 0.3)
        let rotateForever = SCNAction.repeatForever(rotationAction)
        propella?.runAction(rotateForever)
        
        obsticles.spawnObsticle(node: rootNode)
    }
    
    // GAME LOOP
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        // account for diff in time
        var dt: Double
        
        if let lt = timeLast {
            dt = time - lt
        } else {
            dt = 0
        }
        
        timeLast = time
        
        // variable for incrementing in with a factor of speed
        planeLocationRotation += dt * speedConstant
        
        // get the gental effect of plane using triggernomitory
        // we do this using a sign wave to go from one value to another
        // sign in swift works in radions
        
        // get a y
        let yPos = (sin(planeLocationRotation) / 4.0)
        let planeRotation = (cos(planeLocationRotation) / 4.0)
        
        planeAttatch.position = SCNVector3(0, Float(yPos), 0)
        planeAttatch.rotation = SCNVector4(1, 0, 0, Float(planeRotation))
        
        // stop the plane rotation location variable getting to large
        // unnecessarily
        if planeLocationRotation > .pi * 2 {
            planeLocationRotation -= (.pi * 2)
        }
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
