//
//  GifLoader.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 31/01/18.
//  Copyright © 2018 Harish. All rights reserved.
//

import UIKit
import ImageIO

private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (lll?, rrr?):
        return lll < rrr
    case (nil, _?):
        return true
    default:
        return false
    }
}
extension UIImage {
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image does not exist")
            return nil
        }
        return UIImage.animatedImageWithSource(source)
    }
    public class func gifImageWithURL(_ gifUrl: String) -> UIImage? {
        guard let bundleURL: URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        return gifImageWithData(imageData)
    }
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        return gifImageWithData(imageData)
    }
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let lll = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, lll), to: CFDictionary.self)
        let ggg = Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()
        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, ggg), to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            let fff = Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, fff), to: AnyObject.self)
        }
        delay = (delayObject as? Double)!
        if delay < 0.1 {
            delay = 0.1
        }
        return delay
    }
    class func gcdForPair(_ aaa: Int?, _ bbb: Int?) -> Int {
        var aaa = aaa
        var bbb = bbb
        if bbb == nil || aaa == nil {
            if bbb != nil {
                return bbb!
            } else if aaa != nil {
                return aaa!
            } else {
                return 0
            }
        }
        if aaa < bbb {
            let ccc = aaa
            aaa = bbb
            bbb = ccc
        }
        var rest: Int
        while true {
            rest = aaa! % bbb!
            if rest == 0 {
                return bbb!
            } else {
                aaa = bbb
                bbb = rest
            }
        }
    }
    class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        var gcd = array[0]
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        return gcd
    }
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        for iii in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, iii, nil) {
                images.append(image)
            }
            let delaySeconds = UIImage.delayForImageAtIndex(Int(iii),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0))
        }
        let duration: Int = {
            var sum = 0
            for val: Int in delays {
                sum += val
            }
            return sum
        }()
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        var frame: UIImage
        var frameCount: Int
        for iii in 0..<count {
            frame = UIImage(cgImage: images[Int(iii)])
            frameCount = Int(delays[Int(iii)] / gcd)
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        return animation
    }
}
