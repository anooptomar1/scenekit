//
//  GameViewController.swift
//  Plane
//
//  Created by Ibram Uppal on 11/7/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var sceneView: SCNView?
    let scene = PlaneScene(create: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = self.view as? SCNView
        if let view = sceneView {
            view.scene = scene
            view.delegate = scene
            view.isPlaying = true
            view.backgroundColor = UIColor(red: 0x8b/255.0, green: 0xf0/255.0, blue: 0xff/255.0, alpha: 1)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            view.addGestureRecognizer(tapGesture)
        }
        
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let p = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView!.hitTest(p, options: nil)
        
        if hitResults.count > 0 {
            let results = hitResults[0]
            let node = results.node
            if node.name == "obsticle" {
                // hit some geo
                let scaleAction = SCNAction.scale(by: 2, duration: 0.5)
                scaleAction.timingMode = .easeInEaseOut
                
                let scaleDownAction = scaleAction.reversed()
                let scaleSequence = SCNAction.sequence([scaleAction, scaleDownAction])
                
                node.runAction(scaleSequence)
            }
        }
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
