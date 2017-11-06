//
//  gameBoardBehavior.swift
//  BreakItOut
//
//  Created by Guy Taieb on 21/03/2017.
//  Copyright © 2017 Guy Taieb. All rights reserved.
//

import UIKit

class GameBoardBehavior: UIDynamicBehavior {
    
    let gravity: UIGravityBehavior = {
        let gravity = UIGravityBehavior()
        gravity.magnitude = 0.1
        return gravity
    }()
    
    lazy var  collider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        return collider
    }()
    
    lazy var  collider2: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        return collider
    }()
    
    lazy var  collider3: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        return collider
    }()
    
    lazy var  collider4: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        return collider
    }()
    
    lazy var  collider5: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        return collider
    }()
    
    lazy var  collider6: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        return collider
    }()
    
    lazy var dropsCollider: UICollisionBehavior = {
        let collider = UICollisionBehavior()
        return collider
    }()
    
    let BallBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.elasticity = 1
        behavior.resistance = 0
        behavior.friction = 0
        behavior.allowsRotation = false
        behavior.angularResistance = 0
        return behavior
    
    }()
    
    let BrickBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.elasticity = 1
        behavior.resistance = 0
        behavior.friction = 0
        behavior.allowsRotation = false
        behavior.angularResistance = 0
        behavior.isAnchored = true
        return behavior
        
    }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(collider2)
        addChildBehavior(collider3)
        addChildBehavior(collider4)
        addChildBehavior(collider5)
        addChildBehavior(collider6)
        addChildBehavior(dropsCollider)
        addChildBehavior(BallBehavior)
        addChildBehavior(BrickBehavior)
    }
    
    func addItemCollider(item: UIDynamicItem) {
        if let ball = item as? BallView {
            switch ball.ballNumber {
            case 1: collider.addItem(item)
            case 2: collider2.addItem(item)
            case 3: collider3.addItem(item)
            case 4: collider4.addItem(item)
            case 5: collider5.addItem(item)
            case 6: collider6.addItem(item)
            default: collider.addItem(item)
            }
        } else {
            collider.addItem(item)
            collider2.addItem(item)
            collider3.addItem(item)
            collider4.addItem(item)
            collider5.addItem(item)
            collider6.addItem(item)
        }
    }
    
//    func addItemCollider(item: UIDynamicItem) {
//        collider.addItem(item)
//    }
    
    func addDropCollider(item: UIDynamicItem) {
        dropsCollider.addItem(item)
    }
    
    func addItemGravity(item: UIDynamicItem) {
        gravity.addItem(item)
    }
    
    func removeItemCollider(item: UIDynamicItem) {
        if let ball = item as? BallView {
            switch ball.ballNumber {
            case 1: collider.removeItem(item)
            case 2: collider2.removeItem(item)
            case 3: collider3.removeItem(item)
            case 4: collider4.removeItem(item)
            case 5: collider5.removeItem(item)
            case 6: collider6.removeItem(item)
            default: collider.removeItem(item)
            }
        } else {
            collider.removeItem(item)
            collider2.removeItem(item)
            collider3.removeItem(item)
            collider4.removeItem(item)
            collider5.removeItem(item)
            collider6.removeItem(item)
        }
    }
    
//    func removeItemCollider(item: UIDynamicItem) {
//        collider.removeItem(item)
//    }
    
    func removeItemGravity(item: UIDynamicItem) {
        gravity.removeItem(item)
    }
    
    func removeDropCollider(item: UIDynamicItem) {
        dropsCollider.removeItem(item)
    }
    
    
    // "velocity"  stands for the number of points per second, "xAxisStrenght" stands for the horizontal axis power.
    func pushVelocityAndAngle(velocity: CGFloat, xAxisStrength: CGFloat) -> CGPoint {
        let yAxisTarget = pow(velocity, 2) - pow(xAxisStrength, 2)
        let yAxisStrenght = sqrt(yAxisTarget)
        let point = CGPoint(x: xAxisStrength, y: -yAxisStrenght)
        return point
    }
    
    var ballSpeedGrowth: CGFloat = 1.3
    var ballSpeed: CGFloat = 300
    var ballActualSpeed: CGFloat {
        return ballSpeed * ballSpeedGrowth
    }
    
    var ball: BallView?
    
    func addAndPushBall(item: UIDynamicItem, direction: String) {
        if ball == nil {
            BallBehavior.addItem(item)
            ball = item as? BallView
        }
        //random value for the direction and velocity for the ball.
        var forRandomDirection = UInt32(ballActualSpeed)
        var random: CGPoint {
            switch direction {
            case "Random":
                switch arc4random()%2 {
                case 0: return pushVelocityAndAngle(velocity: ballActualSpeed, xAxisStrength: CGFloat(arc4random()%(forRandomDirection)))
                case 1: return pushVelocityAndAngle(velocity: ballActualSpeed, xAxisStrength: CGFloat(arc4random()%(forRandomDirection))*(-1))
                default: return pushVelocityAndAngle(velocity: ballActualSpeed, xAxisStrength: CGFloat(arc4random()%(forRandomDirection))*(-1))
                }
            case "Right": return pushVelocityAndAngle(velocity: ballActualSpeed, xAxisStrength: CGFloat(ballActualSpeed/2))
            case "Left": return pushVelocityAndAngle(velocity: ballActualSpeed, xAxisStrength: CGFloat(-ballActualSpeed/2))
            default: return pushVelocityAndAngle(velocity: ballActualSpeed, xAxisStrength: CGFloat(arc4random()%(forRandomDirection))*(-1))
            }
        }
        
        
        let currentVelocity = BallBehavior.linearVelocity(for: item)
        
        //kill old velocity
        BallBehavior.addLinearVelocity(CGPoint(x: -currentVelocity.x, y: -currentVelocity.y), for: item)
        
        //push in new direction - mainly upwards for no sudden surprises for the player
        BallBehavior.addLinearVelocity(random, for: item)
    }
    
    func addBall(item: UIDynamicItem) {
        BallBehavior.addItem(item)
    }
    
    func pushBall(ball: UIDynamicItem, direction: String) {
        var forRandomDirection = UInt32(ballSpeed)
        var random: CGPoint {
            switch direction {
            case "Random":
                switch arc4random()%2 {
                case 0: return pushVelocityAndAngle(velocity: ballActualSpeed, xAxisStrength: CGFloat(arc4random()%(forRandomDirection)))
                case 1: return pushVelocityAndAngle(velocity: ballActualSpeed, xAxisStrength: CGFloat(arc4random()%(forRandomDirection))*(-1))
                default: return pushVelocityAndAngle(velocity: ballActualSpeed, xAxisStrength: CGFloat(arc4random()%(forRandomDirection))*(-1))
                }
            default: return pushVelocityAndAngle(velocity: ballActualSpeed, xAxisStrength: CGFloat(arc4random()%(forRandomDirection))*(-1))
            }
        }
        BallBehavior.addLinearVelocity(random, for: ball)
    }
    
  
    
    func removeBallFromBehavior(item: UIDynamicItem) {
        BallBehavior.removeItem(item)
        ball = nil
    }
    
    func addBrickToBrickBehavior(item: UIDynamicItem) {
        BrickBehavior.addItem(item)
        
    }
    
    func removeBrickToBrickBehavior(item: UIDynamicItem) {
        BrickBehavior.removeItem(item)
    }

}
