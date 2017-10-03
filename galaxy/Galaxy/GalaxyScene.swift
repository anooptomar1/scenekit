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
        if let sunMat = sun.firstMaterial {
            sunMat.diffuse.contents = sunColor
            sunMat.normal.contents = #imageLiteral(resourceName: "Ground")
            sunMat.specular.contents = UIColor.black
            sunMat.emission.contents = sunColor
        }
        
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
        
        // add particle systems from file for the sun
        if let particleSun = SCNParticleSystem(named: "sunBurst.scnp", inDirectory: "") {
            sunNode.addParticleSystem(particleSun)
        }
        
        
        if let particleStars = SCNParticleSystem(named: "starDust.scnp", inDirectory: "") {
            rootNode.addParticleSystem(particleStars)
        }
        
        let planetX = SCNSphere(radius: 0.2)
        if let matPlanet = planetX.firstMaterial {
            matPlanet.diffuse.contents = UIColor.red
            matPlanet.normal.contents = #imageLiteral(resourceName: "Ground")
            matPlanet.specular.contents = UIColor.white
        }
        
        
        let planetXNode = SCNNode(geometry:planetX)
        let emptyPlanetAttach = SCNNode()
        emptyPlanetAttach.pivot = SCNMatrix4MakeTranslation(0, 0, -2)
        emptyPlanetAttach.addChildNode(planetXNode)
        
        rootNode.addChildNode(emptyPlanetAttach)
        
        emptyPlanetAttach.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(Double.pi * 2), around: SCNVector3(1,1,0), duration: 10)))
        planetXNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(Double.pi * 2), around: SCNVector3(1,1,0), duration: 2)))
        
        let planetXMoon = SCNSphere(radius: 0.05)
        if let matMoon = planetXMoon.firstMaterial {
            matMoon.diffuse.contents = UIColor.white
            matMoon.normal.contents = #imageLiteral(resourceName: "Ground")
            matMoon.specular.contents = UIColor.white
        }
        let moonNode = SCNNode(geometry: planetXMoon)
        moonNode.pivot = SCNMatrix4MakeTranslation(0, 0, -0.25)
        
        emptyPlanetAttach.addChildNode(moonNode)
        moonNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(Double.pi * 2), around: SCNVector3(0,1,0), duration: 1)))
        
        
        // Programatic way to create a particle system
        let myParticleSystem = SCNParticleSystem()
        myParticleSystem.particleImage = #imageLiteral(resourceName: "pixelBlock")
        myParticleSystem.particleSize = 0.005
        myParticleSystem.particleSizeVariation = 0.01
        // default is no angle veriation
        myParticleSystem.particleAngleVariation = 360
        myParticleSystem.particleLifeSpan = 5
        // what shape of the emiiter
        myParticleSystem.emitterShape = SCNSphere(radius: 0.05)
        myParticleSystem.loops = true
        // how fast
        myParticleSystem.birthRate = 300
        myParticleSystem.acceleration = SCNVector3(0,0,0)
        
//        myParticleSystem.isLocal = true
        
        // as if has already been emmiting for x seconds
//        myParticleSystem.warmupDuration = 20
        
        moonNode.addParticleSystem(myParticleSystem)
    }
    
    func setupCameraAndLights() {
    
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = false
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -8)
        
        cameraNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(Double.pi * 2), around: SCNVector3(0,1,0), duration: 10)))
        
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
