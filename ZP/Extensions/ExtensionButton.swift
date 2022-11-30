//
//  ExtensionButton.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
enum MKButtonEdgeInsetsStyle {
    case MKButtonEdgeInsetsStyleTop // image在上，label在下
    case MKButtonEdgeInsetsStyleLeft // image在左，label在右
    case MKButtonEdgeInsetsStyleBottom // image在下，label在上
    case MKButtonEdgeInsetsStyleRight // image在右，label在左
}
// MARK:- 获取验证码按钮
class TimerButton: UIButton {
    
    fileprivate var hq_timer: Timer?
    fileprivate var hq_remindTime: NSInteger?
    
    func timeDown(time: NSInteger) {
        
        isEnabled = false
        
        if #available(iOS 10.0, *) {
            hq_timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.timeFire()
            })
        } else {
            // Fallback on earlier versions
            hq_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeFire), userInfo: nil, repeats: true)
        }
        RunLoop.current.add(hq_timer!, forMode: .common)
        hq_remindTime = time
    }
    
    @objc fileprivate func timeFire() {
        
        if hq_remindTime! > 1 {
            
            hq_remindTime! -= 1
            setTitle("\(hq_remindTime!)s后重新获取", for: .disabled)
            print("\(hq_remindTime!)s后重新获取")
        } else {
            
            isEnabled = true
            hq_timer?.invalidate()
            hq_timer = nil
            setTitle("获取验证码", for: .normal)
        }
    }
}
// MARK:- 渐变背景色的按钮
@IBDesignable public class GradientBgButton: UIButton {
    
    public var startColor: UIColor = .ThemeColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var endColor: UIColor = .green {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var startPointX: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var startPointY: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var endPointX: CGFloat = 1 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var endPointY: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: 1.lift cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 2.private methods
    override public func draw(_ rect: CGRect) {
        gradientLayer.frame = rect
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
    }
    
    // MARK: 3.event response
    
    // MARK: 4.interface
    
    // MARK: 5.getter
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        return gradientLayer
    }()
}
// MARK:- convenience便利方法
extension UIButton {
    
    // MARK: 图片 + 背景图片
    ///
    /// - Parameters:
    ///   - imageName: 图像名称
    ///   - backImageName: 背景图像名称
    convenience init(hq_imageName: String, backImageName: String?) {
        self.init()
        
        setImage(UIImage(named: hq_imageName), for: .normal)
        setImage(UIImage(named: hq_imageName + "_highlighted"), for: .highlighted)
        
        if let backImageName = backImageName {
            setBackgroundImage(UIImage(named: backImageName), for: .normal)
            setBackgroundImage(UIImage(named: backImageName + "_highlighted"), for: .highlighted)
        }
        
        // 根据背景图片大小调整尺寸
        sizeToFit()
    }
    
    // MARK: 标题 + 字体颜色
    ///
    /// - Parameters:
    ///   - hq_title: 标题
    ///   - fontSize: 字号(默认 16 号)
    ///   - titleNormalColor: normalColor
    ///   - titleHighlightedColor: highlightedColor
    convenience init(title: String, fontSize: CGFloat = 16, titleNormalColor: UIColor, titleHighlightedColor: UIColor) {
        self.init()
        
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        setTitleColor(titleNormalColor, for: .normal)
        setTitleColor(titleHighlightedColor, for: .highlighted)
        
        // 注意: 这里不写`sizeToFit()`那么`Button`就显示不出来
        sizeToFit()
    }
    
    // MARK: 标题 + 文字颜色 + 背景图片
    ///
    /// - Parameters:
    ///   - hq_title: title
    ///   - color: color
    ///   - backImageName: backImageName
    convenience init(hq_title: String, color: UIColor, backImageName: String) {
        self.init()
        
        setTitle(hq_title, for: .normal)
        setTitleColor(color, for: .normal)
        setBackgroundImage(UIImage(named: backImageName), for: .normal)
        
        sizeToFit()
    }
    
    
    /// 标题 + 字号 + 背景色 + 高亮背景色
    ///
    /// - Parameters:
    ///   - hq_title: title
    ///   - fontSize: fontSize
    ///   - normalBackColor: normalBackColor
    ///   - hightBackColor: hightBackColor
    ///   - size: size
    convenience init(title: String, fontSize: CGFloat = 16, normalBackColor: UIColor, hightBackColor: UIColor, size: CGSize) {
        self.init()
        
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        let normalIamge = UIImage(hq_color: normalBackColor, size: CGSize(width: size.width, height: size.height))
        let hightImage = UIImage(hq_color: hightBackColor, size: CGSize(width: size.width, height: size.height))
        
        setBackgroundImage(normalIamge, for: .normal)
        setBackgroundImage(hightImage, for: .highlighted)

        layer.cornerRadius = 3
        clipsToBounds = true
        
        // 注意: 这里不写`sizeToFit()`那么`Button`就显示不出来
        sizeToFit()
    }
}

// MARK:- 通过颜色创建图片
extension UIButton {
    /// - Parameters:
    ///   - color: color
    ///   - size: size
    /// - Returns: 固定颜色和尺寸的图片
    fileprivate func creatImageWithColor(color: UIColor, size: CGSize) -> UIImage {

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

// MARK:- image和title位置摆放
extension UIButton {
    func layoutButtonWithEdgeInsetsStyle(style:MKButtonEdgeInsetsStyle,space:CGFloat) {
        //    self.backgroundColor = [UIColor cyanColor];
        
        /**
         *  前置知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
         *  如果只有title，那它上下左右都是相对于button的，image也是一样；
         *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
         */
        
        
        // 1. 得到imageView和titleLabel的宽、高
        let imageWith = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        let labelWidth = self.titleLabel?.frame.size.width
        let labelHeight = self.titleLabel?.frame.size.height
        
        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets  = UIEdgeInsets.zero
        var labelEdgeInsets  = UIEdgeInsets.zero
        
        // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .MKButtonEdgeInsetsStyleTop:
       
            imageEdgeInsets = UIEdgeInsets.init(top: -labelHeight!-space/2.0, left: 0, bottom: 0, right: -labelWidth!)
            labelEdgeInsets = UIEdgeInsets.init(top: 0, left: -imageWith!-0, bottom: -imageHeight!-space/2.0, right: 0)
            
        case .MKButtonEdgeInsetsStyleLeft:
        
            imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -space/2.0, bottom: 0, right: space/2.0)
            labelEdgeInsets = UIEdgeInsets.init(top: 0, left: space/2.0, bottom: 0, right: -space/2.0)
            
        case .MKButtonEdgeInsetsStyleBottom:
        
            imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: -labelHeight!-space/2.0, right: -labelWidth!)
            labelEdgeInsets = UIEdgeInsets.init(top: -imageHeight!-space/2.0, left: -imageWith!, bottom: 0, right:0)
       
        case .MKButtonEdgeInsetsStyleRight:
        
            imageEdgeInsets = UIEdgeInsets.init(top: 0, left: labelWidth!+space/2.0, bottom: 0, right: -labelWidth!-space/2.0)
            labelEdgeInsets = UIEdgeInsets.init(top: 0, left: -imageWith!-space/2.0, bottom: 0, right:imageWith!+space/2.0)
            
        }
        
        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets;
        self.imageEdgeInsets = imageEdgeInsets;
    }
}
