//
//  Toast.swift
//  Swift3_Http
//
//  Created by Harish on 16/11/17.
//  Copyright © 2017 Harish. All rights reserved.
//

import UIKit

public class Toast: UIView {
    public func show (_ msg: String) {
        DispatchQueue.main.async {
            let app = UIApplication.shared.delegate
            if app?.window != nil {
                if msg.count > 0 {
                    let lbl = UILabel()
                    lbl.frame.size.width = UIScreen.main.bounds.size.width - 40
                    var frameLbl = lbl.frame
                    lbl.frame = frameLbl
                    lbl.textColor = UIColor.white
                    lbl.textAlignment = .center
                    lbl.text = msg
                    lbl.font = UIFont.systemFont(ofSize: 14.0)
                    lbl.numberOfLines = 0
                    lbl.sizeToFit()
                    frameLbl = lbl.frame
                    frameLbl.size.width = frameLbl.size.width// + 20
                    lbl.frame = frameLbl
                    let view = self
                    var frameView = frameLbl
                    frameView.size.width = frameLbl.size.width + 20
                    frameView.size.height = frameLbl.size.height + 20
                    frameView.origin.x = (UIScreen.main.bounds.size.width / 2) - (frameView.size.width / 2)
                    frameView.origin.y = UIScreen.main.bounds.size.height - frameView.size.height - 20
                    view.frame = frameView
                    lbl.center = CGPoint(x: frameView.size.width/2, y: frameView.size.height/2)
                    view.backgroundColor = UIColor.black
                    let window: UIWindow? = (app?.window)!
                    view.layer.masksToBounds = true
                    view.layer.cornerRadius = 10
                    view.addSubview(lbl)
                    window?.addSubview(view)
                    self.remove ()
                }
            }
        }
    }
    func remove () {
        DispatchQueue.global().async {
            sleep(2)
            DispatchQueue.main.async {
                self.removeFromSuperview()
            }
        }
    }
    static let toasts = NSMutableArray()
    static var watcherWorking = false
    public class func toast (_ msg: String) {
        lockQueue.sync {
            toasts.insert(msg, at: 0)
        }
        if watcherWorking == false {
            watcherWorking = true
            watcher ()
        }
    }
    class func watcher () {
        DispatchQueue.global().async {
            while watcherWorking {
                lockQueue.sync {
                    if toasts.count >= 1 {
                        DispatchQueue.main.async {
                            let msg = toasts[toasts.count - 1]
                            let view = Toast()
                            view.show((msg as? String)!)
                            toasts.removeLastObject()
                        }
                    }
                }
                if toasts.count == 0 {
                    watcherWorking = false
                    break
                }
                usleep(useconds_t(2.1 * 1000000))
            }
        }
    }
}

let lockQueue = DispatchQueue.init(label: "com.harish.LockQueue.Toast")
