//
//  TabBar.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

class TabBar: UITabBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        for (indx,tabBar) in subviews.enumerated(){
            if "\(tabBar.classForCoder)" == "UITabBarButton"{
                let ctr = tabBar as! UIControl
                ctr.tag = indx
                ctr.addTarget(self, action: #selector(barButtonAction), for: .touchUpInside)
           
               
            }
        }
    }

}
extension TabBar{
    @objc func barButtonAction(sender:UIControl) {
        for imageView in sender.subviews {
            if "\(imageView.classForCoder)" == "UITabBarSwappableImageView"{
                switch sender.tag{
                case 1:
                    tabBarAnimation0(view: imageView)
                    break
                case 2:
                    tabBarAnimation1(view: imageView)
                    break
                case 3:
                    tabBarAnimation2(view: imageView)
                    break
                case 4:
                    tabBarAnimation3(view: imageView)
                    break
                case 5:
                    tabBarAnimation4(view: imageView)
                    break
                default:
                
                    break
                }
            }
            
        }
    }
    
    func tabBarAnimation0(view:UIView) {
        let scaleAnimation = CAKeyframeAnimation()
        scaleAnimation.keyPath = "transform.scale"
        scaleAnimation.values = [1.0,1.3,1.5,1.25,0.8,1.25,1.0]
        scaleAnimation.duration = 0.5
        scaleAnimation.calculationMode = .cubic
        scaleAnimation.repeatCount = 1
        view.layer.add(scaleAnimation, forKey: "tabBarAnimation0")
    }
    //带重力效果的弹跳
    func tabBarAnimation1(view:UIView) {
        let scaleAnimation = CAKeyframeAnimation()
        scaleAnimation.keyPath = "transform.translation.y"
        scaleAnimation.values = [0.0, -4.15, -7.26, -9.34, -10.37, -9.34, -7.26, -4.15, 0.0, 2.0, -2.9, -4.94, -6.11, -6.42, -5.86, -4.44, -2.16, 0.0];
        scaleAnimation.duration = 0.8;
        scaleAnimation.beginTime = CACurrentMediaTime() + 0.2
        view.layer.add(scaleAnimation, forKey: "tabBarAnimation1")
        
    }
    //先放大，再缩小
    func tabBarAnimation2(view:UIView) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.duration = 0.2 //执行时间
        animation.repeatCount = 1//执行次数
        animation.fromValue = 0.7
        animation.toValue = 1.3
        view.layer.add(animation, forKey: "tabBarAnimation2")
    }
    //Y轴位移
    func tabBarAnimation3(view:UIView) {
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        animation.duration = 0.2 //执行时间
        animation.repeatCount = 1//执行次数
        animation.isRemovedOnCompletion = true
        animation.fromValue = 0
        animation.toValue = -10
        view.layer.add(animation, forKey: "tabBarAnimation3")
    }
    //淡入淡出
    func tabBarAnimation4(view:UIView) {
        let trans = CATransition()
        trans.type = .fade
        trans.subtype = .fromLeft
        view.layer.add(trans, forKey: "tabBarAnimation4")
    }
}
