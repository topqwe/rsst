//
//  XWRefreshStateHeader.swift
//  XWSwiftRefresh
//
//  Created by Aalto on 12/1/17.
//  Copyright © 2017年 AaltoChen. All rights reserved.


import UIKit

open class XWRefreshStateHeader: XWRefreshHeader {
    fileprivate var stateTitles:Dictionary<XWRefreshState, String> = [
        XWRefreshState.idle : XWRefreshHeaderStateIdleText,
        XWRefreshState.refreshing : XWRefreshHeaderStateRefreshingText,
        XWRefreshState.pulling : XWRefreshHeaderStatePullingText
    ]
    
    var closureCallLastUpdatedTimeTitle:((_ lastUpdatedTime:Date) -> String)?
    lazy var lastUpdatedTimeLabel:UILabel = {
        [unowned self] in
        let lable = UILabel().Lable()
        self.addSubview(lable)
        return lable
        }()

    lazy var stateLabel:UILabel = {
        [unowned self] in
        let lable = UILabel().Lable()
        self.addSubview(lable)
        return lable
        }()
    
    open func setTitle(_ title:String, state:XWRefreshState){
        self.stateLabel.text = self.stateTitles[self.state];
    }
    
    open var refreshingTitleHidden:Bool = false {
        didSet{
            if oldValue == refreshingTitleHidden { return }
            self.stateLabel.isHidden = refreshingTitleHidden
        }
    }
    
    open var refreshingTimeHidden:Bool = false {
        didSet{
            if oldValue == refreshingTimeHidden { return }
            self.lastUpdatedTimeLabel.isHidden = refreshingTimeHidden

        }

    }

    override var lastUpdatedateKey:String{
        didSet{
            if let lastUpdatedTimeDate = UserDefaults.standard.object(forKey: lastUpdatedateKey) {
                let realLastUpdateTimeDate:Date = lastUpdatedTimeDate as! Date
                if let internalClosure = self.closureCallLastUpdatedTimeTitle {
                    self.lastUpdatedTimeLabel.text = internalClosure(realLastUpdateTimeDate)
                    return
                }
                self.lastUpdatedTimeLabel.text = realLastUpdateTimeDate.xwConvertStringTime()
                
            }else{
                self.lastUpdatedTimeLabel.text = "Last update: No Data"
            }
        }
    }
    
    override var state:XWRefreshState{
        didSet{
            if state == oldValue { return }
            self.stateLabel.text = self.stateTitles[self.state];
//            self.lastUpdatedateKey = self.lastUpdatedateKey.self
        }
    }
    
    override func prepare() {
        super.prepare()
        self.setTitle(XWRefreshHeaderStateIdleText, state: .idle)
        self.setTitle(XWRefreshHeaderStatePullingText, state: .pulling)
        self.setTitle(XWRefreshHeaderStateRefreshingText, state: .refreshing)
    }
    
    override func placeSubvies() {
        super.placeSubvies()
        if self.stateLabel.isHidden { return }
        
        if self.lastUpdatedTimeLabel.isHidden {
            self.stateLabel.frame = self.bounds
        }else {
            self.stateLabel.frame = CGRect(x: 0, y: 0, width: self.xw_width, height: self.xw_height * 0.5)
            self.lastUpdatedTimeLabel.xw_x = 0
            self.lastUpdatedTimeLabel.xw_y = self.stateLabel.xw_height
            self.lastUpdatedTimeLabel.xw_width = self.xw_width
            self.lastUpdatedTimeLabel.xw_height = self.xw_height - self.lastUpdatedTimeLabel.xw_y
        }

    }

}
