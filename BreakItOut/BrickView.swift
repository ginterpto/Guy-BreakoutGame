//
//  BrickView.swift
//  BreakItOut
//
//  Created by Guy Taieb on 22/03/2017.
//  Copyright © 2017 Guy Taieb. All rights reserved.
//

import UIKit

class BrickView: BezierPathsCreatorView {
    
    var gameView: BreakItView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 3
        alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .path
    }
    
    override var collisionBoundingPath: UIBezierPath {
        return UIBezierPath(roundedRect: CGRect(x: -bounds.size.width / 2.0, y: -bounds.size.height / 2.0, width: bounds.width, height: bounds.height), cornerRadius: 3)
    }
    
    var _brickCreated = false
    
    // animating brick creation
    var brickCreated: Bool {
        get {
           return _brickCreated
        }
        set {
            UIView.transition(with: self, duration: BricksAnimationConstants.AnimationDuration, options: [], animations: {
                self.alpha = 1
            }, completion: nil)
        }
    }
    
    var hardBrick = 0
    
    var _brickDestroyed: Bool = true { didSet { setNeedsDisplay() } }
    
    private struct BricksAnimationConstants {
        static let AnimationDuration = 0.4
    }
    
    var brickDestroyed: Bool {
        get {
            return _brickDestroyed
        }
        set {
            if hardBrick < 1, self.backgroundColor == UIColor.HelpingColors.Red {
                hardBrick += 1
                UIView.transition(with: self, duration: BricksAnimationConstants.AnimationDuration, options: [], animations: {
                    self.alpha = 0.5
                }, completion: nil)
            } else {
                gameView?.takeBrickBehaviorOut(brick: self)
                UIView.transition(with: self, duration: BricksAnimationConstants.AnimationDuration, options: [.transitionFlipFromBottom, .curveEaseIn], animations: {
                    self._brickDestroyed = newValue
                    self.alpha = 0
                    self.frame.size.height = 0
                    _ = self.gameView?.dropItem(brick: self)
                }, completion: { finished in
                    self.removeFromSuperview()
                })
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
//        for (_, path) in bezierPathsDictionary {
//            path.lineWidth = 2
//            UIColor.white.setStroke()
//            path.stroke()
//        }
    }

}
