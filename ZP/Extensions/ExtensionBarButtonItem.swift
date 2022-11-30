//
//  ExtensionBarButtonItem.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
//MARK: 标题 + target + action
extension UIBarButtonItem {
    
    /// - Parameters:
    ///   - hq_title: title
    ///   - fontSize: fontSize
    ///   - target: target
    ///   - action: action
    ///   - isBack: 是否是返回按钮,如果是就加上箭头的`icon`
    convenience init(title: String, fontSize: CGFloat = 16, target: Any?, action: Selector, isBack: Bool = false) {
        
        let btn = UIButton(title: title, fontSize: fontSize, titleNormalColor: UIColor.darkGray, titleHighlightedColor: UIColor.lightGray)
        
        if isBack {
            let imageName = "naviBack"
            btn.setImage(UIImage.init(named: imageName), for: .normal)
//            btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        // self.init 实例化 UIBarButtonItem
        self.init(customView: btn)
    }
}
