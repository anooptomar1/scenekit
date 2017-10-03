//
//  GameViewController.swift
//  Physics
//
//  Created by Ibram Uppal on 11/15/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var sceneView: SCNView?
    let scene = PhysicsScene(create: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = self.view as? SCNView
        if let view = sceneView {
            
            view.scene = scene
            view.isPlaying = true
            view.delegate = scene
            view.backgroundColor = UIColor.black
            
//            view.allowsCameraControl = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            view.addGestureRecognizer(tapGesture)
            
        }
        
    }
    
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        // Force = Mass over Acceleration
        
        for node in scene.rootNode.childNodes {
            if let physBod = node.physicsBody {
                // amount of newtons as a short burst
                physBod.applyForce(SCNVector3(directionOfForce(),directionOfForce(),directionOfForce()), asImpulse: true)
                
            }
        }
    }
    
    func directionOfForce() -> Float {
        
        var forceMagnitude = Float(arc4random_uniform(30))
        
        if arc4random_uniform(2) == 1 {
            forceMagnitude = -forceMagnitude
        }
        return forceMagnitude
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
