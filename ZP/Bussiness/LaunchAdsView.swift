//
//  LaunchAdsView.swift
//
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

class LaunchAdsView: UIView {
    var block: DataBlock?
    var requestParams :Any?
    
    var durationTime: Int = 0 {
        didSet {
            skipButton.setTitle("跳过\n\(durationTime) s", for: .normal)
        }
    }
    fileprivate lazy var imageBtn = with(UIButton()) {
        $0.isUserInteractionEnabled = true
    }
    
    fileprivate lazy var skipButton = with(UIButton()) {
        $0.layer.cornerRadius = 40 / 2
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor(red: 0.64, green: 0.64, blue: 0.64, alpha: 1)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        $0.titleLabel?.numberOfLines = 2
        $0.titleLabel?.textAlignment = .center
    }
    
    var timer: Timer?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.MAINSCREEN_WIDTH(), height: UIScreen.MAINSCREEN_HEIGHT()))
        setUp()
        startTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func showView(_ duration: Int, bgImageUrl: String, block:@escaping DataBlock) {
        let launchView = LaunchAdsView()
        launchView.durationTime = duration
        launchView.imageBtn.kf.setBackgroundImage(with:URL.init(string: bgImageUrl), for: .normal, placeholder: UIImage.init(named: "launchAds"), options: nil, progressBlock: nil)
        
        
        launchView.block = block
        UIApplication.shared.delegate?.window!!.addSubview(launchView)
        
//        guard !bgImageUrl.isEmpty else {
//            let userDefaults = UserDefaults.standard
//            userDefaults.set(true, forKey: bgImageUrl)
//            return
//        }
//        let userDefaults = UserDefaults.standard
//        userDefaults.set(false, forKey: bgImageUrl)
        let userDefaults = UserDefaults.standard
        userDefaults.set(bgImageUrl.isEmpty ? true: false, forKey: bgImageUrl)
    }
    
    @objc func imgBtnClick() {
        dismissView()
        guard let _ = self.block else {
            return
        }
        self.block!(true)
    }
    
    @objc func dismissView() {
        
        stopTimer()
        UIView.animate(withDuration: 0.8, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }, completion: {(finished) in
            self.removeFromSuperview()
        })
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerDecrease), userInfo: nil, repeats: true)
    }
    
    @objc func timerDecrease() {
        
        if durationTime == 0 {
            
            dismissView()
            
        } else {
            
            durationTime -= 1
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

private typealias ViewStylingHelpers = LaunchAdsView
extension ViewStylingHelpers  {
    fileprivate func setUp() {
        addSubview(imageBtn)
        addSubview(skipButton)
        
        imageBtn.addTarget(self, action: #selector(imgBtnClick), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        setLayout()
    }
    
    private func setLayout() {
        imageBtn.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        skipButton.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-20)
        maker.top.equalToSuperview().offset(UIScreen.STATUSBAR_HEIGHT()+20)
            maker.width.equalTo(40)
            maker.height.equalTo(40)
        }
    }
    
}


