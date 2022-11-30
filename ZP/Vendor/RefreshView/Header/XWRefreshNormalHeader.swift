//
//  XWRefreshNormalHeader.swift
//  XWSwiftRefresh
//
//  Created by Aalto on 12/1/17.
//  Copyright © 2017年 AaltoChen. All rights reserved.


import UIKit

open class XWRefreshNormalHeader: XWRefreshStateHeader {
    open var activityIndicatorViewStyle:UIActivityIndicatorView.Style = UIActivityIndicatorView.Style.gray {
        
        didSet{
            self.activityView.style = activityIndicatorViewStyle
            self.setNeedsLayout()
        }
    }
    
    open var arrowImage:UIImage? {
        didSet{
            
            self.arrowView.image = arrowImage
            self.placeSubvies()
        }
    }
    
    lazy  var arrowView:UIImageView = {
        [unowned self] in

        var image = UIImage(named:XWIconSrcPath)
        if image == nil {
            image = UIImage(named: XWIconLocalPath)
        }
        let imageView = UIImageView(image: image)
        self.addSubview(imageView)
        
        return imageView
        }()
    
    fileprivate lazy var activityView:UIActivityIndicatorView = {
        
        [unowned self] in
        
        let activityView = UIActivityIndicatorView(style: self.activityIndicatorViewStyle)
        activityView.bounds = self.arrowView.bounds
        
        self.addSubview(activityView)
        
        return activityView
        }()
    
    override func placeSubvies() {
        super.placeSubvies()
        self.arrowView.xw_size = (self.arrowView.image?.size)!
        var arrowCenterX = self.xw_width * 0.5 - 50
        if !self.stateLabel.isHidden {
            arrowCenterX -= 100
        }
        let arrowCenterY = self.xw_height * 0.5
        self.arrowView.center = CGPoint(x: arrowCenterX, y: arrowCenterY)
        self.activityView.frame = self.arrowView.frame
    }
    
    fileprivate var oldState:XWRefreshState!
    override var state:XWRefreshState{
        
        didSet{
            self.oldState = oldValue
            if state == oldValue {return}
            self.switchStateDoSomething(state)
        }
    }
    
    fileprivate func switchStateDoSomething(_ state:XWRefreshState) {
        func commonFun(){
            self.activityView.stopAnimating()
            self.arrowView.isHidden = false
        }
        
        switch state {
        case .idle :
            if self.oldState == XWRefreshState.refreshing {
                self.arrowView.transform = CGAffineTransform.identity
                
                UIView.animate(withDuration: XWRefreshSlowAnimationDuration, animations: { () -> Void in
                    self.activityView.alpha = 0.0
                    }, completion: { (flag) -> Void in
                        if self.state != XWRefreshState.idle {
                            return
                        }
                        self.activityView.alpha = 1.0
                        commonFun()
                })
                
            }else{
                commonFun()
                UIView.animate(withDuration: XWRefreshSlowAnimationDuration, animations: { () -> Void in
                    self.arrowView.transform = CGAffineTransform.identity
                    
                })
            }
            
        case .pulling:
            commonFun()
            UIView.animate(withDuration: XWRefreshSlowAnimationDuration, animations: { () -> Void in
                let tmp:CGFloat = 0.000001 - CGFloat(Double.pi)
                self.arrowView.transform = CGAffineTransform(rotationAngle: tmp);
            })
            
        case .refreshing:
            self.arrowView.isHidden = true
            self.activityView.alpha = 1.0
            self.activityView.startAnimating()
        default: break
            
        }
        
        
    }
}
    
