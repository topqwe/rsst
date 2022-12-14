//
//  XWShortcutMethod.swift
//  XWSwiftRefresh
//
//  Created by Aalto on 12/1/17.
//  Copyright © 2017年 AaltoChen. All rights reserved.


import UIKit
import Foundation

func xwColor(r:Float, g:Float, b:Float) -> UIColor {
    return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(1.0))
}

public func xwDelay(_ time:Double,closure:@escaping () -> ()){
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

extension NSObject{
    //MARK: runtime
    class func exchangeInstanceMethod1(_ method1:Selector, method2:Selector){
        method_exchangeImplementations(class_getInstanceMethod(self, method1)!, class_getInstanceMethod(self, method2)!)
    }
    
    class func exchangeClassMethod1(_ method1:Selector, method2:Selector){
        
        method_exchangeImplementations(class_getClassMethod(self, method1)!, class_getClassMethod(self, method2)!);
    }
    
    func xwExeAction(_ action:Selector){
        if self.responds(to: action) == true {
            let timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector:action, userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
}

extension UIScrollView {
    
    var xw_offSetY:CGFloat {
        get{
            return self.contentOffset.y
        }
        set {
            self.contentOffset.y = newValue
        }
    }
    
    var xw_offSetX:CGFloat {
        get{
            return self.contentOffset.x
        }
        set {
            self.contentOffset.x = newValue
        }
    }
    
    var xw_insertTop:CGFloat {
        get{
            return self.contentInset.top
        }
        set {
            self.contentInset.top = newValue
        }
    }
    
    var xw_insertRight:CGFloat {
        get{
            return self.contentInset.right
        }
        set {
            self.contentInset.right = newValue
        }
    }
    
    var xw_insertLeft:CGFloat {
        get {
            return self.contentInset.left
        }
        set {
            self.contentInset.left = newValue
        }
    }
    var xw_insertBottom:CGFloat {
        get {
            return self.contentInset.bottom
        }
        set {
            self.contentInset.bottom = newValue
        }
    }
    
    var xw_contentW:CGFloat {
        get{
            return self.contentSize.width
        }
        
        set {
            self.contentSize.width = newValue
        }
    }
    
    var xw_contentH:CGFloat {
        get{
            return self.contentSize.height
        }
        
        set {
            self.contentSize.height = newValue
        }
    }
}

extension UIView {
    
    
    var xw_x:CGFloat {
        get{
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var xw_y:CGFloat {
        get{
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var xw_width:CGFloat {
        get{
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var xw_height:CGFloat {
        get{
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    var xw_size:CGSize {
        get {
            return self.frame.size
        }
        set {
            self.frame.size = newValue
        }
    }
    var xw_origin:CGPoint {
        get {
            return self.frame.origin
        }
        set {
            self.frame.origin = newValue
        }
    }
    
    var xw_centerX:CGFloat {
        get{
            return self.center.x
        }
        
        set {
            self.center.x = newValue
        }
    }
    
    var xw_centerY:CGFloat {
        get{
            return self.center.y
        }
        
        set {
            self.center.y = newValue
        }
    }
}

extension Date {
    func xwConvertStringTime() -> String {
        let calender = Calendar.current
        
        let unitFlags = NSCalendar.Unit.day
        
        let cmp1:DateComponents = (calender as NSCalendar).components(unitFlags, from: self)
        
        let cmp2:DateComponents = (calender as NSCalendar).components(unitFlags, from: Date())
        
        let formatter = DateFormatter()
        
        if cmp1.day == cmp2.day {
            
            formatter.dateFormat = " HH:mm"
        }else {
            formatter.dateFormat = "MM-dd HH:mm"
        }
        return "Last update:" + formatter.string(from: self)
        
    }
    
}
