//
//  ImageViewExtension.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 04/10/18.
//  Copyright © 2018 Harish. All rights reserved.
//
import Foundation
import UIKit
public  extension UIImageView {
    public func saveImageDocumentDirectory() {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                         .userDomainMask,
                                                         true)[0] as NSString)
            .appendingPathComponent("apple.jpg")
        let image = UIImage(named: "apple.jpg")
        print(paths)
        let imageData = image!.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: paths as String,
                               contents: imageData,
                               attributes: nil)
    }
    public func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask,
                                                        true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    public func getImage () -> UIImage? {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("apple.jpg")
        if fileManager.fileExists(atPath: imagePAth) {
            return UIImage(contentsOfFile: imagePAth)
        } else {
            return nil
        }
    }
    public func createDirectory() {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                         .userDomainMask,
                                                         true)[0] as NSString).appendingPathComponent("customDirectory")
        if !fileManager.fileExists(atPath: paths) {
            do {
                try fileManager.createDirectory(atPath: paths,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch _ as NSError { }
        } else {
            print("Already dictionary created.")
        }
    }
    public func deleteDirectory() {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                         .userDomainMask,
                                                         true)[0] as NSString)
            .appendingPathComponent("customDirectory")
        if !fileManager.fileExists(atPath: paths) {
            do {
                try fileManager.removeItem(atPath: paths)
            } catch _ as NSError { }
        } else {
            print("Something wronge.")
        }
    }
    public func deleteFileForUrl (_ url: String?) {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(url!.imageName())
        let del: Bool = fileManager.fileExists(atPath: imagePAth)
        if del {
            do {
                try fileManager.removeItem(atPath: imagePAth)
            } catch _ as NSError { }
        } else {
            print("Something wronge.")
        }
    }
    public func savedUIImageForUrl (_ url: String, block: @escaping (UIImage?, Bool) -> Swift.Void) {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(url.imageName())
        if fileManager.fileExists(atPath: imagePAth) {
            block(UIImage(contentsOfFile: imagePAth), false)
        } else {
            var filename = url.imageName()
            filename = filename.replacingOccurrences(of: ".jpg", with: ".svg")
            let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(filename)
            if fileManager.fileExists(atPath: imagePAth) {
                block(nil, true)
            } else {
                block(nil, false)
            }
        }
    }
    public func savedUIImage (_ name: String?,
                              block: @escaping (UIImage?) -> Swift.Void) {
        if name == nil {
            block(nil)
        } else {
            let fileManager = FileManager.default
            let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(name!)
            if fileManager.fileExists(atPath: imagePAth) {
                block(UIImage(contentsOfFile: imagePAth))
            } else {
                block(nil)
            }
        }
    }
    public func saveUIImage (_ name: String?,
                             _ img: UIImage?) {
        if name != nil && img != nil {
            let data: Data? = img!.pngData()!
            if data != nil {
                let fileManager = FileManager.default
                let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                 .userDomainMask,
                                                                 true)[0] as NSString).appendingPathComponent(name!)
                fileManager.createFile(atPath: paths as String,
                                       contents: data,
                                       attributes: nil)
            }
        }
    }
    public func saveUIImageForUrlSVG (_ url: String?, _ data: Data?) {
        if url != nil {
            var filename = url?.imageName()
            filename = filename?.replacingOccurrences(of: ".jpg", with: ".svg")
            if data != nil {
                let fileManager = FileManager.default
                let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                 .userDomainMask,
                                                                 true)[0] as NSString)
                    .appendingPathComponent(filename!)
                fileManager.createFile(atPath: paths as String,
                                       contents: data,
                                       attributes: nil)
            }
        }
    }
    public func saveUIImageForUrl (_ url: String?, _ img: UIImage?) {
        if url != nil && img != nil {
            let data: Data? = img!.pngData()!
            if data != nil {
                let fileManager = FileManager.default
                let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                 .userDomainMask,
                                                                 true)[0] as NSString)
                    .appendingPathComponent(url!.imageName())
                fileManager.createFile(atPath: paths as String,
                                       contents: data,
                                       attributes: nil)
            }
        }
    }
    @objc public func displayImage (_ dict: NSDictionary) {
        DispatchQueue.main.async {
            let boolCustomScale: Bool = (dict["scale"] as? Bool)!
            if boolCustomScale {
                self.clipsToBounds = true
                self.contentMode = .scaleAspectFill
            }
            let url: String = (dict["url"] as? String)!
            let boolSVG = url.subInSensetive(".svg")
            let imgV = self as? ImageView
            if imgV != nil {
                let superView = dict["superView"] as? UIView
                if (imgV?.url.count)! > 0 {
                    if imgV != nil {
                        self.imageLogic1 (dict, boolSVG, url, imgV, superView)
                    } else {
                        self.imageLogic2 (dict, boolSVG, url, imgV, superView)
                    }
                }
            } else {
                self.imageLogic3 (dict, boolSVG, url)
            }
            if let aai = dict["ai"] as? UIActivityIndicatorView {
                aai.isHidden = true
                aai.stopAnimating()
            }
        }
    }
    func imageLogic1 (_ dict: NSDictionary, _ boolSVG: Bool, _ url: String, _ imgV: ImageView?, _ superView: UIView?) {
        let imageUrl = imgV?.url[(imgV?.url.count)!-1]
        if imageUrl != nil {
            if imageUrl! == url {
                if let img = dict["image"] as? UIImage {
                    if boolSVG {
                        self.setSVG(url)
                    } else {
                        self.image = img
                        imgV?.createZoomView(superView)
                    }
                } else if let dimg = dict["dimage"] as? String {
                    if boolSVG {
                        self.setSVG(url)
                    } else {
                        self.image = UIImage(named: dimg)
                    }
                }
            }
        }
    }
    func imageLogic2 (_ dict: NSDictionary, _ boolSVG: Bool, _ url: String, _ imgV: ImageView?, _ superView: UIView?) {
        if let img = dict["image"] as? UIImage {
            if boolSVG {
                self.setSVG(url)
            } else {
                self.image = img
                imgV?.createZoomView(superView)
            }
        } else if let dimg = dict["dimage"] as? String {
            if boolSVG {
                self.setSVG(url)
            } else {
                self.image = UIImage(named: dimg)
            }
        }
    }
    func imageLogic3 (_ dict: NSDictionary, _ boolSVG: Bool, _ url: String) {
        if boolSVG {
            self.setSVG(url)
        } else if let img = dict["image"] as? UIImage {
            self.image = img
        } else if let dimg = dict["dimage"] as? String {
            self.image = UIImage(named: dimg)
        }
    }
    func setSVG (_ url: String) {
        let imgV = self as? ImageView
        if imgV != nil {
            let imageUrl = imgV?.url[(imgV?.url.count)!-1]
            if imageUrl != nil {
                if imageUrl! == url {
                    var filename = url.imageName()
                    filename = filename.replacingOccurrences(of: ".jpg", with: ".svg")
                    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                     .userDomainMask,
                                                                     true)[0] as NSString)
                        .appendingPathComponent(filename)
                    let url1: NSURL = NSURL.fileURL(withPath: paths) as NSURL
                    let request1: URLRequest = URLRequest(url: url1 as URL)
                    if imgV?.webView == nil {
                        imgV?.webView = UIWebView(frame: CGRect(x: 0, y: 0,
                                                                width: self.frame.size.width,
                                                                height: self.frame.size.height))
                        imgV?.webView?.backgroundColor = UIColor.clear
                        imgV?.webView?.isOpaque = false
                        imgV?.webView?.scrollView.bounces = false
                        imgV?.webView?.scrollView.isScrollEnabled = false
                        self.addSubview((imgV?.webView)!)
                    }
                    imgV?.webView?.loadRequest(request1)
                }
            }
        }
    }
    public func downloadUIImage (_ url: String?,
                                 block: @escaping (UIImage?, Bool) -> Swift.Void) {
        let mdd = NSMutableDictionary()
        mdd["url"] = url
        mdd["block"] = block
        self.performSelector(inBackground: #selector(downloadUIImageThread (_ :)), with: mdd)
    }
    @objc public func downloadUIImageThread (_ mdd: NSMutableDictionary) {
        let url: String? = mdd["url"] as? String
        let block = (mdd["block"] as? (UIImage?, Bool) -> Swift.Void)!
        self.savedUIImageForUrl(url!, block: { (img, boolSVG) in
            if img != nil {
                block(img, false)
            } else if boolSVG {
                block(nil, true)
            } else {
                let urlL = URL(string: (url?.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!)!)!
                let data = NSData(contentsOf: urlL as URL) as Data?
                var image: UIImage?
                var boolSVG1 = false
                if data != nil {
                    image = UIImage(data: data! as Data)
                    if image != nil {
                        self.saveUIImageForUrl(url, image)
                    } else {
                        if (url?.subInSensetive(".svg"))! {
                            boolSVG1 = true
                            self.saveUIImageForUrlSVG(url, data)
                        }
                    }
                } else {
                    self.deleteFileForUrl(url)
                }
                if boolSVG1 {
                    block(nil, true)
                } else {
                    block(image, false)
                }
            }
        })
    }
    func defaultImage(_ dImage: String?) -> String? {
        var dImage = dImage
        if dImage == nil {
            dImage = "noimage.jpg"
        } else if dImage?.count == 0 {
            dImage = "noimage.jpg"
        }
        return dImage
    }
    public func uiimage (_ url: String?,
                         _ dImage: String?,
                         _ boolScal: Bool,
                         _ aai: UIActivityIndicatorView?,
                         _ superView: UIView? = nil) {
        if url != nil {
            let dImage = defaultImage(dImage)
            if (url?.count)! > 0 && url != "" {
                savedUIImageForUrl(url!, block: { (image, boolSVG) in
                    if image != nil {
                        self.image = image
                        if superView != nil {
                            let imgV = self as? ImageView
                            if imgV != nil {
                                imgV?.createZoomView(superView)
                            }
                        }
                    } else if boolSVG {
                        if self is ImageView {
                            let iiii = self as? ImageView
                            iiii?.url.append(url!)
                        }
                        self.setSVG (url!)
                    } else {
                        self.image = UIImage()
                        if self is ImageView {
                            let iiii = self as? ImageView
                            iiii?.url.append(url!)
                        }
                        if aai != nil {
                            aai?.isHidden = false
                            aai?.startAnimating()
                        }
                        let url = url?.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                        let dict = NSMutableDictionary()
                        dict["url"] = url
                        dict["scale"] = boolScal
                        if aai != nil {
                            dict["ai"] = aai
                        }
                        dict["dimage"] = dImage
                        if superView != nil {
                            dict["superView"] = superView
                        }
                        self.performSelector(inBackground: #selector(self.getNSetUIImagee(_ :)), with: dict)
                    }
                })
            } else {
                self.image = UIImage(named: dImage!)
                if superView != nil {
                    let imgV = self as? ImageView
                    if imgV != nil {
                        imgV?.createZoomView(superView)
                    }
                }
                if aai != nil {
                    aai?.isHidden = true
                    aai?.stopAnimating()
                }
            }
        }
    }
    @objc public func getNSetUIImagee (_ dict: NSDictionary) {
        let url: String = (dict["url"] as? String)!
        self.downloadUIImage(url) { (image, _) in
            let dtt = NSMutableDictionary()
            for (key, value) in dict {
                dtt[key] = value
            }
            if image != nil {
                dtt["image"] = image
            }
            if let superView = dict["superView"] as? UIView {
                dtt["superView"] = superView
            }
            self.performSelector(inBackground: #selector(self.displayImage(_:)), with: dtt)
        }
    }
}
