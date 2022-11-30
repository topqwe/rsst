//
//  HomeVC.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
import Kingfisher
private let HomeCellId = "HomeCellId"

class HomeVC: BaseVC {
    
    var vm: HomeVM = {
       let vm = HomeVM()
        return vm
    }()

    private var currentPage:NSInteger = 0
    
    private lazy var sections = [Any]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame:view.bounds, style: UITableView.Style.grouped)
        tableView.generalConfiguration()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = 46
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = UIView()
        HomeSectionHV.sectionHeaderViewWith(tableView)
//        tableView.registerReusableCell(HomeCell<HomeItem>.self)
//        tableView.register(HomeCell<HomeItem>.self, forCellReuseIdentifier: HomeCellId)
        return tableView
    }()
}

// MARK: - View生命周期
extension HomeVC {
    override func viewDidLoad() {
        
        setup()
        tableView.headerView?.beginRefreshing()
//        requestDatas()
        
        //TODO:- 请求开机广告接口
        let bgImageUrl = ""
        
//        let userDefaults = UserDefaults.standard
//        guard !userDefaults.bool(forKey: bgImageUrl) else{
//            return
//        }
        LaunchAdsView.showView(3, bgImageUrl: bgImageUrl) { (any) in
            print(any)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        UIApplication.shared.statusBarStyle = .default
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

// MARK: - 请求数据
extension HomeVC {
    // MARK: fileprivate暴露内部接口,
    fileprivate func requestDatas() {
        vm.loadData(page:currentPage, requestParams: ["20"], success: { (model) in
            self.requestListSuccessWithArray(array: model as! [Any], page: self.currentPage)
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
            sections += array//NSMutableArray的addObjectsFromArray
            tableView.reloadData()
            tableView.footerView?.endRefreshing()
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
}

// MARK: - Setup 初始化设置
private typealias ViewStylingHelpers = HomeVC
extension ViewStylingHelpers  {
    // MARK: fileprivate暴露内部接口,
    fileprivate func setup() {
        setupStyle()
        setupView()
        setupLayout()
    }
    // MARK: private内部实现
    private func setupStyle() {
        title = "演示"
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
        
    }
}

// MARK:- 上下刷新功能
extension HomeVC {
    fileprivate func setRefresh(){
        self.tableView.headerView = XWRefreshNormalHeader(target: self, action: #selector(upPullLoadData))
        
        self.tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: #selector(downPullLoadData))
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
// MARK: - TableView DataSource
private typealias TableViewDataSource = HomeVC
extension TableViewDataSource: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section >= sections.count {
//           section = sections.count - 1
//        }
        
//        let sectionDic = sections[section] as! Dictionary< String , Any?>
//        let rows = sectionDic[kIndexRow]! as! [Any]
        let sectionDic = sections[section] as! SectionModel
        let rows = sectionDic.rowItems
        if (sectionDic.collapsed == true) {
            return 0
        } else {
            return rows.count
        }
//        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var section:NSInteger = indexPath.section;
        if section >= sections.count {
           section = sections.count - 1
        }
        
//        let sectionDic = sections[section] as! Dictionary< String , Any?>
//        let sectionType:IndexSectionType = IndexSectionType(rawValue: sectionDic[kIndexSection] as! Int)!
//        let rows = sectionDic[kIndexRow]! as! [Any]
//        let itemData = rows[indexPath.row]
        let sectionDic = sections[section] as! SectionModel
        let sectionType = sectionDic.sectionType
        let rows = sectionDic.rowItems
        let itemData = rows[indexPath.row]
        
        switch sectionType {
        case .IndexSection0:
            let cell = BannerCell.cellWith(tableView) as! BannerCell
            let arr = itemData as! [BannerItem]
            cell.configure(arr, block: { (anyData) in
                print(anyData)
            })
            return cell
            
        case .IndexSection1:
            let cell = GridCell.cellWith(tableView) as! GridCell
            let arr = itemData as! [GridItem]
            cell.configure(arr, block: { (anyData) in
                print(anyData)
                })
            return cell
            
        case .IndexSection2:
            //        let cell:HomeCell = HomeCell.cellWith(tableView) as! HomeCell
            
            let cell = HomeCell<HomeItem>.cellWith(tableView) as! HomeCell<HomeItem>
            
            //        let cell = tableView.dequeueReusableCell(indexPath: indexPath as NSIndexPath) as! HomeCell<HomeItem>
            //        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellId, for: indexPath) as! HomeCell<HomeItem>
            
            let HomeItem = itemData as! HomeItem
            //        cell.richElementsInCellWithModel([HomeItem.header,HomeItem.title[0]])
            
            //        cell.configure(withDelegate: HomeVM())
            
            //        let vm = HomeVM()
            //        cell.configure(withDataSource: vm, delegate: vm)
            
            //        cell.configure(withDelegate: HomeVM(header: exampleHeaderTitle00, title: ["默认"], methods: ["example001"]))
            cell.configure(withDelegate: HomeItem)
            return cell
            
        default:
            var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell == nil {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
            }
            return cell!
        }

    }
}

// MARK: - TableView Delegate
private typealias TableViewDataDelegate = HomeVC
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
        let sectionDic = sections[section] as! SectionModel
        let sectionType = sectionDic.sectionType
        let rows = sectionDic.rowItems
        let itemData = rows[indexPath.row]
        
        switch sectionType {
        case .IndexSection2:
            let example = itemData as! HomeItem
            RefreshVC.pushFromVC(rootVC: self, requestParams: example, block: { (_) in
                
            })
            
        default: break
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var section:NSInteger = indexPath.section;
        if section >= sections.count {
            section = sections.count - 1
        }
        
//        let sectionDic = sections[section] as! Dictionary< String , Any?>
//        let sectionType:IndexSectionType = IndexSectionType(rawValue: sectionDic[kIndexSection] as! Int)!
//        let rows = sectionDic[kIndexRow]! as! [Any]
//        let itemData = rows[indexPath.row]
        let sectionDic = sections[section] as! SectionModel
        let sectionType = sectionDic.sectionType
        let rows = sectionDic.rowItems
        let itemData = rows[indexPath.row]
        
        switch sectionType {
        case .IndexSection0:
            return BannerCell.cellHeightWithModel(1)
            
        case .IndexSection1:
            let arr = itemData as! [GridItem]
            return CGFloat(GridCell.cellHeightWithModel(arr))
            
        case .IndexSection2:
            let example = itemData as! HomeItem
            return HomeCell<HomeItem>.cellHeightWithModel(example)
            
        default:
            return 80
        }
        
    }
    
    // MARK: SectonHeader
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let sectionDic = sections[section] as! Dictionary< String , Any?>
//        let sectionType:IndexSectionType = IndexSectionType(rawValue: sectionDic[kIndexSection] as! Int)!
//        let sectionDic = sections[section] as! SectionModel
//        let sectionType = sectionDic.sectionType
        
//        switch sectionType {
//        case .IndexSection2:
//            return HomeSectionHV.viewHeightWithModel(2)
        
//        default:
            return 0.1
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let sectionDic = sections[section] as! Dictionary< String , Any?>
//        let sectionType:IndexSectionType = IndexSectionType(rawValue: sectionDic[kIndexSection] as! Int)!
//        let sectionDic = sections[section] as! SectionModel
//        let sectionType = sectionDic.sectionType
//        switch sectionType {
//        case .IndexSection2:
//            let hv = tableView .dequeueReusableHeaderFooterView(withIdentifier: HomeSectionHeaderViewReuseIdentifier) as! HomeSectionHV
//            hv.configure(sectionDic)
//            return hv
        
//        default:
            return UIView.init()
//        }
    }
    
    // MARK: SectonFooter
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        let sectionDic = sections[section] as! Dictionary< String , Any?>
//        let sectionType:IndexSectionType = IndexSectionType(rawValue: sectionDic[kIndexSection] as! Int)!
        let sectionDic = sections[section] as! SectionModel
        let sectionType = sectionDic.sectionType
        switch sectionType {
        case .IndexSection1:
            return HomeSectionHV.viewHeightWithModel(2)//12
            
        default:
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let sectionDic = sections[section] as! Dictionary< String , Any?>
//        let sectionType:IndexSectionType = IndexSectionType(rawValue: sectionDic[kIndexSection] as! Int)!
        let sectionDic = sections[section] as! SectionModel
        let sectionType = sectionDic.sectionType
        switch sectionType {
        case .IndexSection1:
            let hv = tableView .dequeueReusableHeaderFooterView(withIdentifier: HomeSectionHeaderViewReuseIdentifier) as! HomeSectionHV
            hv.tag = section
            hv.configure(sectionDic)
            hv.actionBlock { (any,any1) in
//                let item = any as! SectionModel
//                print(item)
//                let item1 = any1 as! UIButton
//                item1.rotateAnimation((self.sections[section] as! SectionModel).collapsed! ? 0.0 : .pi / 2)
//                self.unfoldButtonDidTouch(hv,item1)
//                CollapsibleVC.pushFromVC(rootVC: self, requestParams: 1, block: { (any) in
//                    
//                });
            }
//            let v = UIView.init()
//            v.backgroundColor = UIColor(0xf6f5fa)
            return hv
            
        default:
            return UIView.init()
        }
    }
    
    func unfoldButtonDidTouch(_ sender: AnyObject,_ sender1: UIButton) {
        //section1 FV刷新section2数据
        //section1 FV 的arrow要改变
        let section = sender.tag + 1
        
        var temporaryVariable = (sections[section] as! SectionModel)

        let collapsed = temporaryVariable.collapsed
        
        //MARK: 点击后改变状态
        temporaryVariable.collapsed = !collapsed!
        
        (sections[section]) = temporaryVariable
        
        
        var temporaryVariable1 = (sections[sender.tag] as! SectionModel)

        let collapsed1 = temporaryVariable1.collapsed


        temporaryVariable1.collapsed = !collapsed1!

        (sections[sender.tag]) = temporaryVariable1
        
//        sender1.rotateAnimation(temporaryVariable.collapsed ? -.pi / 2 : 0.0)
        
        //MARK: 重载Section数据
        let myRange: CountableClosedRange = sender.tag...section
        tableView.reloadSections(IndexSet(integersIn: myRange), with: .automatic)
//        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
//        tableView.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
    }
    
    //MARK: SwipeableCell操作
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var section:NSInteger = indexPath.section;
        if section >= sections.count {
            section = sections.count - 1
        }
        let sectionDic = sections[section] as! SectionModel
        let sectionType = sectionDic.sectionType
        let rows = sectionDic.rowItems
        let itemData = rows[indexPath.row]
        switch sectionType {
        case .IndexSection2:
            
        
        let like = UITableViewRowAction(style: .normal, title: "喜欢") { action, index in
            print("You have tapped like button")
            
        }
        like.backgroundColor = UIColor.red
        
        let chat = UITableViewRowAction(style:.normal, title: "聊聊") { action, index in
            print("You have tapped chat button")
        }
        chat.backgroundColor = UIColor.blue
        
        let share = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "分享") { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            
            let activityItem = itemData as! HomeItem
            let imgUrl = URL.init(string: activityItem.cover)
            let data : NSData! = NSData(contentsOf: imgUrl!)
            let image = UIImage.init(data: data as Data, scale: 1)
            
            let activityViewController = UIActivityViewController(activityItems: [image as Any], applicationActivities: nil)
            
            self.present(activityViewController, animated: true, completion: nil)
            
        }
        share.backgroundColor = UIColor.brown
        
        return [share,chat,like]
        default:
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: Cell渐变动画
    func colorforIndex(indexRow: Int,totalRows: Int) -> UIColor {
        let color = (CGFloat(indexRow) / CGFloat(totalRows)) * 0.7
        return UIColor(red: color, green: 0.5, blue: 1.0, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var section:NSInteger = indexPath.section;
        if section >= sections.count {
            section = sections.count - 1
        }
        let sectionDic = sections[section] as! SectionModel
        let sectionType = sectionDic.sectionType
        let rows = sectionDic.rowItems
//        let itemData = rows[indexPath.row]
        switch sectionType {
        case .IndexSection2:
            cell.backgroundColor =  colorforIndex(indexRow:indexPath.row,totalRows:rows.count-1)
            cell.layer.transform = CATransform3DMakeScale(0.5, 1.0, 1.0)
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                cell.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            })
        default:break
        }
    }
}
