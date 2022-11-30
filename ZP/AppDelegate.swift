//
//  AppDelegate.swift
//  RS
//
//  Created by Aalto on 28/11/2018.
//  Copyright © 2018 aa. All rights reserved.

//open -a Xcode Cartfile
//carthage update --platform iOS
//https://blog.csdn.net/Mazy_ma/article/details/70185547
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        window?.rootViewController = AppManager.shared.rootVc()

//        print("\(BACKEND_URL)")
//        printAppInfo()
        return true
    }

    func printAppInfo() {
        if let dictionary = Bundle.main.infoDictionary {
            let appName = dictionary["APP_NAME"] as! String
            let appVersion = dictionary["APP_VERSION"] as! String
            let appBuildVersion = dictionary["APP_BUILD_VERSION"] as! String
            print("\(appName) \(appVersion) (\(appBuildVersion))")
            
            //    let backend = (dictionary["BACKEND_URL"] as! String).stringByReplacingOccurrencesOfString("\\", withString: "")
            let backend = NSMutableAttributedString(string: dictionary["BACKEND_URL"] as! String)
            backend.mutableString.replaceOccurrences(of: "\\", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSRange(location: 0, length: backend.length))
            print("backend: \(backend)")
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

