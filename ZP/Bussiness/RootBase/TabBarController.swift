//
//  TabBarController.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
class TabBarController: UITabBarController,UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let tabBar = TabBar()
        setValue(tabBar, forKey: "tabBar")
        tabBar.isTranslucent = false;
        tabBar.shadowImage = UIImage.init();
        
        self.configSubViewControllers()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if (tabBarController.selectedIndex != 0 &&  tabBarController.selectedIndex != 1) {
            
//            AppManager.shared.loginResetRootControl()
            
            let naviC = viewController as! NaviagtionController;
            let viewControllers:Array = naviC.viewControllers;
            for i in 0..<viewControllers.count {
                let vc = viewControllers[i] as! BaseVC;//present login block
                AppManager.shared.checkIsPresentLoginVC(fromVc: vc, success: { (any) in
                    
                    vc.locateTabBar(index: tabBarController.selectedIndex)
                    
                }, close: { (any) in
                    if tabBarController.selectedIndex == 1 {
                        
                        vc.locateTabBar(index: 1)
                        
                    }else{
                        
                        vc.locateTabBar(index: 0)
                        
                    }
                })
//                if (vc.isloginBlock()) {
//                    vc.locateTabBar(index: 0);
//                    return;
//                }
            }
        }
    }
    
    func configSubViewControllers(){
        self.viewControllers = [
        self.getViewControllerWithVC(vc: HomeVC.init(), title: "首页", normalImage: UIImage.init(named: "icon_home_gray")!, selectImage: UIImage.init(named: "icon_home_blue")!),
        self.getViewControllerWithVC(vc: ViewController.init(), title: "群组", normalImage: UIImage.init(named: "icon_deal_gray")!, selectImage: UIImage.init(named: "icon_deal_blue")!),
        self.getViewControllerWithVC(vc: WKJSInteractVC.init(), title: "消息", normalImage: UIImage.init(named: "icon_massage_gray")!, selectImage: UIImage.init(named: "icon_massage_blue")!),
        self.getViewControllerWithVC(vc: MyVC.init(), title: "我的", normalImage: UIImage.init(named: "icon_my_gray")!, selectImage: UIImage.init(named: "icon_my_blue")!)
        ]
    }
    
    func getViewControllerWithVC(vc:UIViewController,title:String,normalImage:UIImage,selectImage:UIImage) -> UIViewController {
           vc.tabBarItem = UITabBarItem.init(title: title, image: normalImage.withRenderingMode(.alwaysOriginal), selectedImage: selectImage.withRenderingMode(.alwaysOriginal))
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont.init(name: "Avenir-Medium", size: 12) as Any], for: .normal)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue,NSAttributedString.Key.font: UIFont.init(name: "Avenir-Medium", size: 12) as Any], for: .selected)
            vc.tabBarItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -2)
        
            vc.navigationItem.title = title;
            let nav  = NaviagtionController(rootViewController: vc);
        return nav;
    }
        
    
}
