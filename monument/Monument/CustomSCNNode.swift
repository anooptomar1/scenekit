//
//  CustomSCNNode.swift
//  Monument
//
//  Created by Ibram Uppal on 4/7/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class CustomSCNNode: SCNNode {
    
    //ADD ADDITIONAL PROPERTIES HERE
    ////////////////////////////////
    
    var rotationCurrent:Float = 0.0
    var rotationBounce:Float = 0.0
    var whatMenuSpot:Int = 0
    
    var menuSpotMin:Int {
        return whatMenuSpot + 1
    }
    
    var menuSpotMax:Int {
        return whatMenuSpot + 4
    }
    
    convenience init(create: Bool) {
        self.init()
        
    }

    //ADD ADDITIONAL METHODS HERE
    /////////////////////////////
    
    func realign(angleRatio: Float) {
        
        if (angleRatio > 1) && (whatMenuSpot > 0) {
            
            rotationCurrent += Float(Double.pi / 2)
            rotationBounce = rotationCurrent + 0.05
            whatMenuSpot -= 1
            
        } else if (angleRatio < -1) && (whatMenuSpot < 9) {
            
            rotationCurrent -= Float(Double.pi / 2)
            rotationBounce = rotationCurrent - 0.05
            whatMenuSpot += 1
            
        } else if (angleRatio < 1) && (angleRatio > -1) {
            
            rotationBounce = 0
            
        }
        
        self.removeAllActions()
        
        
        let actionRotate = SCNAction.rotate(toAxisAngle: SCNVector4(0,1,0,rotationCurrent), duration: 0.2)
        actionRotate.timingMode = SCNActionTimingMode.easeInEaseOut
        
        let actionBounce = SCNAction.rotate(toAxisAngle: SCNVector4(0,1,0,rotationBounce), duration: 0.1)
        actionBounce.timingMode = SCNActionTimingMode.easeInEaseOut
        
        
        if (angleRatio > 1) && (whatMenuSpot > 0) || (angleRatio < -1) && (whatMenuSpot < 9) {
            var actionToRun: SCNAction
            
            if (angleRatio > 2) || (angleRatio < -2) {
                actionToRun = actionRotate
            } else {
                actionToRun = SCNAction.sequence([actionRotate, actionBounce, actionRotate])
            }
            
            runAction(actionToRun)
            
        } else {
            runAction(actionRotate)
        }
        
    }
    
    func panBeginMoved(xTranslationToCheckNegative: Float) {
        
        var maxToCheckAgainst: Int
        var minToCheckAgainst: Int
        
        if xTranslationToCheckNegative > 0 {
            maxToCheckAgainst = menuSpotMax - 1
            minToCheckAgainst = menuSpotMin - 1
        } else {
            maxToCheckAgainst = menuSpotMax
            minToCheckAgainst = menuSpotMin
        }
        
        for i in 1...10 {
            
            let nodeGet = self.childNode(withName: "MenuItem\(i)", recursively: true)
            
            if let node = nodeGet {
            
                if i >= minToCheckAgainst  && i <= maxToCheckAgainst {
                    node.isHidden = false
                } else {
                    node.isHidden = true
                }
            
            }
        
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
