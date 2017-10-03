//
//  GameViewController.swift
//  Drop
//
//  Created by Ibram Uppal on 11/21/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var sceneView: SCNView?
    let scene = DropScene(create: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = self.view as? SCNView
        if let view = sceneView {
            
            view.scene = scene
            view.isPlaying = true
            view.delegate = scene
            view.backgroundColor = UIColor.black
            view.allowsCameraControl = true
            view.antialiasingMode = .multisampling4X
            
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
