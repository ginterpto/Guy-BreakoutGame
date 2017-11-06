//
//  BreakItViewController.swift
//  BreakItOut
//
//  Created by Guy Taieb on 20/03/2017.
//  Copyright © 2017 Guy Taieb. All rights reserved.
//

import UIKit

class BreakItViewController: UIViewController {

    @IBOutlet weak var gameView: BreakItView! {
        didSet {
            gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addAndPushBall(recognizer:))))
            gameView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(movePaddle(recognizer:))))
        }
    }

    private var firstBall: BallView?
    private var myBalls: [BallView] = []
    private var paddle: PaddleView? {
        return gameView.thePaddle
    }
    var paddleMovementSpeed: CGFloat {
        return gameView.paddleSensitivity
    }
    var levelNumber: Int = 1
    var levelIsLoaded = false
    let bricksSpace: CGFloat = 3
    var statusBarIsHidden = true
    
    func movePaddle(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            
            //make sure the paddle stays on screen
            if recognizer.translation(in: paddle).x > 0 && paddle!.center.x < gameView.bounds.maxX {
                paddle?.center.x += recognizer.translation(in: paddle).x * paddleMovementSpeed
                if !gameView.ballIsInTheAir && gameView.balls.count < 2 {
                    firstBall?.center.x += recognizer.translation(in: paddle).x * paddleMovementSpeed
                }
            } else {
                if recognizer.translation(in: paddle).x < 0 && paddle!.center.x > gameView.bounds.minX {
                    paddle?.center.x += recognizer.translation(in: paddle).x * paddleMovementSpeed
                    if !gameView.ballIsInTheAir && gameView.balls.count < 2 {
                        firstBall?.center.x += recognizer.translation(in: paddle).x * paddleMovementSpeed
                    }
                }
            }
            recognizer.setTranslation(CGPoint.zero, in: paddle)
            gameView.updatePaddleLocation()
            gameView.updateBallLocation()
        default:
            break
        }
    }
    
    func addAndPushBall(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if !gameView.ballIsInGame && gameView.balls.count < 1 {
                let ball = gameView.addBallToGame(location: CGPoint(x: paddle!.frame.midX - gameView.bounds.width / 60, y: paddle!.frame.minY - gameView.ballFrameSize.height - 2), autoPush: false)
                gameView.ballEncounters = 0
                gameView.changePushLableColors(pushAvailable: true)
                firstBall = ball
                myBalls.append(ball)
            } else {
                if let ball = gameView.balls.first {
                    if ball.center.x < gameView.bounds.maxX && ball.center.x > gameView.bounds.minX {
                        if !gameView.ballIsInTheAir {
                            gameView.pushBall(ball: ball, direction: "Left")
                            gameView.ballIsInTheAir = true
                            gameView.changePushLableColors(pushAvailable: false)
                        } else if gameView.pushAvailableLabel?.layer.backgroundColor == UIColor.HelpingColors.DarkGreen.cgColor {
                            for ball in gameView.balls {
                                gameView.pushBall(ball: ball, direction: "Random")
                            }
                            gameView.ballEncounters = 0
                            gameView.changePushLableColors(pushAvailable: false)
                        }
                    }
                }
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return statusBarIsHidden
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if gameView.gameScoreLable == nil {
            _ = gameView.addScoreLable()
        }
        if gameView.pushAvailableLabel == nil {
            _ = gameView.addPushLable()
        }
        gameView.animating = true //turning on animation
        if !gameView.paddleIsInTheGame { //spwan the paddle in the gameboard
            _ = gameView.addPaddleToGame()
            if paddle != nil {
                gameView.paddleIsInTheGame = true
            }
        }
        if !levelIsLoaded {
            gameView.loadLevel(levelNumber: levelNumber)
            levelIsLoaded = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Settings" {
            for ball in gameView.balls {
                gameView.stopBall(ball: ball)
            }
            for drop in gameView.dropIndex {
                gameView.removeDrop(drop: drop)
            }
            gameView.changePushLableColors(pushAvailable: true)
            if let vc = segue.destination as? SettingsViewController {
                vc.gameView = self.gameView
                
            }
        }
    }
    
  
    

    
    
    
    

}
