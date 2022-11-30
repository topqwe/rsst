//
//  BaseVC.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
class BaseVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    /*
    登入拦截可分为
         1.开屏即拦
         2.点击某个tab位拦
           2.1 present的登陆页面，登入成功刷新这个tab位
               不打算登dissmiss掉可以定位不拦截的首页
           2.2 push的登陆页面，登入成功后resetWindow
               不打算登pop掉可以定位不拦截的首页
    */
    func isloginBlock() -> Bool{
        let isLogin:Bool = AppManager.shared.isLogin!
//            UserDefaults.standard.bool(forKey: "kIsLogin")
        if !isLogin {
            LoginVC.presentFromVC(rootVC:self, requestParams: 1) { (anyData) in
                print(anyData)
                let anyB :Bool = anyData as! Bool
                if anyB == true{
                    self.dissmissBack()
                    self.loginSuccessBlockMethod()
                }
                
            }
            return true
        }
        return false
    }
    
    func dissmissBack() {
        self.dismiss(animated: true) {
            
        }
    }
    
}
private typealias LoginSuccessBlockMethod = BaseVC
extension LoginSuccessBlockMethod{
    @objc func loginSuccessBlockMethod() {
        
    }
}

private typealias LocateTabBar = BaseVC
extension LocateTabBar{
    @objc func locateTabBar(index:NSInteger) -> Void {
        
        if (self.navigationController?.tabBarController!.selectedIndex == index) {
            
            self.navigationController?.popToRootViewController(animated: true);
            
        }else{
            self.navigationController?.tabBarController!.hidesBottomBarWhenPushed = false;
            
            self.navigationController?.tabBarController!.selectedIndex = index;
            
            self.navigationController?.popToRootViewController(animated: true);
        }
        
    }
}



