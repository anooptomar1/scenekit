//
//  MonumentScene.swift
//  Monument
//
//  Created by Ibram Uppal on 4/7/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class MonumentScene: SCNScene {
    
    let towerAttach = CustomSCNNode(create: true)
    
    convenience init(create: Bool) {
        self.init()
        
        setupLightsAndCamera()
        
        //RETRIEVE AND ADD NODES HERE
        /////////////////////////////
        
        let towerScene = SCNScene(named: "art.scnassets/Tower.dae")!
        let towerNode = towerScene.rootNode.childNode(withName: "Tower", recursively: true)!
        let menuItemScene = SCNScene(named: "art.scnassets/MenuItems.dae")!
        
        
        for i in 1...10 {
        
            let menuItem1 = menuItemScene.rootNode.childNode(withName: "_\(i)", recursively: true)!
            menuItem1.runAction(SCNAction.scale(by: 0.15, duration: 0))
            menuItem1.rotation = SCNVector4(1,0,0,Float(Double.pi / 2))
            
            let emptyMenuItem = SCNNode()
            emptyMenuItem.name = "MenuItem\(i)"
            emptyMenuItem.addChildNode(menuItem1)
            
            emptyMenuItem.position = SCNVector3(0,-0.3,0)
            emptyMenuItem.pivot = SCNMatrix4MakeTranslation(0, 0, -0.3)
            emptyMenuItem.rotation = SCNVector4(0,1,0, Float((Double.pi / 2) * Double(i - 1)))
            
            if i > 4 {
                emptyMenuItem.isHidden = true
            }
            
            towerAttach.addChildNode(emptyMenuItem)
        
        }
        
        towerAttach.runAction(SCNAction.scale(by: 1.1, duration: 0))
        towerAttach.addChildNode(towerNode)
        
        rootNode.addChildNode(towerAttach)
        animateTower()
        
    }
    
    //ANIMATE SCNTRANSACTION HERE
    /////////////////////////////
    
    func animateTower() {
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 2
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        towerAttach.position = SCNVector3(towerAttach.position.x, towerAttach.position.y + 0.1, towerAttach.position.z)
        
        SCNTransaction.completionBlock = { () -> Void in
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 2
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            self.towerAttach.position = SCNVector3(self.towerAttach.position.x, self.towerAttach.position.y - 0.1, self.towerAttach.position.z)
            
            SCNTransaction.completionBlock = { () -> Void in
                
                self.animateTower()
                
            }
            
            SCNTransaction.commit()
        }
        
        SCNTransaction.commit()
        
    }
    
    func setupLightsAndCamera() {
    
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = true
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -5)
        
        let lightNodeSpot = SCNNode()
        lightNodeSpot.light = SCNLight()
        lightNodeSpot.light!.type = .spot
        lightNodeSpot.light!.attenuationStartDistance = 2.0
        lightNodeSpot.light!.attenuationFalloffExponent = 2
        lightNodeSpot.light!.attenuationEndDistance = 30
        lightNodeSpot.position = SCNVector3(x: 0, y: 2, z: 1)
        
        let emptyAtCenter = SCNNode()
        emptyAtCenter.position = SCNVector3Zero
        rootNode.addChildNode(emptyAtCenter)
        
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
        
        let plane = SCNPlane(width: 4, height: 4)
        plane.firstMaterial!.diffuse.contents = artConstants.returnGradient()
        plane.firstMaterial!.emission.contents = artConstants.returnGradient()
    
        let planeNode = SCNNode(geometry:plane)
        planeNode.position = SCNVector3(x: 0, y: 0, z: -50)
        
        let particleSystem = SCNParticleSystem(named: "Particles.scnp", inDirectory: "")!
        let emptyParticle = SCNNode()
        
        emptyParticle.addParticleSystem(particleSystem)
        particleSystem.warmupDuration = 20.0
        emptyParticle.position = SCNVector3(x: 0, y: -1, z: 0)
        
        rootNode.addChildNode(emptyParticle)
        rootNode.addChildNode(planeNode)
        rootNode.addChildNode(cameraNode)
        rootNode.addChildNode(lightNodeSpot)
    
    }
    
}
