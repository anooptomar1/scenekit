//
//  GameViewController.swift
//  Piano
//
//  Created by Ibram Uppal on 11/2/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var sceneView: SCNView?
    var scene = PianoScene()
    let player = KeyStroke()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = self.view as? SCNView
        if let view = sceneView {
//            view.allowsCameraControl = true
//            view.showsStatistics = true
            view.scene = scene
            view.backgroundColor = UIColor.gray
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            view.addGestureRecognizer(tapGesture)
            
        }
        
    }
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            let resultNode = result.node! as SCNNode
            if let name = resultNode.name {
                
                let key = scene.keysAttach.childNode(withName: name, recursively: true)!
                
                // get its material
                let material = key.geometry!.firstMaterial!
                player.playKey(keyName: name)
                
                // about to start a animation
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.0
                
                SCNTransaction.completionBlock = {
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 0.5
                    
                    material.emission.contents = UIColor.black
                    
                    key.position = SCNVector3(
                        key.position.x,
                        key.position.y - 0.2,
                        key.position.z
                    )
                    
                    SCNTransaction.commit()
                }
                // set color to red
                material.emission.contents = UIColor.red
                
                // move it down
                key.position = SCNVector3(
                    key.position.x,
                    key.position.y + 0.2,
                    key.position.z
                )
                
                SCNTransaction.commit()
                
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
    
//    override func supportedInterfaceOrientations() ->
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
