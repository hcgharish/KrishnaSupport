//
//  GifLoader.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 31/01/18.
//  Copyright © 2018 Harish. All rights reserved.
//
/*
 //GifLoader.shared.animateGifLoader = true
 
 //GifLoader.shared.dullnessColor = UIColor(red: 0.0,green: 0.0,blue: 1.0,alpha: 0.4)
 //GifLoader.shared.gifSize = CGSize(width:100,height:100)
 //GifLoader.shared.duration = 5.0
 
 //GifLoader.shared.maGif = maGif //[UIImage]
 //GifLoader.shared.gifFilename = "steering_black"
 */
import UIKit
public class GifLoader: NSObject {
    let lockQueue = DispatchQueue.init(label: "com.harish.lock_Queue.gifloader")
    var container: UIView?
    var containerSuper: UIView?
    weak var appDelegate: UIApplicationDelegate?
    public static let shared: GifLoader = { GifLoader () } ()
    var noofrequest = 0
    public var animateGifLoader = false
    public var loaderContainerColor = UIColor.clear
    public var dullnessColor: UIColor?
    public var gifSize: CGSize = CGSize(width: 100, height: 100)
    public var maGif: [UIImage]?
    public var gifFilename: String?
    var gifImage: UIImage?
    var imageView: UIImageView?
    public var duration: Double = 1.0
    public func showLoader () {
        DispatchQueue.main.async {
            self.lockQueue.sync {
                if self.noofrequest == 0 {
                    if self.dullnessColor == nil {
                        self.dullnessColor = UIColor.hexColor(0x000000, alpha: 0.5)
                    }
                    self.appDelegate = UIApplication.shared.delegate
                    self.container = UIView()
                    self.containerSuper = UIView()
                    self.containerSuper?.frame = (self.appDelegate?.window??.frame)!
                    self.containerSuper?.center = (self.appDelegate?.window??.center)!
                    self.containerSuper?.backgroundColor = self.dullnessColor
                    self.container?.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
                    self.container?.frame.size.width = self.gifSize.width
                    self.container?.frame.size.height = self.gifSize.height
                    self.container?.center = (self.appDelegate?.window??.center)!
                    self.container?.border5(dotSize / 2)
                    self.container?.backgroundColor = self.loaderContainerColor
                    if self.gifFilename != nil {
                        self.gifImage = UIImage.gifImageWithName(self.gifFilename!)
                    } else if self.maGif != nil {
                        if self.gifImage == nil {
                            self.gifImage = UIImage.animatedImage(with: self.maGif!, duration: self.duration)
                        }
                    }
                    if self.imageView == nil {
                        let frame = CGRect(x: 0, y: 0, width: self.gifSize.width, height: self.gifSize.height)
                        self.imageView = UIImageView(frame: frame)
                    }
                    if self.imageView != nil {
                        if self.gifImage != nil {
                            self.imageView?.image = self.gifImage
                            self.container?.addSubview(self.imageView!)
                        }
                    }
                    self.containerSuper?.addSubview(self.container!)
                    self.appDelegate?.window??.addSubview(self.containerSuper!)
                }
                self.noofrequest += 1
            }
        }
    }
    public func stopLoader() {
        DispatchQueue.global().async {
            while self.noofrequest == 0 {
                sleep(1)
            }
            DispatchQueue.main.async {
                self.lockQueue.sync {
                    if self.noofrequest == 1 {
                        self.containerSuper?.removeFromSuperview()
                    }
                    if self.noofrequest > 0 {
                        self.noofrequest -= 1
                    }
                }
            }
        }
    }
}
