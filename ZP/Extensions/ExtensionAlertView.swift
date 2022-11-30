//
//  ExtensionColor.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
extension UIAlertController {
    //在指定视图控制器上弹出普通消息提示框
    static func showAlert(message: String, in viewController: UIViewController) {
        DispatchQueue.main.async {
         let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "确定", style: .cancel))
         viewController.present(alert, animated: true)
        }
    }

    //在根视图控制器上弹出普通消息提示框
    static func showAlert(message: String) {
        DispatchQueue.main.async {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showAlert(message: message, in: vc)
        }
        }
    }
    
    //在指定视图控制器上弹出确认框
    static func showConfirm(message: String, in viewController: UIViewController,confirm: ((UIAlertAction)->Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: confirm))
            viewController.present(alert, animated: true)
        }
    }
    
    //在根视图控制器上弹出确认框
    static func showConfirm(message: String, confirm: ((UIAlertAction)->Void)?) {
        DispatchQueue.main.async {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showConfirm(message: message, in: vc, confirm: confirm)
        }
        }
    }
}

