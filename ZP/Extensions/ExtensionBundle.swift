//
//  ExtensionBundle.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//


import UIKit

extension Bundle {
    
    // 计算型属性类似于函数,没有参数,有返回值
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    var bundleVersion: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    var bundleShortVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
}
