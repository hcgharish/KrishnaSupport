//
//  Image.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 11/01/18.
//  Copyright © 2018 Harish. All rights reserved.
//
import UIKit
open class Image: UIImage {
}
public extension UIImage {
    public func resize(_ wth: CGFloat) -> UIImage {
        let scale = wth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: wth,
                                           height: newHeight))
        self.draw(in: CGRect(x: 0,
                             y: 0,
                             width: wth,
                             height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    public func base64 (_ quality: CGFloat) -> String {
        let imageData: NSData = self.pngData()! as NSData
        let bytes = Double(imageData.length)/8.0
        let kbb = bytes/1024.0
        let mbb = kbb/1024.0
        print("imageData size -> KB[\(kbb)],MB[\(mbb)]")
        let profilePicture = imageData.base64EncodedString(options: .lineLength64Characters)
        return profilePicture
    }
}
