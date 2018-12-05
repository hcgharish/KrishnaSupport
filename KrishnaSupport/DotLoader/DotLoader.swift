//
//  DotLoader.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 31/01/18.
//  Copyright © 2018 Harish. All rights reserved.
//
//DotLoader.shared.animateDotLoader = true
import UIKit
let lockQueuee = DispatchQueue.init(label: "com.harish.lock_Queue.dotloader")
let dotSize: CGFloat = 20
var stopped = false
let oneSecond = 1000000
public class DotLoader: NSObject {
    var container: UIView?
    var containerSuper: UIView?
    weak var appDelegate: UIApplicationDelegate?
    public static let shared: DotLoader = { DotLoader () } ()
    var noofrequest = 0
    public var animateDotLoader = false
    public var dotColor = UIColor.white
    public var loaderContainerColor = UIColor.gray
    public var dullnessColor: UIColor?
    public func showLoader () {
        DispatchQueue.main.async {
            lockQueue.sync {
                if self.noofrequest == 0 {
                    stopped = false
                    if self.dullnessColor == nil {
                        self.dullnessColor = UIColor.hexColor(0x000000, alpha: 0.5)
                    }
                    self.appDelegate = UIApplication.shared.delegate
                    self.createContainerView()
                    self.createContainerSuperView()
                    self.containerSuper?.addSubview(self.container!)
                    self.appDelegate?.window??.addSubview(self.containerSuper!)
                    let vieee1 = self.createView()
                    let point = CGPoint(x: (self.container?.frame.size.width)!/2,
                                        y: (self.container?.frame.size.height)!/2)
                    vieee1.center = point
                    self.container?.addSubview(vieee1)
                    vieee1.border5(dotSize / 2)
                    let vieee2 = self.createView()
                    vieee2.center = point
                    self.container?.addSubview(vieee2)
                    vieee2.border5(dotSize / 2)
                    let vieee3 = self.createView()
                    vieee3.center = point
                    self.container?.addSubview(vieee3)
                    vieee3.border5(dotSize / 2)
                    vieee1.frame.origin.x += CGFloat(0.0 * dotSize + 0.0 * 5.0)
                    vieee2.frame.origin.x += CGFloat(1.0 * dotSize + 1.0 * 5.0)
                    vieee3.frame.origin.x += CGFloat(2.0 * dotSize + 2.0 * 5.0)
                    let diff = vieee2.center.x - (vieee2.superview?.frame.size.width)! / 2
                    vieee1.frame.origin.x -= diff
                    vieee2.frame.origin.x -= diff
                    vieee3.frame.origin.x -= diff
                    let sllep: UInt32 = UInt32(oneSecond / 3)
                    DispatchQueue.global().async {
                        vieee1.animate (vieee1.center)
                        usleep(sllep)
                        vieee2.animate (vieee2.center)
                        usleep(sllep)
                        vieee3.animate (vieee3.center)
                    }
                }
                self.noofrequest += 1
            }
        }
    }
    func createContainerView() {
        self.container = UIView()
        self.container?.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        self.container?.frame.size.width = 100.0
        self.container?.frame.size.height = 100.0
        self.container?.center = (self.appDelegate?.window??.center)!
        self.container?.border5(dotSize / 2)
        self.container?.backgroundColor = self.loaderContainerColor
    }
    func createContainerSuperView() {
        self.containerSuper = UIView()
        self.containerSuper?.frame = (self.appDelegate?.window??.frame)!
        self.containerSuper?.center = (self.appDelegate?.window??.center)!
        self.containerSuper?.backgroundColor = self.dullnessColor
    }
    func createView() -> UIView {
        let vieee = UIView()
        var frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        frame.size.width = dotSize
        frame.size.height = dotSize
        vieee.frame = frame
        vieee.backgroundColor = self.dotColor
        return vieee
    }
    public func stopLoader() {
        DispatchQueue.global().async {
            while self.noofrequest == 0 {
                sleep(1)
            }
            DispatchQueue.main.async {
                lockQueue.sync {
                    if self.noofrequest == 1 {
                        stopped = true
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
extension UIView {
    func animate (_ center: CGPoint) {
        DispatchQueue.global().async {
            var incdec: CGFloat = 1
            let time = UInt32(CGFloat(oneSecond)  / dotSize)
            while stopped == false {
                DispatchQueue.main.async {
                    var frame = self.frame
                    if frame.size.width == dotSize && frame.size.height == dotSize {
                        incdec = -1
                    } else if frame.size.width == 0 && frame.size.height == 0 {
                        incdec = 1
                    }
                    frame.size.width += incdec
                    frame.size.height += incdec
                    self.frame = frame
                    self.center = center
                    self.border5(frame.size.height/2)
                }
                usleep(UInt32(time))
            }
        }
    }
    func border5(_ radious: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = radious
        self.layer.borderWidth = 0
    }
}
