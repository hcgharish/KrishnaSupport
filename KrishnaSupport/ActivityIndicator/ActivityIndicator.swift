//Harish
//Harish
import Foundation
import UIKit
public class ActivityIndicator {
    var container: UIView?
    var loadingView: UIView?
    var activityIndicator: UIActivityIndicatorView?
    static let shared: ActivityIndicator = { ActivityIndicator () } ()
    weak var appDelegate: UIApplicationDelegate?
    let lockQueue = DispatchQueue.init(label: "com.harish.LockQueue.ActivityIndicator")
    var noofrequest = 0
    func showLoader() {
        DispatchQueue.main.async {
            self.lockQueue.sync {
                if self.noofrequest == 0 {
                    if self.container == nil {
                        self.container = UIView()
                    }
                    if self.loadingView == nil {
                        self.loadingView = UIView()
                    }
                    if self.activityIndicator == nil {
                        self.activityIndicator = UIActivityIndicatorView()
                    }
                    if self.appDelegate == nil {
                        self.appDelegate = UIApplication.shared.delegate
                    }
                    self.container?.frame = (self.appDelegate?.window??.frame)!
                    self.container?.center = (self.appDelegate?.window??.center)!
                    self.container?.backgroundColor = UIColor.hexColor(0xffffff, alpha: 0.3)
                    self.loadingView?.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                    self.loadingView?.center = (self.appDelegate?.window??.center)!
                    self.loadingView?.backgroundColor = UIColor.hexColor(0x444444, alpha: 0.7)
                    self.loadingView?.clipsToBounds = true
                    self.loadingView?.layer.cornerRadius = 10
                    self.activityIndicator?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                    self.activityIndicator?.style = UIActivityIndicatorView.Style.whiteLarge
                    self.activityIndicator?.center = CGPoint(x: (self.loadingView?.frame.size.width)! / 2,
                                                             y: (self.loadingView?.frame.size.height)! / 2)
                    self.loadingView?.addSubview(self.activityIndicator!)
                    self.container?.addSubview(self.loadingView!)
                    self.appDelegate?.window??.addSubview(self.container!)
                    self.activityIndicator?.startAnimating()
                }
                self.noofrequest += 1
            }
        }
    }
    func stopLoader() {
        DispatchQueue.global().async {
            while self.noofrequest == 0 {
                sleep(1)
            }
            DispatchQueue.main.async {
                self.lockQueue.sync {
                    if self.noofrequest == 1 {
                        self.activityIndicator?.stopAnimating()
                        self.container?.removeFromSuperview()
                    }
                    if self.noofrequest > 0 {
                        self.noofrequest -= 1
                    }
                }
            }
        }
    }
}
