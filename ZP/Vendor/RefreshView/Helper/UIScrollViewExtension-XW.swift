//
//  UIScrollViewExtension-XW.swift
//  XWRefresh
//
//  Created by Aalto on 12/1/17.
//  Copyright © 2017年 AaltoChen. All rights reserved.


import UIKit

private var XWRefreshHeaderKey:Void?

private var XWRefreshFooterKey:Void?

private var XWRefreshReloadDataClosureKey:Void?

typealias xwClosureParamCountType = (Int)->Void

open class xwReloadDataClosureInClass {
    var reloadDataClosure:xwClosureParamCountType = { (Int)->Void in }
}

public extension UIScrollView {
    var reloadDataClosureClass: xwReloadDataClosureInClass {
        set{
            self.willChangeValue(forKey: "reloadDataClosure")
            objc_setAssociatedObject(self, &XWRefreshReloadDataClosureKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            self.didChangeValue(forKey: "reloadDataClosure")
        }
        get{
            if let realClosure = objc_getAssociatedObject(self, &XWRefreshReloadDataClosureKey) {
                return realClosure as! xwReloadDataClosureInClass
            }
            return xwReloadDataClosureInClass()
        }
        
    }
    
    var headerView: XWRefreshHeader?{
		set{
			if self.headerView == newValue { return }
			self.headerView?.removeFromSuperview()
			objc_setAssociatedObject(self,&XWRefreshHeaderKey, newValue , objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)

			if let newHeaderView = newValue {
				self.addSubview(newHeaderView)
			}
		}
		get{
			return objc_getAssociatedObject(self, &XWRefreshHeaderKey) as? XWRefreshHeader
		}
	}
    
    
    var footerView:XWRefreshFooter?{
        
        set{
            if self.footerView == newValue { return }
            self.footerView?.removeFromSuperview()
            objc_setAssociatedObject(self,&XWRefreshFooterKey, newValue , objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            
            if let newFooterView = newValue {
                self.addSubview(newFooterView)
            }
        }
        get{
            return objc_getAssociatedObject(self, &XWRefreshFooterKey) as? XWRefreshFooter
        }
    }
    var totalDataCount: Int{
        get{
            var totalCount:Int = 0
            if self.isKind(of: UITableView.self){
                let tableView = self as! UITableView
                for section in 0..<tableView.numberOfSections {
                    totalCount += tableView.numberOfRows(inSection: section)
                }
                
            }else if self.isKind(of: UICollectionView.self) {
                let collectionView = self as! UICollectionView
                for section in 0..<collectionView.numberOfSections {
                    totalCount += collectionView.numberOfItems(inSection: section)
                }
            }
            return totalCount
        }
    }
    
    func executeReloadDataClosure() {
        self.reloadDataClosureClass.reloadDataClosure(self.totalDataCount)
    }
}

public protocol SwizzlingInjection: class {
    static func inject()
}

class SwizzlingHelper {
    private static let doOnce: Any? = {
        UITableView.inject()
        return nil
    }()
    
    static func enableInjection() {
        _ = SwizzlingHelper.doOnce
    }
}

extension UIApplication {
    
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        SwizzlingHelper.enableInjection()
        return super.next
    }
    
}

extension UITableView: SwizzlingInjection {
    public static func inject() {
        // make sure this isn't a subclass
        guard self === UITableView.self else { return }
        
        // Do your own method_exchangeImplementations(originalMethod, swizzledMethod) here
        self.exchangeInstanceMethod1(#selector(UITableView.reloadData), method2: #selector(UITableView.xwReloadData))
        
    }

//    open override class func init(){
//        if self != UITableView.self { return }
//        self.exchangeInstanceMethod1(#selector(UITableView.reloadData), method2: #selector(UITableView.xwReloadData))
//    }
//
    @objc func xwReloadData(){
        self.xwReloadData()
        self.executeReloadDataClosure()
        
    }
}
