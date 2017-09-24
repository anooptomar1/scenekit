//
//  PianoScene.swift
//  Piano
//
//  Created by Ibram Uppal on 4/3/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class PianoScene: SCNScene {
    
    let keysAttach = SCNNode()
    
    override init() {
        super.init()
        
        setupCameraAndLights()
        //THIS IS WHERE YOU HANDLE PIANO SETUP
        //////////////////////////////////////
        
        let pianoScene = SCNScene(named: "art.scnassets/PianoKeys.dae")
        let whitePianoKey = pianoScene?.rootNode.childNode(withName: "WhiteKey", recursively: true)
        let blackPianoKey = pianoScene?.rootNode.childNode(withName: "BlackKey", recursively: true)
        
        keysAttach.position = SCNVector3(-0.15, 0, 0)
        keysAttach.rotation = SCNVector4(1, 0, 0, -2.4)
        let keyScaling: Float = 0.75
        keysAttach.scale = SCNVector3(keyScaling, keyScaling, keyScaling)
        
        rootNode.addChildNode(keysAttach)
        
        let whiteKeyArray = [
            "C", "D", "E", "F", "G", "A", "B", "CHi"
        ]
        let blackKeys = [
            "CSharp",
            "GSharp",
            "FSharp",
            "DSharp",
            "ASharp"
        ]
        let materialWhite = SCNMaterial()
        materialWhite.diffuse.contents = UIColor(white: 0.8, alpha: 1)
        materialWhite.specular.contents = UIColor.white
        materialWhite.emission.contents = UIColor.black
        
        let materialBlack = SCNMaterial()
        materialBlack.diffuse.contents = UIColor(white: 0.1, alpha: 1)
        materialBlack.specular.contents = UIColor.white
        materialBlack.emission.contents = UIColor.black
        
        for index in 0..<whiteKeyArray.count {
            let pianoKey = whitePianoKey?.clone()
            pianoKey?.geometry = whitePianoKey?.geometry?.copy() as? SCNGeometry
            pianoKey?.name = whiteKeyArray[index]
            let xPos = -2.0 + (0.65  * Double(index))
            pianoKey?.position = SCNVector3(xPos, 0, 0)
            
            
            pianoKey?.geometry?.firstMaterial = materialWhite
            
            keysAttach.addChildNode(pianoKey!)
        }
        
        for index in 0..<blackKeys.count {
            let moveFactor = index < 2 ? -1.7 : -1.05
            let xpos = moveFactor + (0.65 * Double(index))
            
            let key = blackPianoKey?.clone()
            key?.geometry = blackPianoKey?.geometry?.copy() as? SCNGeometry
            key?.name = blackKeys[index]
            key?.position = SCNVector3(xpos, -0.4, 0.7)
            
            key?.geometry?.firstMaterial = materialBlack
            
            keysAttach.addChildNode(key!)
        }
        
    }
    
    func setupCameraAndLights() {
        
        let emptyZero = SCNNode()
        emptyZero.position = SCNVector3Zero
        rootNode.addChildNode(emptyZero)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = true
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        
        let spotLight = SCNNode()
        spotLight.light = SCNLight()
        spotLight.light!.type = .spot
        spotLight.light!.castsShadow = true
        spotLight.light!.shadowSampleCount = 8
        spotLight.light!.attenuationStartDistance = 0.0
        spotLight.light!.attenuationFalloffExponent = 2.0
        spotLight.light!.attenuationEndDistance = 60.0
        spotLight.light!.color = UIColor(white: 1, alpha: 1)
        spotLight.position = SCNVector3(x: 0, y: 0, z: 9)
        
        let ambiLight = SCNNode()
        ambiLight.light = SCNLight()
        ambiLight.light!.type = .ambient
        ambiLight.light!.color = UIColor(white: 0.5, alpha: 1)
        
        cameraNode.constraints = [SCNLookAtConstraint(target: emptyZero)]
        spotLight.constraints = [SCNLookAtConstraint(target: emptyZero)]
        
        rootNode.addChildNode(cameraNode)
        rootNode.addChildNode(spotLight)
        rootNode.addChildNode(ambiLight)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
