//
//  SettingsViewController.swift
//  BreakItOut
//
//  Created by Guy Taieb on 27/04/2017.
//  Copyright © 2017 Guy Taieb. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var gameView: BreakItView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let segmentdControl = UISegmentedControl(items: [])
        segmentdControl.sizeToFit()
        segmentdControl.center = view.center
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        let vibrencyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrencyEffectView = UIVisualEffectView(effect: vibrencyEffect)
        vibrencyEffectView.frame = view.frame
        vibrencyEffectView.contentView.addSubview(segmentdControl)
        blurEffectView.contentView.addSubview(vibrencyEffectView)
        self.view.insertSubview(blurEffectView, at: 0)
        ballSpeedSlider.value = Float(gameView.gameBoardBehavior.ballSpeedGrowth)
        paddleSizeSlider.value = Float(gameView.paddleGrowth)
        ballSize2.value = Float(gameView.ballGrowth)
        paddleSensitivity.value = Float(gameView.paddleSensitivity)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var ballSize2: UISlider!
    @IBOutlet weak var paddleSensitivity: UISlider!
    @IBOutlet weak var ballSizeSlider: UISlider!
    @IBOutlet weak var paddleSizeSlider: UISlider!
    @IBOutlet weak var ballSpeedSlider: UISlider!
    @IBAction func closeSettings(_ sender: UIButton) {
        
        dismiss(animated: true) {
//            for drop in self.gameView!.dropIndex {
//                self.gameView!.addDropToGravity(drop: drop)
//            }
            self.gameView.paddleSensitivity = CGFloat(self.paddleSensitivity.value)
            self.gameView?.gameBoardBehavior.ballSpeedGrowth = CGFloat(self.ballSpeedSlider.value)
            if self.gameView.paddleGrowth != CGFloat(self.paddleSizeSlider.value) {
                self.gameView.paddleGrowth = CGFloat(self.paddleSizeSlider.value)
            }
            if self.gameView.ballGrowth != CGFloat(self.ballSize2.value) {
                self.gameView.ballGrowth = CGFloat(self.ballSize2.value)
            }
        }
    }
   


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
 

}
