//
//  BallView.swift
//  BreakItOut
//
//  Created by Guy Taieb on 20/03/2017.
//  Copyright © 2017 Guy Taieb. All rights reserved.
//

import UIKit

class BallView: BezierPathsCreatorView {
    
    var ballNumber = 0
            
    private var ballSize: CGSize {
        let ballSize = CGSize(width: bounds.size.width - lineWidth, height: bounds.size.height - lineWidth)
        return ballSize
    }
    
    var gameView: BreakItView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = frame.width / 2
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collisionBoundingPath: UIBezierPath {
        let radius = bounds.width / 2
        
        return UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: 0.0, endAngle: CGFloat.pi * 2, clockwise: false)
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .path
    }
    
    
    private struct BallAnimationConstants {
        static let AnimationDuration = 0.8
        static let DestroyedDuration = 0.1
    }
    
    var _ballFellThrough: Bool = false { didSet { setNeedsDisplay() } }
    
    var ballFellThroughTheGround: Bool {
        get {
            return _ballFellThrough
        }
        set {
            UIView.transition(with: self, duration: BallAnimationConstants.DestroyedDuration, options: [], animations: {
                self._ballFellThrough = newValue
                self.backgroundColor = UIColor.red
                self.alpha = 0
            }) { (finished) in
                UIView.transition(with: self, duration: BallAnimationConstants.DestroyedDuration, options: [], animations: {
                    self.alpha = 0.5
                }, completion: { (finished) in
                    UIView.transition(with: self, duration: BallAnimationConstants.DestroyedDuration, options: [], animations: {
                        self.alpha = 0
                    }, completion: { (finished) in
                        UIView.transition(with: self, duration: BallAnimationConstants.DestroyedDuration, options: [], animations: {
                            self.alpha = 0.5
                        }, completion: { (finished) in
                            UIView.transition(with: self, duration: BallAnimationConstants.DestroyedDuration, options: [], animations: {
                                self.alpha = 0
                            }, completion: { (finished) in
                                self.gameView?.removeBallFromGame(ball: self)
                            })
                        })
                    })
                })
            }
        }
    }
    
    var _ballNeedsToGo: Bool = false { didSet { setNeedsDisplay() } }
    
    var ballNeedsToGo: Bool {
        get {
            return _ballNeedsToGo
        }
        set {
            UIView.transition(with: self, duration: BallAnimationConstants.AnimationDuration, options: [], animations: {
                self._ballNeedsToGo = newValue
                self.alpha = 0
            }, completion: { (finished) in
                self.gameView?.levelClear = true
                self.gameView?.removeBallFromGame(ball: self)
            })
        }
    }
    
    func removeBallFromLevel() {
        UIView.transition(with: self, duration: BallAnimationConstants.AnimationDuration, options: [], animations: {
            self.alpha = 0
        }) { (finished) in
            self.gameView?.removeBallFromGame(ball: self)
           
        }
    }
    
    var ballPath: UIBezierPath {
        let ballPath = UIBezierPath(ovalIn: CGRect(center: bounds.mid, size: ballSize))
        return ballPath
    }
    
}
