//
//  ExtensionColor.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
private typealias RotateAnimation = UIView
extension RotateAnimation {
    func rotateAnimation(_ toValue: CGFloat, duration: CFTimeInterval = 0.2, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.toValue = toValue
        rotateAnimation.duration = duration
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.fillMode = .forwards
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

private typealias CubeAnimation = UIView
extension CubeAnimation {
    func cubeAnimation() -> CATransition {
        let animate = CATransition.init()
        animate.duration = 0.3
        animate.timingFunction = CAMediaTimingFunction.init(name: .easeIn)
        animate.type =  CATransitionType(rawValue: "cube")
        //立方体效果
    
        //设置动画子类型
        animate.subtype = .fromTop
        return animate
    }
}
private typealias circleFilled = UIView
extension circleFilled {
    func circleFilledWithOutline(circleView: UIView, fillColor: UIColor, outlineColor:UIColor) {
        let circleLayer = CAShapeLayer()
        let width = Double(circleView.bounds.size.width);
        let height = Double(circleView.bounds.size.height);
        circleLayer.bounds = CGRect(x: 2.0, y: 2.0, width: width-2.0, height: height-2.0)
        circleLayer.position = CGPoint(x: width/2, y: height/2);
        let rect = CGRect(x: 2.0, y: 2.0, width: width-2.0, height: height-2.0)
        let path = UIBezierPath.init(ovalIn: rect)
        circleLayer.path = path.cgPath
        circleLayer.fillColor = fillColor.cgColor
        circleLayer.strokeColor = outlineColor.cgColor
        circleLayer.lineWidth = 2.0
        circleView.layer.addSublayer(circleLayer)
    }
}
