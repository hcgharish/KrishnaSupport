//
//  HttpExtension.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 04/10/18.
//  Copyright © 2018 Harish. All rights reserved.
//

import Foundation
import UIKit

public extension Http {
    func printError (_ httpObject: HttpObject) {
        let httpResponse = HttpResponse(nil)
        httpResponse.jsonString = ""
        var prnt = "====================================================================="
        if httpObject.api != nil { prnt += "\n" + "api -\(httpObject.api!)-" }
        if httpObject.params != nil { prnt += "\n" + "params -\(httpObject.params!)-" }
        if httpObject.error != nil { prnt += "\n" + "error-\(httpObject.error)-" }
        if httpObject.data != nil {
            let str = String(describing: NSString(data: httpObject.data, encoding: String.Encoding.utf8.rawValue))
            prnt += "\n" + "data -\(str)-"
            httpResponse.jsonString = NSString(data: httpObject.data,
                                               encoding: String.Encoding.utf8.rawValue)! as String
        }
        if httpObject.response != nil { prnt += "\n" + "response -\(httpObject.response!)-" }
        prnt += "\n" + "====================================================================="
        print(prnt)
        if httpObject.popup {
            self.alert("", kCouldnotconnect)
        }
        if httpObject.aai {
            stopActivityIndicator ()
        }
        httpResponse.params = httpObject.params
        httpResponse.json = nil
        httpResponse.response = httpObject.response as? HTTPURLResponse
        httpObject.completionHandler(httpResponse)
    }
    func printSuccess (_ httpObject: HttpObject) {
        do {
            var parsedData = try JSONSerialization.jsonObject(with: httpObject.data!, options: .allowFragments)
            if let output = parsedData as? NSDictionary {
                let dtt = NSDictionary(dictionary: output)
                parsedData = dtt.getMutable(nil) ?? (Any).self
            } else if let output = parsedData as? NSArray {
                parsedData = output.getMutable(nil) ?? (Any).self
            } else if let output = parsedData as? NSMutableDictionary {
                parsedData = output.getMutable(nil) ?? (Any).self
            } else if let output =  parsedData as? NSMutableArray {
                parsedData = output.getMutable(nil) ?? (Any).self
            }
            let httpResponse = HttpResponse(parsedData)
            httpResponse.jsonString = ""
            if httpObject.prnt {
                var prnt = "====================================================================="
                if httpObject.api != nil { prnt += "\n" + "api -\(httpObject.api!)-" }
                if httpObject.params != nil { prnt += "\n" + "params -\(httpObject.params!)-" }
                if let jsn = try JSONSerialization.jsonObject(with: httpObject.data!,
                                                              options: .allowFragments) as? NSDictionary {
                    prnt += "\n" + "json -\(jsn)-"
                }
                prnt += "\n" + "====================================================================="
                print(prnt)
            }
            if httpObject.data != nil {
                httpResponse.jsonString = NSString(data: httpObject.data,
                                                   encoding: String.Encoding.utf8.rawValue)! as String
            }
            DispatchQueue.main.async {
                httpResponse.params = httpObject.params
                httpResponse.json = parsedData
                httpResponse.response = httpObject.response as? HTTPURLResponse
                httpObject.completionHandler(httpResponse)
            }
        } catch _ as NSError {
            printException(httpObject)
        }
    }
    func printException (_ httpObject: HttpObject) {
        var prnt = "====================================================================="
        if httpObject.api != nil { prnt += "\n" + "api -\(httpObject.api!)-" }
        if httpObject.params != nil { prnt += "\n" + "params -\(httpObject.params!)-" }
        if httpObject.error != nil { prnt += "\n\(httpObject.error)" }
        if httpObject.data != nil {
            let str = String(describing: NSString(data: httpObject.data, encoding: String.Encoding.utf8.rawValue))
            prnt += "\n" + "data -\(str)-"
        }
        if httpObject.response != nil { prnt += "\n" + "response -\(httpObject.response!)-" }
        prnt += "\n" + "====================================================================="
        print(prnt)
        if httpObject.popup {
            self.alert("", kCouldnotconnect)
        }
        if httpObject.aai {
            stopActivityIndicator()
        }
        let httpResponse = HttpResponse(nil)
        httpResponse.params = httpObject.params
        httpResponse.json = nil
        httpResponse.jsonString = ""
        httpResponse.response = httpObject.response as? HTTPURLResponse
        httpObject.completionHandler(httpResponse)
    }
    public class func startActivityIndicator () {
        if GifLoader.shared.animateGifLoader {
            GifLoader.shared.showLoader()
        } else if DotLoader.shared.animateDotLoader {
            DotLoader.shared.showLoader()
        } else {
            ActivityIndicator.shared.showLoader()
        }
    }
    public class func stopActivityIndicator () {
        if GifLoader.shared.animateGifLoader {
            GifLoader.shared.stopLoader()
        } else if DotLoader.shared.animateDotLoader {
            DotLoader.shared.stopLoader()
        } else {
            ActivityIndicator.shared.stopLoader()
        }
    }
    public func startActivityIndicator () {
        DispatchQueue.global().async {
            if GifLoader.shared.animateGifLoader {
                GifLoader.shared.showLoader()
            } else if DotLoader.shared.animateDotLoader {
                DotLoader.shared.showLoader()
            } else {
                ActivityIndicator.shared.showLoader()
            }
        }
    }
    public func stopActivityIndicator () {
        DispatchQueue.global().async {
            if GifLoader.shared.animateGifLoader {
                GifLoader.shared.stopLoader()
            } else if DotLoader.shared.animateDotLoader {
                DotLoader.shared.stopLoader()
            } else {
                ActivityIndicator.shared.stopLoader()
            }
        }
    }
    @objc public class func startActivityIndicatorThread () {
        if GifLoader.shared.animateGifLoader {
            GifLoader.shared.showLoader()
        } else if DotLoader.shared.animateDotLoader {
            DotLoader.shared.showLoader()
        } else {
            ActivityIndicator.shared.showLoader()
        }
    }
    @objc public class func stopActivityIndicatorThread () {
        DispatchQueue.main.async {
            if GifLoader.shared.animateGifLoader {
                GifLoader.shared.stopLoader()
            } else if DotLoader.shared.animateDotLoader {
                DotLoader.shared.stopLoader()
            } else {
                ActivityIndicator.shared.stopLoader()
            }
        }
    }
    public class func alert (_ ttl: String?, _ msg: String?) {
        if msg != nil {
            if (msg?.count)! > 0 {
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate
                    let alertController: UIAlertController
                    var ttl = ttl
                    if ttl == nil {
                        ttl = ""
                    }
                    alertController = UIAlertController(title: ttl, message: msg, preferredStyle: .alert)
                    let defaultActionq = UIAlertAction(title: "Ok", style: .default, handler: { (_ _:UIAlertAction) in
                    })
                    alertController.addAction(defaultActionq)
                    appDelegate?.window??.rootViewController?.present(alertController, animated: true, completion: { })
                }
            }
        }
    }
    public func alert (_ ttl: String?, _ msg: String?) {
        Http.alert(ttl, msg)
    }
    public class func alert (_ ttl: String?, _ msg: String?, _ btns: [Any]) {
        if msg != nil {
            if (msg?.count)! > 0 {
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate
                    let alertController: UIAlertController
                    var ttl = ttl
                    if ttl == nil {
                        ttl = ""
                    }
                    alertController = UIAlertController(title: ttl, message: msg, preferredStyle: .alert)
                    //alertController.alert.title.preferredStyle.
                    if btns.count >= 2 {
                        alertController.addAction(self.alertAction(btns, 0))
                    }
                    if btns.count >= 3 {
                        alertController.addAction(self.alertAction(btns, 1))
                    }
                    appDelegate?.window??.rootViewController?.present(alertController,
                                                                      animated: true, completion: { })
                }
            }
        }
    }
    public class func alertFailed (title: NSString?, _ json: NSDictionary?, _ key: String) {
        let message = (json?[key] as? String?)!
        var title = title
        if title == nil {
            title = ""
        }
        if !(message == "failed." || message == "Validation failed") {
            Http.alert(title as String?, (json?[key] as? String?)!)
        } else {
            if let result = json?["result"] as? NSDictionary {
                var msg = ""
                let arr = result.allKeys
                for iii in 0..<arr.count {
                    let key = arr[iii] as? String
                    if let keyArr = result[key!] as? NSArray {
                        for jjj in 0..<keyArr.count {
                            msg = (keyArr[jjj] as? String)!
                            Http.alert(title as String?, msg)
                        }
                    }
                }
            }
        }
    }
    public class func alertAction (_ btns: [Any], _ index: Int) -> UIAlertAction {
        let action = UIAlertAction(title: (btns[index + 1] as? String)!,
                                   style: .default,
                                   handler: { (_ action: UIAlertAction) in
                                    let vcc = btns[0] as? AlertDelegate
                                    if index == 0 {
                                        vcc?.alertZero()
                                    } else if index == 1 {
                                        vcc?.alertOne()
                                    }
        })
        return action
    }
}
public class HttpObject {
    init(_ completionHandler: @escaping ((HttpResponse?) -> Swift.Void)) {
        self.completionHandler = completionHandler
        data = nil
        response = nil
        error = nil
        api = nil
        params = nil
        aai = false
        popup = false
        prnt = false
    }
    var completionHandler: ((HttpResponse?) -> Swift.Void)
    var data: Data!
    var response: URLResponse!
    var error: Error!
    var api: String!
    var params: NSMutableDictionary!
    var aai: Bool
    var popup: Bool
    var prnt: Bool
}
public class HttpParams {
    init(_ api: String?) {
        self.api = api
        self.params = nil
        self.method = nil
        self.aai = false
        self.popup = false
        self.prnt = false
        self.header = nil
        self.images = nil
        self.sync = false
        self.defaultCalling=false
    }
    var api: String?
    var params: NSMutableDictionary?
    var method: String?
    var aai: Bool
    var popup: Bool
    var prnt: Bool
    var header: NSDictionary?
    var images: NSMutableArray?
    var sync: Bool
    var defaultCalling: Bool
}
public class HttpResponse {
    init(_ json: Any?) {
        self.json = json
        self.params = nil
        self.jsonString = ""
        self.response = nil
    }
    var json: Any?
    var params: NSMutableDictionary?
    var jsonString: String
    var response: HTTPURLResponse?
}
