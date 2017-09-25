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
