//
//  PlanetScene.swift
//  Planet
//
//  Created by Ibram Uppal on 4/10/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class PlanetScene: SCNScene {
    
    convenience init(create: Bool) {
        self.init()
        
        setupLightsAndCamera()
        
        //ADD CODE AFTER THIS
        /////////////////////
        
        let cloudMat = SCNMaterial()
        cloudMat.transparent.contents = #imageLiteral(resourceName: "Transparent")
        cloudMat.transparencyMode = .rgbZero
        cloudMat.isDoubleSided = true
        let cloudGeo = SCNSphere(radius: 0.53)
        cloudGeo.firstMaterial = cloudMat
        let cloudNode = SCNNode(geometry: cloudGeo)
    
        
        rootNode.addChildNode(cloudNode)
        
        cloudNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(2 * Double.pi), around: SCNVector3(0,1,0), duration: 60)))
        
        let material = SCNMaterial()
        // defuse is color
//        material.diffuse.contents = UIColor.white
        material.diffuse.contents = #imageLiteral(resourceName: "DiffuseSand")
        material.normal.contents = #imageLiteral(resourceName: "NormalMapRough")
        
//        material.normal.contents = #imageLiteral(resourceName: "NormalMapSmooth")
        
        material.reflective.contents = [
            #imageLiteral(resourceName: "Ref3"), #imageLiteral(resourceName: "Ref1"), #imageLiteral(resourceName: "Ref5"), #imageLiteral(resourceName: "Ref6"), #imageLiteral(resourceName: "Ref2"), #imageLiteral(resourceName: "Ref4")
        ]
        
        
        // specular is 'shineyness'
        material.specular.contents = UIColor.black
        
        // emission is a map of the light that is given off even when
        // no light is pointing at the object like street likes on a planet and so on
        material.emission.contents = #imageLiteral(resourceName: "Emission")
        
        // multiply works with diffuse and emission to combine them
//        material.multiply.contents = UIColor.red
        // works with specular, to make more shiny
//        material.shininess = 1
        
        let planetGeo = SCNSphere(radius: 0.5)
        planetGeo.firstMaterial = material
        
        let planetNode = SCNNode(geometry: planetGeo)
        rootNode.addChildNode(planetNode)
        
        planetNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(2 * Double.pi), around: SCNVector3(0,1,0), duration: 20)))
        
        
    }
    
    
    
    func setupLightsAndCamera() {
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = false
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -2)
        
        let lightNodeSpot = SCNNode()
        lightNodeSpot.light = SCNLight()
        lightNodeSpot.light!.type = .spot
        lightNodeSpot.light!.attenuationStartDistance = 2.0
        lightNodeSpot.light!.attenuationFalloffExponent = 2
        lightNodeSpot.light!.attenuationEndDistance = 100
        lightNodeSpot.position = SCNVector3(x: 0, y: 2, z: 1)
        
        let light = SCNLight()
        light.type = .ambient
        
        ///////////////AMBIENT LIGHT COLOR

        light.color = UIColor.black
//        light.color = UIColor.white
        
        //////////////////////////////////
        
        let ambiLight = SCNNode()
        ambiLight.light = light
        ambiLight.position = SCNVector3(x: -2, y: -2, z: 0)
        
        let emptyAtCenter = SCNNode()
        emptyAtCenter.position = SCNVector3(x: 0, y: -1, z: 0.5)
        rootNode.addChildNode(emptyAtCenter)
        
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
        
        rootNode.addChildNode(ambiLight)
        rootNode.addChildNode(cameraNode)
        rootNode.addChildNode(lightNodeSpot)
    }
    
}
