//
//  NavigationController.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

class NaviagtionController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationBar.isTranslucent = false;
        navigationBar.shadowImage = UIImage.init()
        navigationBar.barTintColor = UIColor.ThemeColor
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont.init(name: "Avenir-Medium", size: 18) as Any
            ]
        navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            /*
             判断控制器的类型
             - 如果是第一级页面,不显示`leftBarButtonItem`
             - 只有第二级页面以后才显示`leftBarButtonItem`
             */
//            if let vc = viewController as? BaseVC {
            
                var title = "返回"
                
                if viewControllers.count == 1 {
                    title = viewControllers.first?.title ?? "返回"
                }
                
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popBack), isBack: true)
//            }
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    @objc func popBack() {
        popViewController(animated: true)
    }
}
// MARK: - PreferredStatusBar Style
private typealias PreferredStatusBarStyle = NaviagtionController
extension PreferredStatusBarStyle {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if let topViewController = presentedViewController{
            return topViewController.preferredStatusBarStyle
        }
        if let topViewController = viewControllers.last {
            return topViewController.preferredStatusBarStyle
        }
        
        return .default
    }
}
