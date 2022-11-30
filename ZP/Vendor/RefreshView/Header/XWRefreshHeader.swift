//
//  XWRefreshHeader.swift
//  XWRefresh
//
//  Created by Aalto on 12/1/17.
//  Copyright © 2017年 AaltoChen. All rights reserved.


import UIKit

open class XWRefreshHeader: XWRefreshComponent {
    var lastUpdatedateKey:String = ""
    
    open var ignoredScrollViewContentInsetTop:CGFloat = 0.0
    
    open var lastUpdatedTime:Date{
        get{
            if let realTmp =  UserDefaults.standard.object(forKey: self.lastUpdatedateKey){
                
                return realTmp as! Date
                
            }else{
                return Date()
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        self.lastUpdatedateKey = XWRefreshHeaderLastUpdatedTimeKey
        self.xw_height = XWRefreshHeaderHeight
    }
    
    override func placeSubvies() {
        super.placeSubvies()
        self.xw_y = -self.xw_height - self.ignoredScrollViewContentInsetTop
    }
    
    override func scrollViewContentOffsetDidChange(_ change: Dictionary<String,AnyObject>?) {
        super.scrollViewContentOffsetDidChange(change)
        if self.state == XWRefreshState.refreshing { return }
        self.scrollViewOriginalInset = self.scrollView.contentInset
        let offsetY = self.scrollView.xw_offSetY
        let happenOffsetY = -self.scrollViewOriginalInset.top
        if offsetY > happenOffsetY { return }
        let normal2pullingOffsetY = happenOffsetY - self.xw_height
        let pullingPercent = (happenOffsetY - offsetY) / self.xw_height
        
        if self.scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == XWRefreshState.idle && offsetY < normal2pullingOffsetY {
                self.state = XWRefreshState.pulling
                
            } else if self.state == XWRefreshState.pulling && offsetY >= normal2pullingOffsetY {
                self.state = XWRefreshState.idle
            }
        } else if self.state == XWRefreshState.pulling {
            self.beginRefreshing()
        } else if self.pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
    override var state:XWRefreshState{
        didSet{
            if oldValue == state {
                return
            }
            
            if state == XWRefreshState.idle {
                if oldValue != XWRefreshState.refreshing { return }
                UserDefaults.standard.set(Date(), forKey: self.lastUpdatedateKey as String)
                UserDefaults.standard.synchronize()
                UIView.animate(withDuration: XWRefreshSlowAnimationDuration, animations: { [unowned self] () -> Void in
                    self.scrollView.xw_insertTop -= self.xw_height
                    if self.automaticallyChangeAlpha {self.alpha = 0.0}
                    }, completion: { [weak self] (flag) -> Void in
                        self?.pullingPercent = 0.0
                })
    
            }else if state == XWRefreshState.refreshing {
                UIView.animate(withDuration: XWRefreshSlowAnimationDuration, animations: {[unowned self] () -> Void in
                    let top = self.scrollViewOriginalInset.top + self.xw_height
                    self.scrollView.xw_insertTop = top
                    self.scrollView.xw_offSetY = -top
                    }, completion: { (flag) -> Void in
                        self.executeRefreshingCallback()
                })
                
            }
        }
    }
    
    override open func endRefreshing() {
        if self.scrollView.isKind(of: UICollectionView.self){
            xwDelay(0) { () -> () in
                super.endRefreshing()
            }
        }else{
            super.endRefreshing()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





