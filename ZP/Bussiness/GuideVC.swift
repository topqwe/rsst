//
//  GuideVC.swift
//
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

class GuideVC: UIViewController {

    fileprivate let numOfPages = 2
    
    fileprivate lazy var startButton = with(UIButton()) {
        //MARK: 隐藏开始按钮
        $0.alpha = 0.0
        $0.backgroundColor = UIColor.ThemeColor
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel!.font = UIFont.systemFont(ofSize: 13)
        $0.contentHorizontalAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15.0
        $0.setTitle("开始使用", for: .normal)
    }
    
    fileprivate lazy var pageControl = with(UIPageControl()) {
//        $0.backgroundColor = UIColor.clear
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        $0.hidesForSinglePage = true
        $0.numberOfPages = numOfPages
        $0.currentPage = 0
    }
    
    fileprivate lazy var scrollView = with(UIScrollView()) {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.scrollsToTop = false
        $0.bounces = false
        $0.contentOffset = CGPoint.zero
        $0.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        //MARK: 将scrollView的contentSize设为屏幕宽度的numOFPages倍
        scrollView.contentSize = CGSize(width: view.frame.size.width * CGFloat(numOfPages), height: view.frame.size.height)
        
        for index  in 0..<numOfPages {
            let imageView = UIImageView(image: UIImage(named: "GuideImage\(index + 1)"))
            imageView.frame = CGRect(x: UIScreen.MAINSCREEN_WIDTH() * CGFloat(index), y: 0, width: view.frame.size.width, height: view.frame.size.height)
            scrollView.addSubview(imageView)
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

private typealias  ScrollViewDelegate = GuideVC
extension ScrollViewDelegate: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        pageControl.currentPage = Int(offset.x / view.bounds.width)
        
        if pageControl.currentPage == numOfPages - 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.startButton.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.startButton.alpha = 0.0
            })
        }
    }
}

private typealias ViewStylingHelpers = GuideVC
extension ViewStylingHelpers  {
    fileprivate func setUp() {
        view.insertSubview(scrollView, at: 0)
        view.addSubview(pageControl)
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(startInto), for: .touchUpInside)
        
        setLayout()
    }
    private func setLayout() {
        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-56)
            maker.width.equalTo(125)
            maker.height.equalTo(45)
        }
        
        pageControl.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(startButton)
            maker.width.equalTo(UIScreen.MAINSCREEN_WIDTH()); maker.top.equalTo(startButton.snp.bottom).offset(10)
        }
        
    }
    
    @objc func startInto() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: Bundle.main.bundleShortVersion)
        AppManager.shared.resetRootAnimation(true)
    }
}


