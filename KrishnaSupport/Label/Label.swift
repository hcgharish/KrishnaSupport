//
//  Label.swift
//  HarishFrameworkSwift4
//
//  Created by Harish on 11/01/18.
//  Copyright © 2018 Harish. All rights reserved.
//
import UIKit
protocol LayoutParameters {
    var isBorder: Bool {get set}
    var border: Int {get set}
    var radious: Int {get set}
    var borderColor: UIColor? {get set}
    var isShadow: Bool {get set}
    var shadowCColor: UIColor? {get set}
    var lsOpacity: CGFloat {get set}
    var lsRadius: Int {get set}
    var lsOffWidth: CGFloat {get set}
    var lsOffHeight: CGFloat {get set}
    var isStrokeColor: Bool {get set}
    var classPara: ClassPara {get set}
    var bounds: CGRect {get set}
}
class ClassPara {
    var backgroundColor: UIColor!
    var shadowLayer: CAShapeLayer!
    var layer: CALayer!
}
extension NSObject {
    func strokeColor() {
        let ccc = UIGraphicsGetCurrentContext()
        ccc!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
        ccc!.setStrokeColor(UIColor.red.cgColor)
        ccc!.strokePath()
    }
    func layoutSubviews(_ obb: LayoutParameters) {
        if obb.isShadow {
            if obb.classPara.shadowLayer == nil {
                let color = obb.classPara.backgroundColor
                obb.classPara.backgroundColor = UIColor.clear
                obb.classPara.shadowLayer = CAShapeLayer()
                obb.classPara.shadowLayer.path = UIBezierPath(roundedRect: obb.bounds,
                                                              cornerRadius: CGFloat(obb.radious)).cgPath
                obb.classPara.shadowLayer.fillColor = color?.cgColor
                obb.classPara.shadowLayer.shadowColor = obb.shadowCColor?.cgColor
                obb.classPara.shadowLayer.shadowPath = obb.classPara.shadowLayer.path
                obb.classPara.shadowLayer.shadowOffset = CGSize(width: obb.lsOffWidth,
                                                                height: obb.lsOffHeight)
                obb.classPara.shadowLayer.shadowOpacity = Float(obb.lsOpacity)
                obb.classPara.shadowLayer.shadowRadius = CGFloat(obb.lsRadius)
                obb.classPara.layer.insertSublayer(obb.classPara.shadowLayer, at: 0)
            }
        } else if obb.isBorder {
            doBorder(obb)
        }
    }
    func doBorder (_ obb: LayoutParameters) {
        obb.classPara.layer.masksToBounds = true
        if obb.borderColor != nil { obb.classPara.layer.borderColor = obb.borderColor?.cgColor }
        obb.classPara.layer.cornerRadius = CGFloat(obb.radious)
        obb.classPara.layer.borderWidth = CGFloat(obb.border)
    }
}
open class Label: UILabel, LayoutParameters {
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
        super.draw(rect)
        if isStrokeColor {
            strokeColor()
        }
    }
    var shadowLayer: CAShapeLayer!
    override open func layoutSubviews() {
        super.layoutSubviews()
        let obb = ClassPara ()
        obb.shadowLayer = shadowLayer
        obb.backgroundColor = backgroundColor
        obb.layer = layer
        classPara = obb
        layoutSubviews (self)
    }
}
