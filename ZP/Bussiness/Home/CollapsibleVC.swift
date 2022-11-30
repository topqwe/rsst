//
//  HomeVC.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

// MARK:- class 方法
extension CollapsibleVC {
    static func  pushFromVC(rootVC:UIViewController,requestParams:Any,block:@escaping DataBlock) ->  Void{
        let vc  : CollapsibleVC = CollapsibleVC.init()
        vc.successBlock = block
        vc.requestParams = requestParams
        rootVC.navigationController?.pushViewController(vc, animated: true)
    }
}
class CollapsibleVC: BaseVC {
    
    var vm: HomeVM = {
       let vm = HomeVM()
        return vm
    }()

    var successBlock: DataBlock?
    var requestParams :Any?
    
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
        HomeSectionHV.sectionHeaderViewWith(tableView)
//        tableView.registerReusableCell(HomeCell<HomeItem>.self)
//        tableView.register(HomeCell<HomeItem>.self, forCellReuseIdentifier: HomeCellId)
        return tableView
    }()
}

// MARK: - View生命周期
extension CollapsibleVC {
    override func viewDidLoad() {
        setup()
        setRefresh()
        tableView.headerView?.beginRefreshing()
//        requestDatas()
        
    }
}

// MARK: - 请求数据
extension CollapsibleVC {
    // MARK: fileprivate暴露内部接口,
    fileprivate func requestDatas() {
        vm.loadData(page:currentPage, requestParams: ["20"], success: { (model) in
            
            let model = [
                SectionModel(sectionType: IndexSectionType.IndexSection0,sectionInfo: ["","Farrari"], rowItems: ["LaFerrari", "Enzo", "F40", "F50", "288GTO", "FXX K","FXX"]),
                SectionModel(sectionType: IndexSectionType.IndexSection1,sectionInfo: ["","Lamborghini"], rowItems: ["Aventador", "Reventon", "Huracan", "Gallardo", "Sesto Elemento", "Veneno", "Centenario", "Diablo"]),
                SectionModel(sectionType: IndexSectionType.IndexSection2,sectionInfo: ["","Aston Martin"], rowItems: ["One-77", "Vanquish", "Vulcan", "Vantage", "Rapide", "DBS", "DB11"]),
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
private typealias ViewStylingHelpers = CollapsibleVC
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
    }
}

// MARK:- 上下刷新功能
extension CollapsibleVC {
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
private typealias TableViewDataSource = CollapsibleVC
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
        let sectionDic = sections[section] 
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
        let sectionDic = sections[section] 
        let sectionType = sectionDic.sectionType
        let rows = sectionDic.rowItems
        let itemData = rows[indexPath.row]
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = (sections[indexPath.section].rowItems[indexPath.row] as! String)
        
        return cell!
        
//        switch sectionType {
//        case .IndexSection0:
//            let cell = BannerCell.cellWith(tableView) as! BannerCell
//            let arr = itemData as! [BannerItem]
//            cell.configure(arr, block: { (anyData) in
//                print(anyData)
//            })
//            return cell
//
//        case .IndexSection1:
//            let cell = GridCell.cellWith(tableView) as! GridCell
//            let arr = itemData as! [GridItem]
//            cell.configure(arr, block: { (anyData) in
//                print(anyData)
//                })
//            return cell
//
//        case .IndexSection2:
//            //        let cell:HomeCell = HomeCell.cellWith(tableView) as! HomeCell
//
//            let cell = HomeCell<HomeItem>.cellWith(tableView) as! HomeCell<HomeItem>
//
//            //        let cell = tableView.dequeueReusableCell(indexPath: indexPath as NSIndexPath) as! HomeCell<HomeItem>
//            //        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCellId, for: indexPath) as! HomeCell<HomeItem>
//
//            let HomeItem = itemData as! HomeItem
//            //        cell.richElementsInCellWithModel([HomeItem.header,HomeItem.title[0]])
//
//            //        cell.configure(withDelegate: HomeVM())
//
//            //        let vm = HomeVM()
//            //        cell.configure(withDataSource: vm, delegate: vm)
//
//            //        cell.configure(withDelegate: HomeVM(header: exampleHeaderTitle00, title: ["默认"], methods: ["example001"]))
//            cell.configure(withDelegate: HomeItem)
//            return cell
//
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
//            return cell
//        }
//
    }
}

// MARK: - TableView Delegate
private typealias TableViewDataDelegate = CollapsibleVC
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
        let sectionDic = sections[section]
        let sectionType = sectionDic.sectionType
        let rows = sectionDic.rowItems
        let itemData = rows[indexPath.row]
        
        return 80
//        switch sectionType {
//        case .IndexSection0:
//            return BannerCell.cellHeightWithModel(1)
//
//        case .IndexSection1:
//            return kGridCellHeight
//
//        case .IndexSection2:
//            let example = itemData as! HomeItem
//            return HomeCell<HomeItem>.cellHeightWithModel(example)
//
//        default:
//            return 80
//        }
        
    }
    
    // MARK: SectonHeader
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let sectionDic = sections[section] as! Dictionary< String , Any?>
//        let sectionType:IndexSectionType = IndexSectionType(rawValue: sectionDic[kIndexSection] as! Int)!
//        let sectionDic = sections[section] as! SectionModel
//        let sectionType = sectionDic.sectionType
        
//        switch sectionType {
//        case .IndexSection2:
            return HomeSectionHV.viewHeightWithModel(2)
        
//        default:
//            return 0.1
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let sectionDic = sections[section] as! Dictionary< String , Any?>
//        let sectionType:IndexSectionType = IndexSectionType(rawValue: sectionDic[kIndexSection] as! Int)!
        let sectionDic = sections[section]
        let sectionType = sectionDic.sectionType
//        switch sectionType {
//        case .IndexSection2:
            let hv = tableView .dequeueReusableHeaderFooterView(withIdentifier: HomeSectionHeaderViewReuseIdentifier) as! HomeSectionHV
            hv.tag = section
            hv.configureCollapsibleHV(sectionDic)
        
            hv.actionBlock { (any,any1) in
//                let item = any as! SectionModel
//                print(item)
                let item1 = any1 as! UIButton
//                item1.rotateAnimation((self.sections[section] ).collapsed! ? 0.0 : .pi / 2)
                self.unfoldButtonDidTouch(hv,item1)
                
            }

            return hv
        
//        default:
//            return UIView.init()
//        }
    }
    
    // MARK: SectonFooter
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        let sectionDic = sections[section] as! Dictionary< String , Any?>
//        let sectionType:IndexSectionType = IndexSectionType(rawValue: sectionDic[kIndexSection] as! Int)!
        let sectionDic = sections[section]
        let sectionType = sectionDic.sectionType
//        switch sectionType {
//        case .IndexSection1:
//            return HomeSectionHV.viewHeightWithModel(2)//12
//
//        default:
//            return 0.1
//        }
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let sectionDic = sections[section] as! Dictionary< String , Any?>
//        let sectionType:IndexSectionType = IndexSectionType(rawValue: sectionDic[kIndexSection] as! Int)!
        let sectionDic = sections[section]
        let sectionType = sectionDic.sectionType
//        switch sectionType {
//        case .IndexSection1:
//            let hv = tableView .dequeueReusableHeaderFooterView(withIdentifier: HomeSectionHeaderViewReuseIdentifier) as! HomeSectionHV
//            hv.tag = section
//            hv.configure(sectionDic)
//            hv.actionBlock { (any,any1) in
//                let item = any as! SectionModel
//                print(item)
//                let item1 = any1 as! UIButton
//                item1.rotateAnimation((self.sections[section] as! SectionModel).collapsed! ? 0.0 : .pi / 2)
//                self.unfoldButtonDidTouch(hv,item1)
//                
//            }
//            let v = UIView.init()
//            v.backgroundColor = UIColor(0xf6f5fa)
//            return hv
//
//        default:
            return UIView.init()
//        }
    }
    
    func unfoldButtonDidTouch(_ sender: AnyObject,_ sender1: UIButton) {
        //section1 FV刷新section2数据
        //section1 FV 的arrow要改变
        let section = sender1.tag
        
        let collapsed = (sections[section]).collapsed
        
        //MARK: 点击后改变状态
        (sections[section]).collapsed = !collapsed!
        
        
        
//        var temporaryVariable1 = (sections[sender.tag] )
//
//        let collapsed1 = temporaryVariable1.collapsed
//
//
//        temporaryVariable1.collapsed = !collapsed1!
//
//        (sections[sender.tag]) = temporaryVariable1
//
        sender1.rotateAnimation((sections[section]).collapsed ? 0.0 :.pi / 2 )
        
        //MARK: 重载Section数据
//        let myRange: CountableClosedRange = sender.tag...section!
//        tableView.reloadSections(IndexSet(integersIn: myRange), with: .automatic)
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
//        tableView.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
    }
}
