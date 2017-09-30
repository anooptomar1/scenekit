//
//  ArtConstants.swift
//  Monument
//
//  Created by Ibram Uppal on 11/7/15.
//  Copyright © 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import QuartzCore

struct ArtConstants {
    
    let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
    
    func returnGradient() -> UIImage {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor(red: 0, green: 0x95/255.0, blue: 0x9E/255.0, alpha: 1).cgColor, UIColor.black.cgColor]
        gradient.opacity = 0.7
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.9)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: 1000, height: 1000)
        
        tempView.layer.insertSublayer(gradient, at: 0)
        
        return imageWithView()
        
    }
    
    func imageWithView() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(tempView.bounds.size, tempView.isOpaque, 0.0);
        tempView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image!
    }
    
}
