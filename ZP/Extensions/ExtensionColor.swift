//
//  ExtensionColor.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// 普通字体颜色
    open class var ThemeColor: UIColor {
        
        get {
            return UIColor(0xDDF0ED)
            //        UIColor.HEXCOLOR(0xDDF0ED)
        }
    }
    /// 普通字体颜色
    open class var TEXTCOLOR: UIColor {
        
        get {
            return UIColor.lightGray
        }
    }
    
    /// 标题字体颜色
    open class var TITLETEXTCOLOR: UIColor {
        
        get {
            return UIColor.darkGray
        }
    }
    
    /// 随机色
    ///
    /// - Returns: 随机的颜色
    class func RANDOMRGBCOLOR() -> UIColor {
        
        let r = CGFloat(arc4random() % 256) / 255.0
        let g = CGFloat(arc4random() % 256) / 255.0
        let b = CGFloat(arc4random() % 256) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /// 十六进制颜色
    ///
    /// - Parameter withHex: 0xFFFFFF
    /// - Returns: color
    class func HEXCOLOR(_ withHex: UInt32) -> UIColor {
        
        let r = ((CGFloat)((withHex & 0xFF0000) >> 16)) / 255.0
        let g = ((CGFloat)((withHex & 0xFF00) >> 8)) / 255.0
        let b = ((CGFloat)(withHex & 0xFF)) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /// 0~255 颜色
    ///
    /// - Parameters:
    ///   - withRed: red(0~255)
    ///   - green: green(0~255)
    ///   - blue: blue(0~255)
    /// - Returns: color
    class func RGBCOLOR(withRed: UInt8, green: UInt8, blue: UInt8) -> UIColor {
        
        let r = CGFloat(withRed) / 255.0
        let g = CGFloat(green) / 255.0
        let b = CGFloat(blue) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /*
     convenience:便利，使用convenience修饰的构造函数叫做便利构造函数
     便利构造函数通常用在对系统的类进行构造函数的扩充时使用。
     便利构造函数的特点：
     1、便利构造函数通常都是写在extension里面
     2、便利函数init前面需要加载convenience
     3、在便利构造函数中需要明确的调用self.init()
     即必须调用Swift同一个类中的designated初始化完成设置
     */
    convenience init(_ hexColor: UInt32) {
        let r = ((CGFloat)((hexColor & 0xFF0000) >> 16)) / 255.0
        let g = ((CGFloat)((hexColor & 0xFF00) >> 8)) / 255.0
        let b = ((CGFloat)(hexColor & 0xFF)) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
        
    }
    
    convenience init(_ hexColor: UInt32,_ a : CGFloat) {
        let r = ((CGFloat)((hexColor & 0xFF0000) >> 16)) / 255.0
        let g = ((CGFloat)((hexColor & 0xFF00) >> 8)) / 255.0
        let b = ((CGFloat)(hexColor & 0xFF)) / 255.0
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ a : CGFloat) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
}
