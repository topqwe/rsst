//
//  AppManager.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

private let fileName = "/AppManager.path"

class AppManager: NSObject,NSCoding {
    // MARK:- 用户账户的懒加载属性
    var userInfo : UserInfo = {
        let userInfo = UserInfo()
        return userInfo
    }()
    // MARK:- 用户登录标记(计算型属性)
//    var isLogin: Bool {
//        return (userInfo.token != "" || userInfo.token != nil || userInfo.isLogin == true)
//    }
    var isLogin: Bool?
    
    // MARK:- 归档解档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.isLogin, forKey: kIsLogin)
        aCoder.encode(self.userInfo, forKey: kUserInfo)
    }
    
    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        self.isLogin = (aDecoder.decodeObject(forKey: kIsLogin) as! Bool)//别用decodeBool
        self.userInfo = (aDecoder.decodeObject(forKey: kUserInfo) as! UserInfo)
        
    }
    // MARK:- 单例模型
    private static var instance = AppManager()

    override private init() {

    }
    
    public static var shared: AppManager {
        let filePath = String.hq_appendDocmentDirectory(fileName: fileName)
        if FileManager.default.fileExists(atPath: filePath!) {
            self.instance = (NSKeyedUnarchiver.unarchiveObject(withFile: filePath!)) as! AppManager
//            print(self.instance.userInfo.token as Any,self.instance.isLogin as Any)
        }
        return self.instance
    }
}//使用方式AppManager.shared

// MARK:- WindowRoot逻辑
extension AppManager {
    func resetRootAnimation(_ b:Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0)
        {
            let window = UIApplication.shared.keyWindow
            if b {
                window?.layer.add(UIView().cubeAnimation(), forKey: nil)
            }
            window!.rootViewController = self.rootVc()
        }
    }

    func rootVc() -> UIViewController {
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: Bundle.main.bundleShortVersion) {
            return GuideVC()
        }else{
            return TabBarController()
        }
    }
}
// MARK:- 登入退出逻辑
extension AppManager {
    func logout() {
        destroyAppManagerData()
//        loginoutResetRootControl()
    }
    
    func login() {
        saveAppManagerData()
//        loginResetRootControl()
    }
    
    func saveAppManagerData() {
        let filePath = String.hq_appendDocmentDirectory(fileName: fileName)
        NSKeyedArchiver.archiveRootObject(self, toFile: filePath!)
    }
    
    func destroyAppManagerData() {
        let filePath = String.hq_appendDocmentDirectory(fileName: fileName)
        if String.delete(atPath: filePath!) {
            AppManager.shared.userInfo = UserInfo.init()
            AppManager.shared.isLogin = false
//            saveAppManagerData()
        }
    }
    
    func loginoutResetRootControl(){
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0)
//        {
//            let window = UIApplication.shared.keyWindow
//
////            if (AppManager.shared.isLogin == false) {
//                window!.rootViewController = TabBarController.init();
////            }
//
//        }
        
        resetRootAnimation(true)
        
    }
    
    func loginResetRootControl(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0)
        {
        
            let window = UIApplication.shared.keyWindow
            
            if (AppManager.shared.isLogin == true) {
                return
            }else{
                let loginVc =  LoginVC.getVC(requestParams: 1, block: { (anyData) in
                    print(anyData)
                    window!.rootViewController = TabBarController.init();
                })
                window!.rootViewController = NaviagtionController(rootViewController: loginVc)
            }
            
        }
        
    }
    
    func checkIsPresentLoginVC(fromVc:UIViewController, success: ((Any) -> Void)? = nil, close: ((Any) -> Void)? = nil){//可有可无形参( index: (Int)? = 0)或(_: (Any)? = nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0)
        {
            
        let window = UIApplication.shared.keyWindow
            
        if (AppManager.shared.isLogin == true) {
            if success != nil{
                success!(true)
            }
        }else{
            LoginVC.presentFromVC(rootVC: window!.rootViewController!, requestParams: 1, successBlock: { (any) in
                let selectorWithParam = NSSelectorFromString("loginSuccessBlockMethod" )
                if fromVc.responds(to:selectorWithParam) {
                    fromVc.perform(selectorWithParam)
                }
//                vc.loginSuccessBlockMethod()
                
                if success != nil{
                    success!(any)
                }
                
            }, closeBlock: { (any) in
                
                if close != nil{
                    close!(any)
                }
                
            })
            
        }
            
        }
    }
    
    
    
}

// MARK:- 单例的3种写法
//class AppManager {
//    static var shared = AppManager()
//
//    override private init() {
//
//    }//私有化init方法
//}//使用方式AppManager.shared


//class AppManager {
//    private static let _shared = AppManager()
//
//    class func shared() -> AppManager
//    {
//        return _shared
//
//    }
//    private init() {
//
//    }//私有化init方法
//
//}//使用方式AppManager.shared()


//class AppManager {
//    //通过关键字static来保存实例引用
//    private static let instance = AppManager()
//
//    //私有化构造方法
//    private init() {
//    }
//
//    //提供静态访问方法
//    public static var shared: AppManager {
//        return self.instance
//    }
//}//使用方式AppManager.shared

/*
 为什么要保证init的私有化？因为只有init()是私有的，才能防止其他对象通过默认构造函数对这个类对象直接创建，确保单例是独一无二的。在Swift中，所有对象的构造器默认都是public，所以需要重写init让它成为私有的。另外，也可以使不规范的写法报错，如var a1 = AppShared2() ，就会编译报错，不能通过。
 */
 
