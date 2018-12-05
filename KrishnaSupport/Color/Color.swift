//
//  Color.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 11/01/18.
//  Copyright © 2018 Harish. All rights reserved.
//
import UIKit
class Color1: UIColor {
}
public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }
    public class func hexColor(_ rgb: UInt32, alpha: Double=1.0) -> UIColor {
        let red = CGFloat((rgb & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgb & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgb & 0xFF)/256.0
            return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}
