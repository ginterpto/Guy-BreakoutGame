//
//  PaddleView.swift
//  BreakItOut
//
//  Created by Guy Taieb on 06/04/2017.
//  Copyright © 2017 Guy Taieb. All rights reserved.
//

import UIKit

class PaddleView: BezierPathsCreatorView {
    
    var paddleSize: CGSize {
        let paddleSize = CGSize(width: bounds.size.width, height: bounds.size.height)
        return paddleSize
    }
    
    var paddle: PaddleView {
        return self
    }
    
    var sectionsOrigin: CGPoint {
      return  CGPoint(x: paddle.frame.origin.x, y: paddle.frame.origin.y - 10)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = paddleSize.height/2
    }
    
    private var _collsionType: UIDynamicItemCollisionBoundsType = .ellipse
    
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        get {
            return _collsionType
        }
        set {
            _collsionType = newValue
        }
    }
    
    private var _collisionPath: UIBezierPath {
        let ovalRect = UIBezierPath(ovalIn: CGRect(x: -bounds.size.width / 2.0, y: -bounds.size.height / 2.0, width: bounds.width, height: bounds.height * 2))
        _ = UIBezierPath(roundedRect: CGRect(x: -bounds.size.width / 2.0, y: -bounds.size.height / 2.0, width: bounds.width, height: bounds.height * 5), cornerRadius: bounds.height * 2)
        return ovalRect
    }
    
    override var collisionBoundingPath: UIBezierPath {
        get {
            return _collisionPath
        }
        set {
    
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
