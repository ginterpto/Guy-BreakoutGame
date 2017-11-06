//
//  UIKit Extenssions.swift
//  DropIt
//
//  Created by Guy Taieb on 20/03/2017.
//  Copyright © 2017 Guy Taieb. All rights reserved.
//

import UIKit

extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
        
    }
}

extension UIColor {
     struct HelpingColors {
        static let Bluish = UIColor.hexColor(hexID: 0x84AEFF, a: 1)
        static let NiceGreen = UIColor.hexColor(hexID: 0xB8FFB3, a: 1)
        static let DarkGreen = UIColor.hexColor(hexID: 0x278E2B, a: 0.9)
        static let DarkGray = UIColor.darkGray
        static let FunYellow = UIColor.hexColor(hexID: 0xFFFE6B, a: 1)
        static let Orange = UIColor.hexColor(hexID: 0xF19F57, a: 1)
        static let Purple = UIColor.hexColor(hexID: 0xD78EF1, a: 1)
        static let Red = UIColor.hexColor(hexID: 0xF15455, a: 1)
        static let LightBlue = UIColor.hexColor(hexID: 0xAFDBFF, a: 1)
        static let DarkerGray = UIColor.hexColor(hexID: 0x282828, a: 1)
        static let RGBWhite = UIColor.hexColor(hexID: 0xFFFFFF, a: 1)
        static let LightGray = UIColor.hexColor(hexID: 0xAFAFAF, a: 1)
    }
    
    class func hexColor(hexID: Int, a: CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat((hexID & 0xFF0000)>>16) / 255,
            green: CGFloat((hexID & 0x00FF00)>>8) / 255,
            blue: CGFloat(hexID & 0x0000FF) / 255,
            alpha: a
        )
    }
    
    class var random: UIColor {
        switch arc4random()%6 {
        case 0: return HelpingColors.Bluish
        case 1: return HelpingColors.NiceGreen
        case 2: return HelpingColors.Red
        case 3: return HelpingColors.FunYellow
        case 4: return HelpingColors.Orange
        case 5: return HelpingColors.Purple
        default: return HelpingColors.DarkGray
        }
    }
    
    class var dropsRandom: UIColor {
        switch arc4random()%3{
        case 0: return HelpingColors.Bluish.withAlphaComponent(0.5)
        case 1: return HelpingColors.NiceGreen.withAlphaComponent(0.5)
        case 2: return HelpingColors.Red.withAlphaComponent(0.5)
        default: return HelpingColors.Bluish.withAlphaComponent(0.5)
        }
    }
    
    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        guard let components = self.cgColor.components else { return nil }
        
        return (
            red: components[0],
            green: components[1],
            blue: components[2],
            alpha: components[3]
        )
    }
}

extension CGRect {
    var mid: CGPoint { return CGPoint(x: midX, y: midY) }
    var upperLeft: CGPoint { return CGPoint(x: minX, y: minY) }
    var upperRight: CGPoint { return CGPoint(x: maxX, y: minY) }
    var lowerLeft: CGPoint { return CGPoint (x: minX, y: maxY) }
    var lowerRight: CGPoint { return CGPoint (x: maxX, y: maxY) }
    
    init(center: CGPoint, size: CGSize) {
        let upperLeft = CGPoint(x: center.x-size.width/2, y: center.y-size.height/2)
        self.init(origin: upperLeft, size: size)
    }
}

extension UIView {
    func hitTest(p: CGPoint) -> UIView? {
        return hitTest(p, with: nil)
    }
}

extension UIBezierPath {
    class func lineFrom(from: CGPoint, to: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        return path
        
    }
}










