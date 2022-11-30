//
//  ExtensionScreen.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

extension UIScreen {
    
    /// 屏幕的宽度
    ///
    /// - Returns: ScreenWidth
    class func MAINSCREEN_WIDTH() -> CGFloat {
        
        return UIScreen.main.bounds.size.width
    }
    
    /// 屏幕的高度
    ///
    /// - Returns: ScreenHeight
    class func MAINSCREEN_HEIGHT() -> CGFloat {
        
        return UIScreen.main.bounds.size.height
    }
    
    /// 屏幕宽高比
    ///
    /// - Returns: ScreenWidth / ScreenHeight
    class func WHSCALE() -> CGFloat {
        
        let w = CGFloat(UIScreen.MAINSCREEN_WIDTH())
        let h = CGFloat(UIScreen.MAINSCREEN_HEIGHT())
        
        return w / h
    }
    /// statusBar高度
    ///
    /// - Returns: STATUSBAR_HEIGHT
    class func STATUSBAR_HEIGHT() -> CGFloat {
        
        return UIApplication.shared.statusBarFrame.height
    }
}
