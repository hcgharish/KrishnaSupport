//
//  View.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 11/01/18.
//  Copyright © 2018 Harish. All rights reserved.
//

import UIKit

open class View: UIView, LayoutParameters {
    var classPara: ClassPara = ClassPara()
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
    override open func draw(_ rect: CGRect) {
        if isStrokeColor {
            strokeColor()
        }
    }
    var shadowLayer: CAShapeLayer!
    override open func layoutSubviews() {
        super.layoutSubviews()
        shadowCColor = UIColor.darkGray
        let obb = ClassPara ()
        obb.shadowLayer = shadowLayer
        obb.backgroundColor = backgroundColor
        obb.layer = layer
        classPara = obb
        layoutSubviews (self)
    }
}
public extension UIView {
    public func border (_ color: UIColor?, _ cornerRadius: CGFloat, _ borderWidth: CGFloat) {
        self.layer.masksToBounds = true
        if color != nil {
            self.layer.borderColor = color?.cgColor
        }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    public func shadowSubViews () {
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0
        let borderView = UIView()
        borderView.frame = self.bounds
        borderView.layer.cornerRadius = 10
        borderView.layer.borderColor = UIColor.black.cgColor
        borderView.layer.borderWidth = 1.0
        borderView.layer.masksToBounds = true
        self.addSubview(borderView)
        let otherSubContent = UIImageView()
        otherSubContent.frame = borderView.bounds
        borderView.addSubview(otherSubContent)
    }
    public func shadow () {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = self.frame.size.height/4.0
        self.layer.masksToBounds = false
    }
}
