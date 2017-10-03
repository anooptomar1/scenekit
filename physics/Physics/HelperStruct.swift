//
//  HelperStruct.swift
//  Physics
//
//  Created by Gareth on 03.10.17.
//  Copyright © 2017 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

struct HelperStruct {
    var planeScaler: CGFloat = 3
    
    func getPhysicsPlane() -> SCNGeometry {
        return SCNPlane(width: planeScaler * 2, height: planeScaler * 2)
    }
    
    func getPlanePhysicsBody() -> SCNPhysicsBody {
        let physBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: getPhysicsPlane(), options: nil))
        physBody.mass = 1000
        return physBody
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
        checkerMaterial.shininess = 20
        checkerMaterial.emission.contents = #imageLiteral(resourceName: "Checker")
        return checkerMaterial
    }
    
    func getSphere(increase: Float) -> SCNNode {
        let size = CGFloat(arc4random_uniform(5)) * 0.1
        let sphereGeo = SCNSphere(radius: size)
        sphereGeo.firstMaterial = getCheckerMaterial()
        
        let xpos = (increase * 0.2) + -0.1
        
        let sphereNode = SCNNode(geometry: sphereGeo)
        sphereNode.position = SCNVector3(xpos, 2, 0)
        sphereNode.physicsBody = SCNPhysicsBody.dynamic()
        
        var mass = CGFloat(arc4random_uniform(10))
        if mass < 5 {
            mass = 5
        }
        
        if let body = sphereNode.physicsBody {
            body.mass = mass
            // bouncyness
            body.restitution = 0
        }
        return sphereNode
    }
}
