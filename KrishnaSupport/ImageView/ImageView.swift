//
//  ImageView.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 11/01/18.
//  Copyright © 2018 Harish. All rights reserved.
//
import UIKit
open class ImageView: UIImageView, LayoutParameters {
    var classPara: ClassPara = ClassPara()
    var webView: UIWebView?
    @IBInspectable open var isBorder: Bool = false
    @IBInspectable open var border: Int = 0
    @IBInspectable open var radious: Int = 0
    @IBInspectable open var borderColor: UIColor?
    @IBInspectable open var isShadow: Bool = false
    @IBInspectable open var shadowCColor: UIColor?
    @IBInspectable open var lsOpacity: CGFloat = 0.5
    @IBInspectable open var lsRadius: Int = 0
    @IBInspectable open var lsOffWidth: CGFloat = 2.0
    @IBInspectable open var lsOffHeight: CGFloat = 2.0
    @IBInspectable open var isStrokeColor: Bool = false
    var shadowLayer: CAShapeLayer!
    override open func layoutSubviews() {
        super.layoutSubviews()
        let obb = ClassPara ()
        obb.shadowLayer = shadowLayer
        obb.backgroundColor = backgroundClr
        obb.layer = layer
        classPara = obb
        layoutSubviews (self)
    }
    var url: [String] = []
    @IBInspectable open var willZoom: Bool = false
    @IBInspectable open var backgroundClr: UIColor!
    override open func draw(_ rect: CGRect) {
        backgroundClr = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        setUIImage ()
        if willZoom {
            addClickButton (rect)
        }
        if isStrokeColor {
            strokeColor()
        }
    }
    open func willZoomImage (_ image: UIImage) {
        willZoom = true
        self.image = image
        self.createZoomView(superView)
        if willZoom {
            addClickButton (self.frame)
        }
    }
    var urlImage: String?
    var dImage: String?
    var boolScal: Bool = false
    var aai: UIActivityIndicatorView?
    var superView: UIView?
    public func setImage(_ superView: UIView?,
                         _ urlImage: String?,
                         _ dImage: String?,
                         _ boolScal: Bool,
                         _ aai: UIActivityIndicatorView?) {
        draw (self.frame)
        self.superView = superView
        self.urlImage = urlImage
        self.dImage = dImage
        self.boolScal = boolScal
        self.aai = aai
        setUIImage ()
    }
    public func createZoomView (_ superView: UIView?) {
        if willZoom {
            DispatchQueue.main.async {
                self.superView = superView
                self.addClickButton (self.frame)
            }
        }
    }
    public func setUIImage () {
        if urlImage != nil {
            self.uiimage(urlImage, dImage, boolScal, aai)
        }
    }
    var btnOpen: UIButton?
    public func addClickButton (_ rect: CGRect) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_ :)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc public func imageTapped (_ tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = (tapGestureRecognizer.view as? UIImageView)!
        openZoomView(tappedImage)
    }
    func btnReoveZoomWork () {
        if btnRemoveZoomaContainer == nil {
            let frame = CGRect(x: 0.0, y: 10.0, width: 50, height: 50)
            btnRemoveZoomaContainer = UIButton(frame: frame)
            btnRemoveZoomaContainer?.setTitle("X", for: UIControl.State.normal)
            btnRemoveZoomaContainer?.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            btnRemoveZoomaContainer?.setTitleColor(UIColor.red, for: UIControl.State.normal)
            btnRemoveZoomaContainer?.addTarget(self,
                                               action: #selector(actionRemoveZoomContainer (_ :)),
                                               for: UIControl.Event.touchUpInside)
            viewZoomContainer?.addSubview(btnRemoveZoomaContainer!)
        }
    }
    public func openZoomView (_ sender: Any) {
        if viewZoomContainer == nil {
            viewZoomContainer = UIView()
            viewZoomContainer?.frame = UIScreen.main.bounds
            viewZoomContainer?.isUserInteractionEnabled = true
            viewZoomContainer?.backgroundColor = backgroundClr
            if scZoom == nil {
                scZoom = UIScrollView()
                scZoom?.frame = UIScreen.main.bounds
                scZoom?.isUserInteractionEnabled = true
                viewZoomContainer?.addSubview(scZoom!)
            }
            if imgZoom == nil {
                imgZoom = UIImageView()
                imgZoom?.isUserInteractionEnabled = true
                if scZoom != nil {
                    scZoom?.addSubview(imgZoom!)
                    addPichZoom ()
                }
            }
            btnReoveZoomWork ()
            DispatchQueue.main.async {
                let image = self.image
                if image != nil {
                    self.imgZoom?.image = image
                    let size = getImageSizeByUIScreen((image?.size)!)
                    var frame = self.imgZoom?.frame
                    frame?.origin.x = (self.viewZoomContainer?.frame.size.width)! / 2 - size.width / 2
                    frame?.origin.y = (self.viewZoomContainer?.frame.size.height)! / 2 - size.height / 2
                    frame?.size.width = size.width
                    frame?.size.height = size.height
                    self.imgZoom?.frame = frame!
                    self.frameImage = frame
                }
            }
        } else {
            if frameImage != nil {
                self.imgZoom?.frame = frameImage!
                makeInCenter (true)
            }
        }
        var superView = self.superview
        while true {
            if superView is UIWindow {
                superView?.addSubview(viewZoomContainer!)
                break
            } else {
                superView = superView?.superview
            }
        }
    }
    var frameImage: CGRect?
    @IBOutlet var scZoom: UIScrollView?
    var viewZoomContainer: UIView?
    var imgZoom: UIImageView?
    var viewImgZoomShade: UIView?
    var twoFingerPinch: UIPinchGestureRecognizer?
    var superClass: Any?
    @IBOutlet var btnRemoveZoomaContainer: UIButton?
    @IBAction public func actionRemoveZoomContainer(_ sender: Any) {
        viewZoomContainer?.removeFromSuperview()
    }
    public func addPichZoom () {
        twoFingerPinch = UIPinchGestureRecognizer(target: self,
                                                  action: #selector(self.twoFingerPinch(_ :)))
        imgZoom?.addGestureRecognizer(twoFingerPinch!)
    }
    var maxZoom: CGFloat?
    var maxZoomLevel: CGFloat = 10
    let minZoom: CGFloat = 100.0
    var pointZoomImg: CGPoint?
    var pointZoomSc: CGPoint?
    var frameImgchanged: CGRect?
    var offset: CGPoint?
    @objc public func twoFingerPinch (_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .ended {
            pointZoomImg = nil
            pointZoomSc = nil
            offset = nil
            frameImgchanged = nil
        } else if recognizer.state == .began {
            frameImgchanged = imgZoom?.frame
            pointZoomImg = recognizer.location(in: imgZoom)
            pointZoomSc = recognizer.location(in: scZoom)
            offset = scZoom?.contentOffset
        }
        offset = scZoom?.contentOffset
        if maxZoom == nil {
            if (imgZoom?.frame.size.width)! > (imgZoom?.frame.size.height)! {
                maxZoom = (imgZoom?.frame.size.height)! * maxZoomLevel
            } else {
                maxZoom = (imgZoom?.frame.size.width)! * maxZoomLevel
            }
        }
        let scale: CGFloat = recognizer.scale
        if (imgZoom?.frame.size.width)! < minZoom || (imgZoom?.frame.size.height)! < minZoom {
            if scale > 1.0 {
                imgZoom?.transform = (imgZoom?.transform.scaledBy(x: scale, y: scale))!
                recognizer.scale = 1.0
            }
        } else if (imgZoom?.frame.size.width)! > maxZoom! || (imgZoom?.frame.size.height)! > maxZoom! {
            if scale < 1.0 {
                imgZoom?.transform = (imgZoom?.transform.scaledBy(x: scale, y: scale))!
                recognizer.scale = 1.0
            }
        } else {
            imgZoom?.transform = (imgZoom?.transform.scaledBy(x: scale, y: scale))!
            recognizer.scale = 1.0
        }
        makeInCenter (false)
    }
    func makeInCenter (_ boolCenter: Bool) {
        var width = viewZoomContainer?.frame.size.width
        var height = viewZoomContainer?.frame.size.height
        if (imgZoom?.frame.size.width)! > (viewZoomContainer?.frame.size.width)!
            && (imgZoom?.frame.size.height)! > (viewZoomContainer?.frame.size.height)! {
            width = imgZoom?.frame.size.width
            height = imgZoom?.frame.size.height
        } else if (imgZoom?.frame.size.width)! > (viewZoomContainer?.frame.size.width)! {
            width = imgZoom?.frame.size.width
        } else if (imgZoom?.frame.size.height)! > (viewZoomContainer?.frame.size.height)! {
            height = imgZoom?.frame.size.height
        }
        let cSize = CGSize(width: width!, height: height!)
        scZoom?.contentSize = cSize
        imgZoom?.center = CGPoint(x: (scZoom?.contentSize.width)! / 2,
                                  y: (scZoom?.contentSize.height)! / 2)
        scZoom?.contentOffset = CGPoint(x: (imgZoom?.center.x)! - (scZoom?.frame.size.width)! / 2,
                                        y: (imgZoom?.center.y)! - (scZoom?.frame.size.height)! / 2)
    }
}
