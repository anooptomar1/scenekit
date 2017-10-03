//
//  GameViewController.swift
//  Galaxy
//
//  Created by Ibram Uppal on 11/14/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var scene = GalaxyScene(create: true)
    var sceneView = SCNView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = self.view as! SCNView
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor.black
        
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
