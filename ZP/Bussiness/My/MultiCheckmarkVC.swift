//
//  CheckmarkVC.swift
//  RS
//
//  Created by Aalto on 2020/3/25.
//  Copyright © 2020 aa. All rights reserved.
//


import UIKit

class MultiCheckmarkVC: UITableViewController {
    
    var datas:Array<CheckmarkItem> = []
    var selectedIndexs = NSMutableArray()
    
    var successBlock: DataBlock?
    var requestParams :Any?
//    {
//        didSet{
//            self.xwExeAction(Selector(method))
//        }
//    }
    
}
// MARK: - View生命周期
extension MultiCheckmarkVC {
   override func viewDidLoad() {
        setup()
        requestDatas()
    }
}

// MARK: - 请求数据
extension MultiCheckmarkVC {
    // MARK: fileprivate暴露内部接口,
    fileprivate func requestDatas() {
        // MARK: 初数据
//        for index in 0...13 {
//            let s:String = "数据-" + String(index)
//            self.datas.append(s)
//        }
        (0...26).forEach{
//           let e = CheckmarkItem()
//            e.title = "数据-"+String($0)
//            e.checked = $0 % 2 == 1 ? true : false
//           self.datas.append(e)
        
    //结构体实例是通过值传递而不是通过引用传递
            self.datas.append(CheckmarkItem(title:"数据-"+String($0),isChecked:false,cover:""))
//        self.datas.append("数据-"+String($0))
        }
        self.tableView.reloadData()
    }
}

// MARK: - Setup 初始化设置
extension MultiCheckmarkVC {
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
extension MultiCheckmarkVC {
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
extension MultiCheckmarkVC {
    @objc func upPullLoadData(){
        
        //延迟执行 模拟网络延迟，实际开发中去掉
        xwDelay(1) { () -> Void in
            
//            for i in 0..<3{
//                self.datas.append("数据-\(i + self.datas.count)")
//            }
//            (0..<3).forEach{
//                self.datas.append("数据-\($0 + self.datas.count)")
//            }
            
            self.tableView.reloadData()
            self.tableView.headerView?.endRefreshing()
            
        }
        
    }
    
    @objc func downPullLoadData(){
        
//        xwDelay(1) { () -> Void in
//            (0..<3).forEach{
//            self.datas.append("数据-\($0 + self.datas.count)")
//        }
            
        self.tableView.reloadData()
    self.tableView.footerView?.endRefreshing()
//        }
        
    }
}
// MARK: - TableView DataSource
private typealias TableViewDataSource = MultiCheckmarkVC
extension TableViewDataSource{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CheckmarkCell<CheckmarkItem>.cellWith(tableView) as! CheckmarkCell<CheckmarkItem>
        
        var CheckmarkItem = datas[indexPath.row]
        
        for index in selectedIndexs {
            if (index as? IndexPath) == indexPath {
                CheckmarkItem.isChecked = true
            }
        }
        
        cell.configure(withDelegate: CheckmarkItem)
        return cell
        
    }
}
//https://www.jianshu.com/p/e872c6f9ff34
// MARK: - TableView Delegate
private typealias TableViewDataDelegate = MultiCheckmarkVC
extension TableViewDataDelegate{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = self.tableView(tableView, cellForRowAt: indexPath) as! CheckmarkCell<CheckmarkItem>
        var CheckmarkItem = datas[indexPath.row]
        
        if  CheckmarkItem.isChecked == true{
            CheckmarkItem.isChecked = false
            
            cell.configure(withDelegate: CheckmarkItem)
            selectedIndexs.remove(indexPath)
        }else{
            CheckmarkItem.isChecked = true
            
            cell.configure(withDelegate: CheckmarkItem)
            selectedIndexs.add(indexPath)
        }
        tableView.reloadData()
        
    }
}
// MARK:- class 方法
extension MultiCheckmarkVC {
    /*
     Swift中static func 相当于class final func。禁止这个方法被重写。
     ERROR: Cannot override static method
     ERROR: Class method overrides a 'final` class method
     */
    
    static func  pushFromVC(rootVC:UIViewController,requestParams:Any,block:@escaping DataBlock){
        let vc  : MultiCheckmarkVC = MultiCheckmarkVC.init()
        vc.successBlock = block
        vc.requestParams = requestParams as AnyObject
        rootVC.navigationController?.pushViewController(vc, animated: true)
    }
    
}
