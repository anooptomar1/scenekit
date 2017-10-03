//
//  GameViewController.swift
//  Bird
//
//  Created by Ibram Uppal on 11/21/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    var sceneView: SCNView?
    var gameScene: BirdScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = self.view as? SCNView
        gameScene = BirdScene(create: true)
        
        if let view = sceneView, let scene = gameScene {
            view.scene = scene
            view.delegate = scene
            view.isPlaying = true
            view.backgroundColor = UIColor(red: 0.53, green: 0.99, blue: 1, alpha: 1)
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
