//
//  BezierPathsCreatorView.swift
//  BreakItOut
//
//  Created by Guy Taieb on 20/03/2017.
//  Copyright © 2017 Guy Taieb. All rights reserved.
//

import UIKit

class BezierPathsCreatorView: UIView {
    
    var lineWidth: CGFloat = 1
    
    var bezierPathsDictionary = [String:UIBezierPath]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var gradientLayer = CAGradientLayer()
    
    func setGradientLayerToView(color1: UIColor, color2: UIColor, vertical: Bool) {
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = CGRect(origin: self.bounds.origin, size: CGSize(width: self.bounds.width * 3, height: self.bounds.height))
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    

       override func draw(_ rect: CGRect) {
        for (_, path) in bezierPathsDictionary {
            path.lineWidth = 1
            UIColor.white.setStroke()
            UIColor.white.setFill()
            path.fill()
            path.stroke()
            
            
        }
     
    }
}
