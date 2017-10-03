//
//  HelperStruct.swift
//  Physics
//
//  Created by Ibram Uppal on 4/13/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

struct HelperStruct {
    
    func getWoodBlock(width: CGFloat) -> SCNNode {
        let plankGeo = SCNBox(width: width, height: 0.3, length: 0.3, chamferRadius: 0)
        plankGeo.firstMaterial = getWoodMaterial()
        let planeNode = SCNNode(geometry: plankGeo)
        planeNode.position = SCNVector3Zero
        planeNode.physicsBody = SCNPhysicsBody.kinematic()
        planeNode.physicsBody!.mass = 100
        
        return planeNode
    }
    
    func getFloorMaterial() -> SCNMaterial {
        
        let floorMaterial = SCNMaterial()
        floorMaterial.diffuse.contents = #imageLiteral(resourceName: "WoodPanel")
        floorMaterial.specular.contents = UIColor.white
        return floorMaterial
        
    }
    
    func getCheckerMaterial() -> SCNMaterial {
        
        let checkerMaterial = SCNMaterial()
        checkerMaterial.diffuse.contents = #imageLiteral(resourceName: "Checker")
        checkerMaterial.specular.contents = UIColor.white
        checkerMaterial.emission.contents = #imageLiteral(resourceName: "Checker")
        checkerMaterial.shininess = 20
        return checkerMaterial
        
    }
    
    func getWoodMaterial() -> SCNMaterial {
        let woodMaterial = SCNMaterial()
        woodMaterial.diffuse.contents = #imageLiteral(resourceName: "WoodPanel")
        woodMaterial.specular.contents = UIColor.white
        woodMaterial.normal.contents = #imageLiteral(resourceName: "WoodNormal")
        //woodMaterial.emission.contents = UIImage(named: "WoodPanel")!
        return woodMaterial
    }
    
    
    
    var planeScalar:CGFloat = 3
    
    func getPhysicsPlane() -> SCNGeometry {
        return SCNPlane(width: planeScalar * 2, height: planeScalar * 2)
    }
    
    func getPlanePhysicsBody() -> SCNPhysicsBody {
        let physBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: getPhysicsPlane(), options: nil))
        physBody.mass = 1000
        return physBody
    }
    
    func getSphere(increase: Float) -> SCNNode {
        
        let size = CGFloat(arc4random_uniform(5)) * 0.1
        
        let sphereGeo = SCNSphere(radius: size)
        sphereGeo.firstMaterial = getCheckerMaterial()
        
        let xPosition = (increase * 0.2) + -1.0
        let sphereNode = SCNNode(geometry: sphereGeo)
        sphereNode.position = SCNVector3(x: xPosition, y: 2, z: 0)
        
        sphereNode.physicsBody = SCNPhysicsBody.dynamic()
        
        var mass = CGFloat(arc4random_uniform(10))
        if mass < 5 {
            mass = 5
        }
        
        if let body = sphereNode.physicsBody {
            body.mass = mass
            body.restitution = 0
        }
        
        return sphereNode
        
    }
    
}
