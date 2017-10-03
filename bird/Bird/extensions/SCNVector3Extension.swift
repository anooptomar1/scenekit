//
//  SCNVector3Extension.swift
//  Bird
//
//  Created by Gareth on 03.10.17.
//  Copyright © 2017 Ibram Uppal. All rights reserved.
//

import SceneKit


extension SCNVector3 {
    init(easyScale: Float) {
        
        self.x = easyScale
        self.y = easyScale
        self.z = easyScale
    }
}
