//
//  RefreshVC.swift
//  XWSwiftRefresh
//
//  Created by Xiong Wei on 15/10/7.
//  Copyright © 2015年 Xiong Wei. All rights reserved.
//  简书：猫爪


import UIKit

class RefreshVC: UITableViewController {
    
    var datas:Array<String> = []
    
    var successBlock: DataBlock?
    var requestParams :Any?
//    {
//        didSet{
//            self.xwExeAction(Selector(method))
//        }
//    }
    
}
// MARK: - View生命周期
extension RefreshVC {
   override func viewDidLoad() {
        setup()
        requestDatas()
    }
}

// MARK: - 请求数据
extension RefreshVC {
    // MARK: fileprivate暴露内部接口,
    fileprivate func requestDatas() {
        // MARK: 初数据
//        for index in 0...13 {
//            let s:String = "数据-" + String(index)
//            self.datas.append(s)
//        }
        (0...13).forEach{
            self.datas.append("数据-"+String($0))
        }
        self.tableView.reloadData()
    }
}

// MARK: - Setup 初始化设置
extension RefreshVC {
    // MARK: fileprivate暴露内部接口,
    fileprivate func setup() {
        setupStyle()
    }
    func setupStyle(){
        self.tableView.tableFooterView = UIView()
        self.tableView.registerReusableCell(UITableViewCell.self)
        
        guard let item = requestParams,requestParams is  HomeItem else{
            gifMode()
            return
        }
        if (item as! HomeItem).argValue == "23" {
            customMode()
        }else{
            gifMode()
        }
    }
    
}

// MARK:- 默认模式&gif图片模式
extension RefreshVC {
    // MARK: 默认模式
    func customMode(){
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(upPullLoadData))
        
        self.tableView.headerView?.beginRefreshing()
        self.tableView.headerView?.endRefreshing()
        
        self.tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: #selector(downPullLoadData))
        
    }
    
    // MARK: gif图片模式
    func gifMode(){
        var idleImages = [UIImage]()
//        for i in 1...20 {
//            let image = UIImage(named: String(format: "mono-black-%zd", i))
//            idleImages.append(image!)
//        }
//        (1...20).forEach{
//            idleImages.append(UIImage(named: "mono-black-\($0)")!)
//        }
        idleImages = (1...20).compactMap { UIImage(named: "mono-black-\($0)") }

        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        var refreshingImages = [UIImage]()
//        for i in 1...20 {
//            let image = UIImage(named: String(format: "mono-black-%zd", i))
//            refreshingImages.append(image!)
//        }
//        (1...20).forEach{
//            refreshingImages.append(UIImage(named: "mono-black-\($0)")!)
//        }
        refreshingImages = (1...20).compactMap { UIImage(named: "mono-black-\($0)") }
        // 其实headerView是一个View 拿出来，更合理
        let headerView = XWRefreshGifHeader(target: self, action: #selector(upPullLoadData))
        
        //这里是 XWRefreshGifHeader 类型,就是gif图片
        headerView.setImages(images: idleImages, duration: 0.8, state: .idle)
        headerView.setImages(images: refreshingImages, duration: 0.8, state: .refreshing)
        
        
        
        //隐藏状态栏
        headerView.refreshingTitleHidden = true
        //隐藏时间状态
        headerView.refreshingTimeHidden = true
        //根据上拉比例设置透明度
        headerView.automaticallyChangeAlpha = true
        
        self.tableView.headerView = headerView
        
    }
}
// MARK:- 加载数据
extension RefreshVC {
    @objc func upPullLoadData(){
        
        //延迟执行 模拟网络延迟，实际开发中去掉
        xwDelay(1) { () -> Void in
            
//            for i in 0..<3{
//                self.datas.append("数据-\(i + self.datas.count)")
//            }
            (0..<3).forEach{
                self.datas.append("数据-\($0 + self.datas.count)")
            }
            
            self.tableView.reloadData()
            self.tableView.headerView?.endRefreshing()
            
        }
        
    }
    
    @objc func downPullLoadData(){
        
        xwDelay(1) { () -> Void in
            (0..<3).forEach{
                self.datas.append("数据-\($0 + self.datas.count)")
            }
            
            self.tableView.reloadData()
            self.tableView.footerView?.endRefreshing()
        }
        
    }
}
// MARK: - TableView DataSource
private typealias TableViewDataSource = RefreshVC
extension TableViewDataSource{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath as NSIndexPath)
        
        cell.textLabel?.text = datas[indexPath.row]
        
        return cell
    }
}

// MARK: - TableView Delegate
private typealias TableViewDataDelegate = RefreshVC
extension TableViewDataDelegate{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppManager.shared.checkIsPresentLoginVC(fromVc: self, success: { (any) in
            RefreshVC.pushFromVC(rootVC: self, requestParams: self.datas[indexPath.row], block: { (_) in
                
            })
        })
    }
}
// MARK:- class 方法
extension RefreshVC {
    /*
     Swift中static func 相当于class final func。禁止这个方法被重写。
     ERROR: Cannot override static method
     ERROR: Class method overrides a 'final` class method
     */
    
    static func  pushFromVC(rootVC:UIViewController,requestParams:Any,block:@escaping DataBlock){
        let vc  : RefreshVC = RefreshVC.init()
        vc.successBlock = block
        vc.requestParams = requestParams as AnyObject
        rootVC.navigationController?.pushViewController(vc, animated: true)
    }
    
}
