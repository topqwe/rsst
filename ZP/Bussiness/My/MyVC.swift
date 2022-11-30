//
//  HomeVC.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices
// MARK:- class 方法
extension MyVC {
    static func  pushFromVC(rootVC:UIViewController,requestParams:Any,block:@escaping DataBlock) ->  Void{
        let vc  : MyVC = MyVC.init()
        vc.successBlock = block
        vc.requestParams = requestParams
        rootVC.navigationController?.pushViewController(vc, animated: true)
    }
}
class MyVC: BaseVC {
    
    var vm: HomeVM = {
        let vm = HomeVM()
        return vm
    }()
    
    var successBlock: DataBlock?
    var requestParams :Any?
    
    fileprivate let tableHeaderHeight: CGFloat = 250
    
    private lazy var gradientTitleBtn = with(GradientTextLabel()) {
        //$0.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        $0.contentHorizontalAlignment = .left
        $0.contentVerticalAlignment = .center
        $0.titleLabel?.numberOfLines = 0
    }
    
    private lazy var avatorBtn = with(UIButton()) {
//        $0.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel!.font = UIFont.systemFont(ofSize: 13)
        $0.contentHorizontalAlignment = .left
    }
    
    private lazy var headerView = with(UIButton()) {
        $0.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        $0.setBackgroundImage(UIImage(named: "strechyHeaderImage"), for: .normal)
    }
    
    private var currentPage:NSInteger = 0
    
    private lazy var sections = [SectionModel]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame:view.bounds, style: UITableView.Style.grouped)
        tableView.generalConfiguration()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = 46
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
}

// MARK: - View生命周期
extension MyVC {
    override func viewDidLoad() {
        setup()
        tableView.headerView?.beginRefreshing()
        //        requestDatas()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        reloadHeaderViewData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    //TODO:- 登入成功刷新MyVC接口
    override func loginSuccessBlockMethod() {
        print("登入成功刷新MyVC接口")
        requestDatas()
    }
}

// MARK: - 请求数据
extension MyVC {
    // MARK: fileprivate暴露内部接口,
    fileprivate func requestDatas() {
        vm.loadData(page:currentPage, requestParams: ["20"], success: { (model) in
            let model = [
                SectionModel(sectionType: IndexSectionType.IndexSection0,sectionInfo: [], rowItems: [
                    ["defaultphoto":"单选"],
                    ["defaultphoto":"多选"],
                    ]),
                SectionModel(sectionType: IndexSectionType.IndexSection1,sectionInfo: [], rowItems: [
                    ["defaultphoto":"设置"],
                    ]),
                SectionModel(sectionType: IndexSectionType.IndexSection2,sectionInfo: [], rowItems: [
                    
                    ["defaultphoto":"版本"],
                    ["defaultphoto":"退出"],
                    ]),
            ]
            
            self.requestListSuccessWithArray(array: model as [Any], page: self.currentPage)
            
        }, failure: { (code, message) in
            //            self.requestListFailed()
        })//failure {} = nil
        
    }
    // MARK: 数据返回后，对tableView的影响
    private func requestListSuccessWithArray(array:[Any],page:NSInteger) {
        self.currentPage = page
        if self.currentPage == 1 {
            sections.removeAll()
            tableView.reloadData()
        }
        if self.currentPage == 1&&array.count==0 {
            //            self.dataEmptyView.hidden = NO;
            tableView.headerView?.endRefreshing()
            tableView.footerView?.endRefreshing()
            return
        }
        if array.count>0 {
            //            self.dataEmptyView.hidden = YES;
            sections += array as! [SectionModel]//NSMutableArray的addObjectsFromArray
            reloadHeaderViewData()
            tableView.reloadData()
            tableView.footerView?.endRefreshing()
            setupSearchContent()
        }else{
            tableView.footerView?.noticeNoMoreData()
        }
        tableView.headerView?.endRefreshing()
    }
    
    private func requestListFailed() {
        currentPage = 0
        sections.removeAll()
        tableView.reloadData()
        //        self.dataEmptyView.hidden = YES;
        tableView.headerView?.endRefreshing()
        tableView.footerView?.endRefreshing()
    }
    
    private func reloadHeaderViewData() {
        headerView.addTarget(self, action: #selector(headerViewAction), for: .touchUpInside)
        avatorBtn.addTarget(self, action: #selector(avatorBtnAction(_:)), for: .touchUpInside)
//        avatorBtn.isUserInteractionEnabled = false
        avatorBtn.setImage(UIImage(named: "defaultavator")!, for: .normal)
//        avatorBtn.setTitle(AppManager.shared.userInfo.userName, for: .normal)
//        avatorBtn.layoutButtonWithEdgeInsetsStyle(style: .MKButtonEdgeInsetsStyleLeft, space: 5)
        view.layoutIfNeeded()
        view.circleFilledWithOutline(circleView: avatorBtn, fillColor: .clear, outlineColor: .blue)
        
        guard let userName = AppManager.shared.userInfo.userName else {
            return
        }
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        gradientTitleBtn.isUserInteractionEnabled = false
        gradientTitleBtn.textAttributes = [.font: UIFont.systemFont(ofSize: 20), .paragraphStyle: style]//,.foregroundColor: UIColor.white//无效
        gradientTitleBtn.text = userName as NSString?
    }
}

// MARK: - Setup 初始化设置
private typealias ViewStylingHelpers = MyVC
extension ViewStylingHelpers  {
    // MARK: fileprivate暴露内部接口,
    fileprivate func setup() {
        setupStyle()
        setupView()
        setupLayout()
    }
    // MARK: private内部实现
    private func setupStyle() {
        //FIXME: - tabbarTitle < self.title
    }
    
    private func setupView() {
        
    }
    
    private func setupLayout() {
        view?.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view!)
        })
        
        setRefresh()
        
        //headerView = tableView.tableHeaderView!
        //tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        headerView.addSubview(avatorBtn)
        headerView.addSubview(gradientTitleBtn)
        
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
        updateHeaderView()
        
        view.layoutIfNeeded()
        //gradientLayer.frame 需要 avatorBtn也要size设置圆角
        
        avatorBtn.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(50)
            maker.top.equalToSuperview().offset(tableHeaderHeight/2)
//            maker.centerY.equalToSuperview()
            maker.width.equalTo(50)
//            maker.right.equalToSuperview().offset(-50)
            maker.height.equalTo(50)
        }
        
        
        
        gradientTitleBtn.snp.makeConstraints { (maker) in

            maker.left.equalTo(avatorBtn.snp.right).offset(5)
            maker.centerY.equalTo(avatorBtn)
            //            maker.width.equalTo(120)
            maker.right.equalToSuperview().offset(-50)
            maker.height.equalTo(50)//分行
        }
    }
    
}

// MARK:- 上下刷新功能
extension MyVC {
    fileprivate func setRefresh(){
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(upPullLoadData))
        
//        self.tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: #selector(downPullLoadData))
    }
    
    @objc func upPullLoadData(){
        //延迟执行 模拟网络延迟，实际开发中去掉
        //        xwDelay(1) { () -> Void in
        self.currentPage = 1
        requestDatas()
        //        }
    }
    
    @objc func downPullLoadData(){
        xwDelay(1) { () -> Void in
            self.currentPage += 1
            self.requestDatas()
        }
    }
}

// MARK: - Setup 初始化设置
private typealias ActionTargets = MyVC
extension ActionTargets  {
    @objc func headerViewAction(){
        let image = headerView.backgroundImage(for: .normal)
        let blurImage = UIImage().filterGaussianBlur(value: 2, originImage: image!, size:headerView.frame.size)
        SaveToAlbum.sharedInstance.save(image: blurImage!, toAlbum: Bundle.main.namespace) { (any) in
            if any {
                
                UIAlertController.showAlert(message: "saved successful!")
            }
        }
    }
    
    @objc func avatorBtnAction(_ sender: UIButton){
        UIImage().queryLastPhoto(resizeTo: nil){
            image in
            sender.setImage(image, for: .normal)
        }
    }
}
// MARK: - TableView DataSource
private typealias TableViewDataSource = MyVC
extension TableViewDataSource: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDic = sections[section]
        let rows = sectionDic.rowItems
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var section:NSInteger = indexPath.section;
        if section >= sections.count {
            section = sections.count - 1
        }
        
        let sectionDic = sections[section]
//        let sectionType = sectionDic.sectionType
        let rows = sectionDic.rowItems
        let itemData = rows[indexPath.row]
        
        let cell = MyCell.cellWith(tableView) as! MyCell
        cell.configure(itemData as! Dictionary< String , String>,indexPath)
        
        return cell
    }
}

// MARK: - TableView Delegate
private typealias TableViewDataDelegate = MyVC
extension TableViewDataDelegate: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var section:NSInteger = indexPath.section;
        if section >= sections.count {
            section = sections.count - 1
        }
        
        //        let sectionDic = sections[section] as! Dictionary< String , Any?>
        //        let sectionType:IndexSectionType = IndexSectionType(rawValue: sectionDic[kIndexSection] as! Int)!
        //        let rows = sectionDic[kIndexRow]! as! [Any]
        //        let itemData = rows[indexPath.row]
        let sectionDic = sections[section]
        let sectionType = sectionDic.sectionType
        let rows = sectionDic.rowItems
        var itemData = rows[indexPath.row]

        switch sectionType {
        case .IndexSection0:
            switch indexPath.row {
            case 0:
                CheckmarkVC.pushFromVC(rootVC: self, requestParams: itemData, block: { (_) in
                })
            case 1:
                MultiCheckmarkVC.pushFromVC(rootVC: self, requestParams: itemData, block: { (_) in
                })
                
            default: break
            }
            
        
        case .IndexSection1:
            DatePickerView.show { time in
                itemData = ["defaultphoto":time]
                let indexPath = IndexPath.init(row: 0, section: 1)
                let cell = tableView.cellForRow(at: indexPath) as! MyCell
                cell.configure(itemData as! Dictionary< String , String>,indexPath)
            }
        case .IndexSection2:
            switch indexPath.row {
            case 0: break
                
            case 1:
                UIAlertController.showConfirm(message: "是否退出？") { (_) in
                    AppManager.shared.logout()
                    self.locateTabBar(index: 0)
                    if self.successBlock != nil {
                        self.successBlock!(true)
                    }
                }
                
            default: break
            }
            
        default: break
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: SectonHeader
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
    // MARK: SectonFooter
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView.init()
        v.backgroundColor = UIColor(0xf6f5fa)
        return v
    }
    
}
//MARK:- UIScrollViewDelegate
private typealias ScrollViewDelegate = MyVC
extension ScrollViewDelegate:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func updateHeaderView() {
        
        var rect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        if tableView.contentOffset.y < -tableHeaderHeight {
            rect.origin.y = tableView.contentOffset.y
            rect.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = rect
    }
}

// MARK:- 设置搜索内容
private typealias SpotlightSearchFunc = MyVC
extension SpotlightSearchFunc{
    
    func setupSearchContent() {
        
        var searchItems = [CSSearchableItem]()
        
        let sectionDic = sections[IndexSectionType.IndexSection0.rawValue]
//        let sectionType = sectionDic.sectionType
        let rows = sectionDic.rowItems
//        let itemData = rows[indexPath.row]
        for i in 0...(rows.count - 1) {
            
            let scenery = (rows[i] as! Dictionary<String,String>).values.first
            let imgName = (rows[i] as! Dictionary<String,String>).keys.first
            
            let searchItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            searchItemAttributeSet.title = scenery
            searchItemAttributeSet.contentDescription = "This is \(Bundle.main.namespace)\("的")\(scenery ?? "")"
            searchItemAttributeSet.thumbnailData = UIImage(named: imgName!)!.pngData()
            
            let searchItem = CSSearchableItem(uniqueIdentifier: "scenery\(i)", domainIdentifier: "scenery", attributeSet: searchItemAttributeSet)
            searchItems.append(searchItem)
            
            CSSearchableIndex.default().indexSearchableItems([searchItem], completionHandler: { (error) -> Void in
                
                if error != nil {
                    print(error?.localizedDescription as Any)
                }
            })
        }
        
    }
}
