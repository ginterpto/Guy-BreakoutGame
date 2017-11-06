//
//  BreakItView.swift
//  BreakItOut
//
//  Created by Guy Taieb on 20/03/2017.
//  Copyright © 2017 Guy Taieb. All rights reserved.
//

import UIKit

class BreakItView: BezierPathsCreatorView, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {
    
    
    var gameBoardBehavior = GameBoardBehavior()
    
    let bricksSpace: CGFloat = 1

    private lazy var animator: UIDynamicAnimator = {
       let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()

    var collisionsCountInGame = 0
    var bricksPerRow: CGFloat = 7
    var ballIsInGame: Bool = false
    var paddleIsInTheGame: Bool = false
    var theBall: BallView?
    var balls: [BallView] = []
    var ballsNumbersIngame: [Int] = []
    var thePaddle: PaddleView?
    var paddleSensitivity: CGFloat = 2
    var bricksIndex: [BrickView] = []
    var dropIndex: [UIView] = []
    var gameScore = 0
    var ballEncounters = 0
    var levelNumber = 1
    var _levelClear = false
    var levelClear: Bool {
        get {
            return _levelClear
        }
        set {
            _levelClear = newValue
            loadLevel(levelNumber: levelNumber)
        }
    }
    var _paddleGrowht: CGFloat = 1
    var paddleGrowth: CGFloat {
        get {
            return _paddleGrowht
        }
        set {
            _paddleGrowht = newValue
            resizePaddle()
        }
    }
    var _ballGrowth: CGFloat = 1
    var ballGrowth: CGFloat {
        get {
            return _ballGrowth
        }
        set {
            _ballGrowth = newValue
            for ball in balls {
            resizeBall(ball: ball)
            }
        }
    }
    var ballIsInTheAir = false
    var gameScoreLable: UILabel?
    var pushAvailableLabel: UILabel?


    
    //make sure paddle location is updated in the animator
    func updatePaddleLocation() {
        animator.updateItem(usingCurrentState: thePaddle!)
    }
    
    func updateBallLocation() {
        if let ball = theBall {
        animator.updateItem(usingCurrentState: ball)
        }
    }
    
    private struct BordersNames {
        static let ButtomBorder = "ButtomBorder"
    }
    
    var animating: Bool = false {
        didSet {
            if animating {
                animator.addBehavior(gameBoardBehavior)
                let deathPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: bounds.minX, y: bounds.maxY - 100 + paddleFrameSize.height), size: CGSize(width: bounds.width, height: 30)))
                gameBoardBehavior.collider.translatesReferenceBoundsIntoBoundary = true
                gameBoardBehavior.collider2.translatesReferenceBoundsIntoBoundary = true
                gameBoardBehavior.collider3.translatesReferenceBoundsIntoBoundary = true
                gameBoardBehavior.collider4.translatesReferenceBoundsIntoBoundary = true
                gameBoardBehavior.collider5.translatesReferenceBoundsIntoBoundary = true
                gameBoardBehavior.collider6.translatesReferenceBoundsIntoBoundary = true
                gameBoardBehavior.collider.addBoundary(withIdentifier: BordersNames.ButtomBorder as NSCopying, for: deathPath)
                gameBoardBehavior.collider2.addBoundary(withIdentifier: BordersNames.ButtomBorder as NSCopying, for: deathPath)
                gameBoardBehavior.collider3.addBoundary(withIdentifier: BordersNames.ButtomBorder as NSCopying, for: deathPath)
                gameBoardBehavior.collider4.addBoundary(withIdentifier: BordersNames.ButtomBorder as NSCopying, for: deathPath)
                gameBoardBehavior.collider5.addBoundary(withIdentifier: BordersNames.ButtomBorder as NSCopying, for: deathPath)
                gameBoardBehavior.collider6.addBoundary(withIdentifier: BordersNames.ButtomBorder as NSCopying, for: deathPath)
                gameBoardBehavior.collider.collisionDelegate = self
                gameBoardBehavior.collider2.collisionDelegate = self
                gameBoardBehavior.collider3.collisionDelegate = self
                gameBoardBehavior.collider4.collisionDelegate = self
                gameBoardBehavior.collider5.collisionDelegate = self
                gameBoardBehavior.collider6.collisionDelegate = self
                gameBoardBehavior.dropsCollider.collisionDelegate = self
                backgroundColor = UIColor.HelpingColors.DarkerGray
                self.setGradientLayerToView(color1: UIColor.HelpingColors.DarkGray, color2: UIColor.HelpingColors.DarkerGray, vertical: false)
            } else {
                animator.removeBehavior(gameBoardBehavior)
            }
        }
    }
    
    private struct BallPushDirections {
        static let Right = "Right"
        static let Left = "Left"
        static let Random = "Random"
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        if item1 is BallView || item2 is BallView {
            ballEncounters += 1
            if ballEncounters > 14 {
                changePushLableColors(pushAvailable: true)
            }
            if let brick = item1 as? BrickView {
                brick.brickDestroyed = true
            } else if let brick = item2 as? BrickView {
                brick.brickDestroyed = true
            }
        }
        
        if let drop = item1 as? UIView {
            if dropIndex.contains(drop) {
                dropPerk(drop: drop)
                removeDrop(drop: drop)
            } else if let drop = item2 as? UIView {
                if dropIndex.contains(drop) {
                    dropPerk(drop: drop)
                    removeDrop(drop: drop)
                }
            }
        }
    }
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
//        if item is BallView {
//            let ball = item as! BallView
//            print(gameBoardBehavior.BallBehavior.linearVelocity(for: ball))
//            if gameBoardBehavior.BallBehavior.linearVelocity(for: ball).x < 100 && gameBoardBehavior.BallBehavior.linearVelocity(for: ball).x > -100 {
//                ball.frame.midX < self.frame.midX ? gameBoardBehavior.BallBehavior.addLinearVelocity(CGPoint(x: 100, y: 0), for: ball) : gameBoardBehavior.BallBehavior.addLinearVelocity(CGPoint(x: -100, y: 0), for: ball)
//            } else {
//                if gameBoardBehavior.BallBehavior.linearVelocity(for: ball).y < 100 && gameBoardBehavior.BallBehavior.linearVelocity(for: ball).y > -100 {
//                    gameBoardBehavior.BallBehavior.addLinearVelocity(CGPoint(x: 0, y: 100), for: ball)
//                }
//            }
//        }
        
        if identifier as? String == BordersNames.ButtomBorder {
            if let ball = item as? BallView {
                stopBall(ball: ball)
                ball.ballFellThroughTheGround = true
                if balls.contains(ball) {
                    let ballToRemove = balls.index(of: ball)
                    balls.remove(at: ballToRemove!)
                }
            }
        } else {
            ballEncounters += 1
            if ballEncounters > 14 {
                changePushLableColors(pushAvailable: true)
            }
        }
    }
    
    var brickFrameSize: CGSize {
        let BricksSpaceCount = bricksPerRow + 1
        let sizeWidth = (bounds.size.width - (bricksSpace * BricksSpaceCount))/bricksPerRow
        let sizeHeight = sizeWidth / 2.5
        return CGSize(width: sizeWidth, height: sizeHeight)
    }
    
    var ballFrameSize: CGSize {
        let size = bounds.size.width / 25 * ballGrowth
        return CGSize(width: size, height: size)
    }
    
    var paddleFrameSize: CGSize {
        let paddleWidth = bounds.size.width / 5 * paddleGrowth
        let paddleHeight = bounds.size.width / 20
        return CGSize(width: paddleWidth, height: paddleHeight)
    }
    
    var gameScoreLableSize: CGSize {
        let width = bounds.size.width / 3
        let height = width / 8
        return CGSize(width: width, height: height)
    }
    
    var perksLableSize: CGSize {
        let width = bounds.size.width / 6 - 10
        return CGSize(width: width, height: width)
    }
    
    // MARK: Add Labels to game
    
    func addScoreLable() -> UILabel {
        let frame = CGRect(origin: CGPoint(x: bounds.maxX - gameScoreLableSize.width, y: bounds.minY ), size: gameScoreLableSize)
        let lable = UILabel(frame: frame)
        gameScoreLable = lable
        gameScoreLable?.textColor = UIColor.white
        gameScoreLable?.textAlignment = .right
        addSubview(gameScoreLable!)
        gameScoreLable?.text = "000"
        return lable
    }
    
    func addPushLable() -> UILabel {
        let frame = CGRect(origin: CGPoint(x: bounds.minX + 10, y: bounds.maxY - 10 -  perksLableSize.height), size: CGSize(width: perksLableSize.width, height: perksLableSize.height))
        let lable = UILabel(frame: frame)
        pushAvailableLabel = lable
        pushAvailableLabel?.textColor = UIColor.white
        pushAvailableLabel?.layer.backgroundColor = UIColor.HelpingColors.DarkGreen.cgColor
        pushAvailableLabel?.textAlignment = .center
        pushAvailableLabel?.clipsToBounds = true
        pushAvailableLabel?.layer.cornerRadius = perksLableSize.width / 2
        addSubview(pushAvailableLabel!)
        pushAvailableLabel?.text = "⇪"
        pushAvailableLabel?.font = pushAvailableLabel?.font.withSize(26)
        return lable
    }
    
    func changePushLableColors(pushAvailable: Bool) {
        let green = UIColor.HelpingColors.DarkGreen.cgColor
        let red = UIColor.HelpingColors.Red.cgColor
        
        if pushAvailable {
            UIView.transition(with: pushAvailableLabel!, duration: 0.4, options: [], animations: {
                self.pushAvailableLabel?.layer.backgroundColor = green
            }, completion: nil)
        } else {
            UIView.transition(with: pushAvailableLabel!, duration: 0.4, options: [], animations: {
                self.pushAvailableLabel?.layer.backgroundColor = red
            }, completion: { (finished) in
                self.blinkPushLable()
            })
        }
            
    }
    
    func blinkPushLable() {
        UIView.transition(with: pushAvailableLabel!, duration: 0.5, options: [], animations: {
            self.pushAvailableLabel?.alpha = 0.2
        }) { (finished) in
            UIView.transition(with: self.pushAvailableLabel!, duration: 0.5, options: [], animations: {
                self.pushAvailableLabel?.alpha = 1
            }, completion: { (finished) in
                if self.pushAvailableLabel?.layer.backgroundColor == UIColor.HelpingColors.Red.cgColor {
                    self.blinkPushLable()
                }
            })
        }
    }
    
    //MARK: Add game components
    
    func addBricksToGame(origin: CGPoint, withColor color: UIColor) -> BrickView {
        let frame = CGRect(origin: origin, size: brickFrameSize)
        let brick = BrickView(frame: frame)
        brick.backgroundColor = color
        let red = color.colorComponents?.red
        let blue = color.colorComponents?.blue
        let green = color.colorComponents?.green
        let secondColor = UIColor(red: red! + 0.2, green: green! + 0.2, blue: blue! + 0.2, alpha: 1.0)
        brick.brickCreated = true
        brick.setGradientLayerToView(color1: secondColor, color2: color , vertical: false)
        addSubview(brick)
        gameBoardBehavior.addItemCollider(item: brick)
        bricksIndex.append(brick)
        brick.gameView = self
        return brick
    }
    
    func addPaddleToGame() -> PaddleView {
        let paddleSize = paddleFrameSize
        let frame = CGRect(origin: CGPoint(x: bounds.mid.x - paddleSize.width / 2, y: bounds.maxY - 120), size: paddleSize)
        let paddle = PaddleView(frame: frame)
        paddle.backgroundColor = UIColor.white
        let paddleColor = UIColor.HelpingColors.RGBWhite
        let paddleSecondColor = UIColor.HelpingColors.LightGray
        paddle.setGradientLayerToView(color1: paddleColor, color2: paddleSecondColor, vertical: false)
        addSubview(paddle)
        gameBoardBehavior.addItemCollider(item: paddle)
        gameBoardBehavior.addDropCollider(item: paddle)
        fixPaddle(paddle: paddle)
        thePaddle = paddle
        return paddle
    }
    
    func addBallToGame(location: CGPoint, autoPush: Bool) -> BallView {
        let frame = CGRect(origin: location, size: ballFrameSize)
        let ball = BallView(frame: frame)
        ball.gameView = self
        let ballColor = UIColor.HelpingColors.RGBWhite
        let ballSecondColor = UIColor.HelpingColors.LightGray
        ball.setGradientLayerToView(color1: ballColor, color2: ballSecondColor, vertical: false)
        ball.ballNumber = 1
        addSubview(ball)
        gameBoardBehavior.addItemCollider(item: ball)
        ballIsInGame = true
        balls.append(ball)
        theBall = ball
        return ball
    }
    
    func addMoreBallsToGame(location: CGPoint, autoPush: Bool) -> BallView {
        let ball: BallView?
        let frame = CGRect(origin: location, size: ballFrameSize)
        ball = BallView(frame: frame)
        ball?.gameView = self
        let ballColor = UIColor.HelpingColors.RGBWhite
        let ballSecondColor = UIColor.HelpingColors.LightGray
        ball?.setGradientLayerToView(color1: ballColor, color2: ballSecondColor, vertical: false)
        addSubview(ball!)
        ballsNumbersIngame.removeAll()
        for ball in balls {
            let ballNumber = ball.ballNumber
            ballsNumbersIngame.append(ballNumber)
        }
        var ballNumberCanidate = 1
        while ballNumberCanidate <= 6 {
            if !ballsNumbersIngame.contains(ballNumberCanidate) {
                ball?.ballNumber = ballNumberCanidate
                break
            } else {
                ballNumberCanidate += 1
            }
        }
        gameBoardBehavior.addItemCollider(item: ball!)
        ballIsInGame = true
        balls.append(ball!)
        return ball!
    }
    
    func pushBall(ball: BallView, direction: String) {
        gameBoardBehavior.addAndPushBall(item: ball, direction: direction)
    }
    
    // MARK: remove objects from game
    
    func removePaddle(paddle: PaddleView) {
        gameBoardBehavior.removeItemCollider(item: paddle)
        gameBoardBehavior.removeBrickToBrickBehavior(item: paddle)
        gameBoardBehavior.removeDropCollider(item: paddle)
        paddle.removeFromSuperview()
    }
    
    func resizePaddle() {
        UIView.transition(with: thePaddle!, duration: 0.4, options: [], animations: {
            self.thePaddle?.frame.size.width = self.paddleFrameSize.width
        }, completion: nil)
        gameBoardBehavior.removeItemCollider(item: thePaddle!)
        gameBoardBehavior.removeBrickToBrickBehavior(item: thePaddle!)
        gameBoardBehavior.removeDropCollider(item: thePaddle!)
        gameBoardBehavior.addBrickToBrickBehavior(item: thePaddle!)
        gameBoardBehavior.addItemCollider(item: thePaddle!)
        gameBoardBehavior.addDropCollider(item: thePaddle!)
        animator.updateItem(usingCurrentState: thePaddle!)
    }
    
    func resizeBall(ball: BallView) {
        UIView.transition(with: ball, duration: 0.4, options: [], animations: {
//            ball.frame.size.width = self.ballFrameSize.width
//            ball.frame.size.height = self.ballFrameSize.height
            ball.frame.size = self.ballFrameSize
            ball.layer.frame.size = self.ballFrameSize
        }, completion: nil)
        ball.setGradientLayerToView(color1: UIColor.HelpingColors.RGBWhite, color2: UIColor.HelpingColors.LightGray, vertical: false)
        ball.layer.cornerRadius = self.ballFrameSize.width / 2
        gameBoardBehavior.removeItemCollider(item: ball)
        gameBoardBehavior.removeBallFromBehavior(item: ball)
        gameBoardBehavior.addItemCollider(item: ball)
        gameBoardBehavior.addBall(item: ball)
    }
    
    func removeBallFromGame(ball: BallView) {
        gameBoardBehavior.removeItemCollider(item: ball)
        gameBoardBehavior.removeBallFromBehavior(item: ball)
        ball.removeFromSuperview()
        if balls.count < 1 {
            ballIsInGame = false
            ballIsInTheAir = false
        }
        
    }
    
    func stopBall(ball: BallView) {
        let currentVelocity = gameBoardBehavior.BallBehavior.linearVelocity(for: ball)
        gameBoardBehavior.BallBehavior.addLinearVelocity(CGPoint(x: -currentVelocity.x, y: -currentVelocity.y), for: ball)
    }
    
    func fixBrick(brick: BrickView) {
        gameBoardBehavior.addBrickToBrickBehavior(item: brick)
    }
    
    func fixPaddle(paddle: PaddleView) {
        gameBoardBehavior.addBrickToBrickBehavior(item: paddle)
    }

    func takeBrickBehaviorOut(brick: BrickView) {
        gameBoardBehavior.removeBrickToBrickBehavior(item: brick)
        gameBoardBehavior.removeItemCollider(item: brick)
        if let index = bricksIndex.index(of: brick) {
            bricksIndex.remove(at: index)
            if brick.backgroundColor == UIColor.HelpingColors.Red {
                gameScore += 20
                gameScoreLable?.text = String(gameScore)
            } else {
                gameScore += 10
                gameScoreLable?.text = String(gameScore)
            }
        }
        
        if bricksIndex.count == 0 {
            gameScore += 100 * levelNumber
            levelNumber += 1
            let triggerBall = balls.first
            triggerBall?.ballNeedsToGo = true
            for ball in balls {
                stopBall(ball: ball)
                ball.removeBallFromLevel()
            }
            gameScoreLable?.text = String(gameScore)
        }
    }
    
    // MARK: Drops behavior
    
    func dropItem(brick: BrickView) -> UIView? {
        switch arc4random()%6 {
        case 0...1:
            let frame = CGRect(origin: brick.frame.origin, size: brickFrameSize)
        let drop = UIView(frame: frame)
        drop.clipsToBounds = true
        drop.layer.cornerRadius = drop.frame.height / 2
        drop.backgroundColor = UIColor.dropsRandom
        addSubview(drop)
        dropIndex.append(drop)
        gameBoardBehavior.addDropCollider(item: drop)
        gameBoardBehavior.addItemGravity(item: drop)
        return drop
        case 2...5:
            return nil
        default:
            return nil
        }
    }
    
    func removeDropFromGravity(drop: UIView) {
        gameBoardBehavior.removeItemGravity(item: drop)
    }
    
    func addDropToGravity(drop: UIView) {
        gameBoardBehavior.removeItemGravity(item: drop)
    }
    
    func removeDrop(drop: UIView) {
            drop.removeFromSuperview()
            gameBoardBehavior.removeDropCollider(item: drop)
            gameBoardBehavior.removeItemGravity(item: drop)
            let index = dropIndex.index(of: drop)
            dropIndex.remove(at: index!)
    }
    
    func dropPerk(drop: UIView) {
        switch drop.backgroundColor! {
        case UIColor.HelpingColors.Bluish.withAlphaComponent(0.5):
            if ballIsInTheAir {
                for ball in balls {
                    if balls.count < 6 {
                        let addingBall = addMoreBallsToGame(location: ball.frame.origin, autoPush: true)
                        gameBoardBehavior.addBall(item: addingBall)
                        gameBoardBehavior.pushBall(ball: addingBall, direction: "Random")
                    }
                }
            }
        case UIColor.HelpingColors.NiceGreen.withAlphaComponent(0.5):
//            if paddleGrowth <= 1.9 {
//                paddleGrowth += 0.1
//            }
            gameScore += 15
            gameScoreLable?.text = String(gameScore)
        case UIColor.HelpingColors.Red.withAlphaComponent(0.5):
//            if paddleGrowth >= 0.8 {
//                paddleGrowth -= 0.1
//            }
            gameScore -= 20
            gameScoreLable?.text = String(gameScore)
        default: break
        }
    }
    
    func removeBallsAndDrops() {
        for ball in balls {
            ball.removeFromSuperview()
            gameBoardBehavior.removeItemCollider(item: ball)
            balls.removeAll()
        }
        
        for drop in dropIndex {
            drop.removeFromSuperview()
            gameBoardBehavior.removeDropCollider(item: drop)
            dropIndex.removeAll()
        }
    }
    
    
    
    //MARK: Setting Up The Level
    
    
    
    /*create a row based on the asked position on the y axis and with a specific color.
     The row will be created across the screen width based on the brick size.
     this function returns a CGFloat to prepare the next row with*/
    
    let firstLineYPosition: CGFloat = 100 //first line from top, topleft Y position
    
    private func createRow(lineYPosition: CGFloat, withColor color: UIColor) -> CGFloat {
        var totalLineSpaceOcuppide: CGFloat = bricksSpace
        while totalLineSpaceOcuppide < bounds.width {
            let brick = addBricksToGame(origin: CGPoint(x: bounds.upperLeft.x + totalLineSpaceOcuppide, y: bounds.upperLeft.y + lineYPosition), withColor: color)
            fixBrick(brick: brick)
            totalLineSpaceOcuppide += brickFrameSize.width + bricksSpace
        }
        return lineYPosition + brickFrameSize.height + bricksSpace
    }
    
    private func placeRowsOnGameBoard(numberOfRows: Int, firstLinePosition: CGFloat) {
        var rowCount = 0
        var nextRow = createRow(lineYPosition: firstLinePosition, withColor: UIColor.random)
        rowCount += 1
        while rowCount < numberOfRows {
            nextRow = createRow(lineYPosition: nextRow, withColor: UIColor.random)
            rowCount += 1
        }
    }
    
    func loadLevel(levelNumber: Int) {
        removeBallsAndDrops()
        ballEncounters = 0
        changePushLableColors(pushAvailable: true)
        ballIsInTheAir = false
        ballIsInGame = false
        if thePaddle != nil {
            UIView.transition(with: thePaddle!, duration: 0.5, options: [], animations: {
                self.thePaddle!.frame.size = self.paddleFrameSize
            }, completion: nil)
        }
        switch levelNumber {
        case 1: bricksPerRow = 7
                placeRowsOnGameBoard(numberOfRows: 3, firstLinePosition: firstLineYPosition)
        case 2: bricksPerRow = 7
                placeRowsOnGameBoard(numberOfRows: 3, firstLinePosition: firstLineYPosition)
        case 3: bricksPerRow = 7
                placeRowsOnGameBoard(numberOfRows: 3, firstLinePosition: firstLineYPosition)
        case 4: bricksPerRow = 7
                placeRowsOnGameBoard(numberOfRows: 3, firstLinePosition: firstLineYPosition)
        case 5: bricksPerRow = 7
                placeRowsOnGameBoard(numberOfRows: 4, firstLinePosition: firstLineYPosition)
        case 6: bricksPerRow = 7
                placeRowsOnGameBoard(numberOfRows: 4, firstLinePosition: firstLineYPosition)
        case 7: bricksPerRow = 7
                placeRowsOnGameBoard(numberOfRows: 5, firstLinePosition: firstLineYPosition)
        default:    bricksPerRow = 7
                    placeRowsOnGameBoard(numberOfRows: 5, firstLinePosition: firstLineYPosition)
        }
        _levelClear = false
        
    }
    
}












