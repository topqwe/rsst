//
//  XWRefreshComponent.swift
//  XWRefresh
//
//  Created by Aalto on 12/1/17.
//  Copyright © 2017年 AaltoChen. All rights reserved.


import UIKit

public enum XWRefreshState:Int{
    case idle = 1
    case pulling
    case refreshing
    case willRefresh
    case noMoreData 
}

public typealias XWRefreshComponentRefreshingClosure = ()->()
open class XWRefreshComponent: UIView {
    open var textColor:UIColor?
    open var font:UIFont?
    fileprivate weak var refreshingTarget:AnyObject!
    fileprivate var refreshingAction:Selector = NSSelectorFromString("");
    var refreshingClosure:XWRefreshComponentRefreshingClosure = {}
    
    open var pullingPercent:CGFloat = 1 {
        didSet{
            
            if self.state == XWRefreshState.refreshing { return }
            if self.automaticallyChangeAlpha == true {
                self.alpha = pullingPercent
            }
        }
    }
    
    open var automaticallyChangeAlpha:Bool = false {
        didSet{
            if self.state == XWRefreshState.refreshing { return }
            if automaticallyChangeAlpha == true {
                self.alpha = self.pullingPercent
            }else {
                self.alpha = 1
            }
        }
    }
    
    var state = XWRefreshState.idle
    
    open var isRefreshing:Bool{
        get {
            return self.state == .refreshing || self.state == .willRefresh;
        }
    }
    
    func addCallBack(_ block:@escaping XWRefreshComponentRefreshingClosure){
        self.refreshingClosure = block
    }
    
    public convenience
    init(ComponentRefreshingClosure:@escaping XWRefreshComponentRefreshingClosure){
        self.init()
        self.refreshingClosure = ComponentRefreshingClosure
        
    }
    
    public convenience
    init(target:AnyObject, action:Selector){
        self.init()
        self.setRefreshingTarget(target, action: action)
    }
    
    func setRefreshingTarget(_ target:AnyObject, action:Selector){
        self.refreshingTarget = target
        self.refreshingAction = action
    }
    
    open func beginRefreshing(){
        UIView.animate(withDuration: XWRefreshSlowAnimationDuration, animations: { () -> Void in
            self.alpha = 1.0
        })
        self.pullingPercent = 1.0
        if let _ =  self.window {
            self.state = .refreshing
        }else{
            self.state = XWRefreshState.willRefresh
            self.setNeedsDisplay()
        }

    }
    
    open func endRefreshing(){
        self.state = .idle
    }
    
    func prepare(){
        self.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.backgroundColor = UIColor.clear
    }
    
    func placeSubvies(){
    }
    
    func scrollViewContentOffsetDidChange(_ change:Dictionary<String, AnyObject>?){
    }
    
    func scrollViewContentSizeDidChange(_ change:Dictionary<String, AnyObject>?){
    }
    
    func scrollViewPanStateDidChange(_ change:Dictionary<String, AnyObject>?){
    }
    
    func executeRefreshingCallback(){
        DispatchQueue.main.async { () -> () in
            self.refreshingClosure()
            if let realTager = self.refreshingTarget {
                if realTager.responds(to: self.refreshingAction) == true {
                    let timer = Timer.scheduledTimer(timeInterval: 0, target: self.refreshingTarget as Any, selector: self.refreshingAction, userInfo: nil, repeats: false)
                    RunLoop.main.add(timer, forMode: .common)
                }
            }
        }
    }
    
    var scrollViewOriginalInset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    weak var scrollView:UIScrollView!
    
    fileprivate var pan:UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.prepare()
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.removeObservers()
        if let tmpNewSuperview = newSuperview  {
            self.xw_width = tmpNewSuperview.xw_width
            self.xw_x = 0
            self.scrollView = tmpNewSuperview as? UIScrollView
            self.scrollView.alwaysBounceVertical = true;
            self.scrollViewOriginalInset = self.scrollView.contentInset;
            self.addObservers()
        }
    }
    
    fileprivate func addObservers(){
        let options:NSKeyValueObservingOptions = NSKeyValueObservingOptions.new
        self.scrollView.addObserver(self , forKeyPath: XWRefreshKeyPathContentSize, options: options, context: nil)
        self.scrollView.addObserver(self , forKeyPath: XWRefreshKeyPathContentOffset, options: options, context: nil)
        self.pan = self.scrollView.panGestureRecognizer
        self.pan.addObserver(self , forKeyPath: XWRefreshKeyPathPanKeyPathState, options: options, context: nil)
    }
    
    fileprivate func removeObservers(){
        if let realSuperview = self.superview {
            realSuperview.removeObserver(self, forKeyPath: XWRefreshKeyPathContentOffset)
            realSuperview.removeObserver(self, forKeyPath: XWRefreshKeyPathContentSize)
        }
        if let realPan = self.pan {
            realPan.removeObserver(self, forKeyPath: XWRefreshKeyPathPanKeyPathState)
        }
        self.pan = nil
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == XWRefreshState.willRefresh {
            self.state = .refreshing
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.placeSubvies()
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]!, context: UnsafeMutableRawPointer?) {
        let dic = change.first
        let key = dic?.key.rawValue
        let value = dic?.value as AnyObject
        if !self.isUserInteractionEnabled { return }
        if keyPath == XWRefreshKeyPathContentSize {
            scrollViewContentSizeDidChange([key!: value])
        }

        if self.isHidden { return }
        if keyPath == XWRefreshKeyPathContentOffset{
            scrollViewContentOffsetDidChange([key!: value])
        }else if keyPath == XWRefreshKeyPathPanKeyPathState{
            scrollViewContentSizeDidChange([key!: value])
        }
    }
    
}

extension UILabel {
    func Lable() -> UILabel {
        let myLable = UILabel()
        myLable.font = XWRefreshLabelFont;
        myLable.textColor = XWRefreshLabelTextColor;
        myLable.autoresizingMask = UIView.AutoresizingMask.flexibleWidth;
        myLable.textAlignment = NSTextAlignment.center;
        myLable.backgroundColor = UIColor.clear;
        return myLable
    }
}



