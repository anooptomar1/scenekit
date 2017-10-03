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
    var menuScene: MenuScene?
    
    static var gameOverlay: GameSKOverlay?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = self.view as? SCNView
        
        menuScene = MenuScene(create: true)
        
        GameViewController.gameOverlay = GameSKOverlay(parent: self, size: self.view.frame.size)
        
        if let view = sceneView, let scene = menuScene, let overlay = GameViewController.gameOverlay {
            view.scene = scene
            view.delegate = scene
            view.overlaySKScene = overlay
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
    
    func touchesFunction(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = gameScene {
            if let birdPhysicsBody = scene.emptyBird.physicsBody {
                birdPhysicsBody.velocity = SCNVector3(0,2,0)
            }
            scene.bird.runAction(scene.rotationSequence)
        }
        
        if let touch = touches.first {
            if let name = checkNodeAtPosition(touch: touch) {
                if name == buttonNames.playButton.rawValue {
                    gameScene = BirdScene(create: true)
                    changeScene(newScene: gameScene, newDelegate: gameScene, actionsToCarryOut: {
                        GameViewController.gameOverlay!.addScoreLabel()
                        self.menuScene = nil
                    })
                }
            }
        }
    }
    
    func checkNodeAtPosition(touch: UITouch) -> String? {
        if let skOverlay = GameViewController.gameOverlay {
            let location = touch.location(in: sceneView)
            let nodes = skOverlay.nodes(at: CGPoint(x: location.x, y: self.sceneView!.frame.size.height - location.y))
            if nodes.count > 0 {
                let sprite = nodes[0]
                if let name = sprite.name {
                    return name
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func changeScene(newScene: SCNScene?, newDelegate: SCNSceneRendererDelegate?, actionsToCarryOut:(() -> Void)!) {
        if let view = sceneView, let scene = newScene, let skOverlay = GameViewController.gameOverlay, let delegate = newDelegate {
            skOverlay.removeAllChildren()
            view.scene = scene
            view.delegate = delegate
            
            actionsToCarryOut()
        }
    }

    
    
    
}
