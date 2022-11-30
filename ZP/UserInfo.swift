//
//  UserInfo.swift
//  RS
//
//  Created by Aalto on 2019/7/8.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

private let fileName = "useraccount.json"

class UserInfo: NSObject,NSCoding {
    var isLogin: Bool?
    /// Token
    var token: String!
    /// 用户代号
    var uid: String?
    /// `Token`的生命周期,单位是`秒`
    var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    /// 过期日期
    var expiresDate: Date?
    /// 用户昵称
    var nickName: String?
    /// 用户昵称
    var userName: String?
    /// 用户头像地址(大图),180x180
    var avatar: String?
    
    // 归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.token, forKey: kUserToken)
        aCoder.encode(self.userName, forKey: kUserName)
        
    }
    // 解档
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        
//        fatal error: unexpectedly found nil while unwrapping an Optional value
//        崩溃的原因就是aDecoder.decodeObject(forKey: kUserToken)为nil，对nil强制取值而崩溃。
        
//        if aDecoder.decodeObject(forKey: kUserToken) != nil{
//            self.token =  (aDecoder.decodeObject(forKey: kUserToken) as! String)
//        }else{
//            print("Doesn’t contain a value.")
//        }
        guard let token = aDecoder.decodeObject(forKey: kUserToken) else{// 在变量不能被解包的时候退出
            return
        }
        self.token = (token as! String)// 这个变量现在已经解包了可以直接使用，不用再检验其值不为nil。

        guard let userName = aDecoder.decodeObject(forKey: kUserName) else{
            return
        }
        self.userName = (userName as! String)
    }
    
    override init() {
        super.init()
        
//        guard let path = String.hq_appendDocmentDirectory(fileName: fileName),
//            let data = NSData(contentsOfFile: path),
//            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject]
//            else {
//            return
//        }
//        
//        // 使用字典设置属性
//        /********** 用户是否登录的关键代码 **********/
////        yy_modelSet(with: dict ?? [:])
//        
//        // 模拟日期过期
////        expiresDate = Date(timeIntervalSinceNow: -3600 * 24 * 365 * 5)
//        
//        // 判断`token`是否过期
//        if expiresDate?.compare(Date()) != .orderedDescending {
//            print("账户过期")
//            // 清空`token`
//            token = nil
//            uid = nil
//            
//            // 删除文件
//            try? FileManager.default.removeItem(atPath: path)
//        }
    }
    
    /*
     数据存储方式:
     - 1.偏好设置
     - 2.沙盒-归档/`plist`/`json`
     - 3.数据库(`FMDB`/CoreData)
     - 4.钥匙串访问(存储小类型数据,存储时会自动加密,需要使用框架`SSKeyChain`)
     */
    func saveAccount() {

        // 1.模型转字典
//        var dict = self.yy_modelToJSONObject() as? [String: AnyObject] ?? [:]
//        var dict:Dictionary 
//        
//        // 删除`expires_in`值
//        dict.removeValue(forKey: "expires_in")
//        
//        // 2.字典序列化`data`
//        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
//            let filePath = String.hq_appendDocmentDirectory(fileName: fileName)
//            else {
//                return
//        }
//        
//        // 3.写入磁盘
//        (data as NSData).write(toFile: filePath, atomically: true)
    }
}


