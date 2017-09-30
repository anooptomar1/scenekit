//
//  GameViewController.swift
//  Monument
//
//  Created by Ibram Uppal on 11/7/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

let artConstants = ArtConstants()

class GameViewController: UIViewController {
    
    var sceneView: SCNView?
    let scene = MonumentScene(create: true)
    let scene2 = SCNScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = self.view as? SCNView
        
        if let view = sceneView {
            
            view.scene = scene
            view.isPlaying = true
            view.backgroundColor = UIColor.white
            view.antialiasingMode = .multisampling2X
             
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            view.addGestureRecognizer(panGesture)
            view.addGestureRecognizer(tapGesture)
            
        }
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        if let view = sceneView {
            view.scene = scene2
        }
    }
    
    @objc func handlePan(gestureRecognize: UIPanGestureRecognizer) {
        
        let xTranslation = Float(gestureRecognize.translation(in: gestureRecognize.view!).x)
        
        //HANDLE PAN GESTURE HERE
        /////////////////////////
        
        if gestureRecognize.state == UIGestureRecognizerState.began || gestureRecognize.state == UIGestureRecognizerState.changed {
            scene.towerAttach.panBeginMoved(xTranslationToCheckNegative: xTranslation)
        }
        
        var angle:Float = (xTranslation * Float(Double.pi)) / 700.0
        let angleRatio = angle / Float(Double.pi / 4)
        angle += scene.towerAttach.rotationCurrent
        scene.towerAttach.rotation = SCNVector4(0,1,0,angle)
        
        if gestureRecognize.state == UIGestureRecognizerState.ended || gestureRecognize.state == UIGestureRecognizerState.cancelled {
            scene.towerAttach.realign(angleRatio: angleRatio)
        }
    
    }
    
    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
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
