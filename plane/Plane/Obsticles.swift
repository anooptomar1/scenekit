//
//  Obsticles.swift
//  Plane
//
//  Created by Gareth on 25.09.17.
//  Copyright © 2017 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class Obsticles {
    let purpleObject: SCNNode
    let orangeObject: SCNNode
    let redObject: SCNNode
    
    let moveAction: SCNAction
    
    init() {
        let geometry = SCNScene(named: "art.scnassets/Geometry.dae")
        
        purpleObject = (geometry?.rootNode.childNode(withName: "Purple", recursively: true))!
        orangeObject = (geometry?.rootNode.childNode(withName: "Orange", recursively: true))!
        redObject = (geometry?.rootNode.childNode(withName: "Red", recursively: true))!
        
        moveAction = SCNAction.moveBy(x: 0, y: 0, z: 60, duration: 5)
    }
    
    func spawnObsticle(node: SCNNode) {
        var obsticle: SCNNode
        
        // create reandom position in increments of 2 accross the x axis
        var xPosition: Float = (Float(arc4random_uniform(5)) * -2.0) + 2.0
        if xPosition == 0 {
            xPosition = 2
        }
        
        // do the same for y
        let yPosition: Float = (Float(arc4random_uniform(4)) * -1.0) + 2.0
        
        let vector = SCNVector3(xPosition, yPosition, -50)
        
        switch arc4random_uniform(3) {
        case 0:
            obsticle = purpleObject.clone()
        case 1:
            obsticle = orangeObject.clone()
        case 2:
            obsticle = redObject.clone()
        default:
            obsticle = purpleObject.clone()
        }
        
        obsticle.position = vector
        obsticle.opacity = 0
        obsticle.name = "obsticle"
        
        node.addChildNode(obsticle)
        
        moveObjectPastCam(onNode: obsticle)
    }
    
    func moveObjectPastCam(onNode node: SCNNode) {
        let opactiyAction = SCNAction.fadeOpacity(to: 1, duration: 0.5)
        
        let groupAction = SCNAction.group([moveAction, opactiyAction])
        
        // move the nodes and remove from the screen
        let moveRemoveSequence = SCNAction.sequence([groupAction, SCNAction.removeFromParentNode()])
        
        node.runAction(moveRemoveSequence)
    }
}
