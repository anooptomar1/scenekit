//
//  GameSKOverlay.swift
//  Bird
//
//  Created by Gareth on 03.10.17.
//  Copyright © 2017 Ibram Uppal. All rights reserved.
//

import UIKit
import SpriteKit

enum buttonNames: String {
    case playButton
}

class GameSKOverlay: SKScene {
    weak var parentView: GameViewController?
    
    var playButtonNode = SKSpriteNode()
    var titleGame = SKSpriteNode()
    var scoreLabel = SKLabelNode(fontNamed: "Arial")
    var scoreNumber = 0
    
    convenience init(parent: GameViewController, size: CGSize) {
        self.init(sceneSize: size)
        
        parentView = parent
        
    }
    
    convenience init(sceneSize: CGSize) {
        self.init(size: sceneSize)
        
        let playTexture = SKTexture(image: #imageLiteral(resourceName: "Play"))
        playButtonNode = SKSpriteNode(texture: playTexture)
        playButtonNode.size = CGSize(width: 100, height: 100)
        playButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playButtonNode.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2 - 200)
        playButtonNode.name = buttonNames.playButton.rawValue
        
        self.addChild(playButtonNode)
        
        let titleTexture = SKTexture(image: #imageLiteral(resourceName: "Title"))
        titleGame = SKSpriteNode(texture: titleTexture)
        titleGame.size = CGSize(width: 300, height: 300)
        titleGame.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2 + 180)
        
        self.addChild(titleGame)
        
        scoreLabel.text = "0"
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: self.size.width / 2.0, y: self.size.height - 72)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let pv = parentView {
            pv.touchesFunction(touches, with: event)
        }
    }
    
    func addScoreLabel() {
        scoreNumber = 0
        
        scoreLabel.text = String(scoreNumber)
        self.addChild(scoreLabel)
    }
}
