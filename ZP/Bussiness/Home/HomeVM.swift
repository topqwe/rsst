//
//  HomeVM.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
import Moya

class  HomeVM: NSObject {
//    var homeItems:[HomeItem] //这样初始化要跟上否则就下面这样写
    
    var sections = [Any]()
    var model: HomeModel?//结构体不用

    
    
    func loadData(page: NSInteger,requestParams:Array<Any>, success: @escaping ((Any) -> Void), failure: ((Int?, String) ->Void)? ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0)
        {
            
//            let a = AB()
//            let b = a
//            b.val = 2
//            print(a.val)//struct AB =1 //class AB =2
            
            self.sections = [Any]()
        ApiRequest.loadData(target: ApiManger.rankList, cache: true, success: { (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(BannerModel.self, from: json )
            
            self.assembleBanners(banners: (model?.data.returnData?.rankinglist)!, page: page)
            success(self.sections)
            
        }, failure: nil)
            
        
        ApiRequest.loadData(target: ApiManger.getAppendRankList(""), cache: true, success: { (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(GridModel.self, from: json )

            self.assembleGrids(grids: (model?.data.returnData?.rankinglist)!, page: page)
            success(self.sections)

        }, failure: nil)
        
//            ApiRequest.loadData(target: ApiManger.getAppendRankList(""), cache: true, cacheHandle: { (json) in
//                let decoder = JSONDecoder()
//                let model = try? decoder.decode(GridModel.self, from: json )
//
//                self.assembleGrids(grids: (model?.data.returnData?.rankinglist)!, page: page)
//                success(self.sections)
//            }, success: { (json) in
//                let decoder = JSONDecoder()
//                let model = try? decoder.decode(GridModel.self, from: json )
//
//                self.assembleGrids(grids: (model?.data.returnData?.rankinglist)!, page: page)
//                success(self.sections)
//            }, failure: nil)
            
        ApiRequest.loadData(target: ApiManger.postParamsRankList(param:String(page), param2: requestParams[0] as! String), cache: true, success: { (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeModel.self, from: json )
            
            self.assembleList(list: (model?.data.returnData?.rankinglist)!, page: page)
            success(self.sections)
            
        }, failure: { (code, message) in
            failure!(code,message)
        })//failure {} = nil
        
        }
    }
}

// MARK:- AssembleDatas
extension HomeVM {
    
    func assembleBanners(banners:Array<Any>,page:NSInteger) {
        removeContentWithType(type:IndexSectionType.IndexSection0)
        if page == 1 && !banners.isEmpty {
//            sections.append([
//                kIndexSection : IndexSectionType.IndexSection0.rawValue,
//                kIndexRow : [[kArr : banners,
//                              kTip : "Banners"
//                            ]]
//                ])
            sections.append(SectionModel(sectionType: IndexSectionType.IndexSection0, sectionInfo: "Banners", rowItems: [banners]))
        }
        sortData()
    }
    
    func assembleGrids(grids:Array<Any>,page:NSInteger) {
        removeContentWithType(type:IndexSectionType.IndexSection1)
        if page == 1 && !grids.isEmpty {
//            sections.append([
//                kIndexSection : IndexSectionType.IndexSection1.rawValue,
//                kIndexInfo:["section1","1st section footer for 2rd section appendData"],
//                kIndexRow : [grids]
//                ])
           sections.append(SectionModel(sectionType: IndexSectionType.IndexSection1, sectionInfo: ["section1","1st section footer for 2rd section appendData"], rowItems: [grids]))
        }
        sortData()
    }
    
    func assembleList(list:Array<Any>,page:NSInteger) {
        removeContentWithType(type:IndexSectionType.IndexSection2)
//        if page == 1 {
        if !list.isEmpty {//
//            sections.append([
//                kIndexSection : IndexSectionType.IndexSection2.rawValue,
//                kIndexRow : list
//                ])
        sections.append(SectionModel(sectionType: IndexSectionType.IndexSection2, sectionInfo: "", rowItems: list))
        }
        sortData()
    }
    
}
// MARK:- 列表排序删除
extension HomeVM {
    func sortData() {
//        sections.sort { (obj1:Any?, obj2:Any?) -> Bool in
//
////            let mi1 = obj1 as! Dictionary< String , Any?>
////            let int1 = mi1[kIndexSection] as! Int
////
////            let mi2 = obj2 as! Dictionary< String , Any?>
////            let int2 = mi2[kIndexSection] as! Int
//            let mi1 = obj1 as! SectionModel
//            let int1 = mi1.sectionType
//
//            let mi2 = obj2 as! SectionModel
//            let int2 = mi2.sectionType
//
//
//            return int1.rawValue < int2.rawValue
//        }
        
        sections.sort(by: {
            ($0 as! SectionModel).sectionType.rawValue <
            ($1 as! SectionModel).sectionType.rawValue
        })
    }
    
    func removeContentWithType(type:IndexSectionType) {
        for (index, value) in sections.enumerated() {

//            let mi1 = value as! Dictionary< String , Any?>
//            let int1 = mi1[kIndexSection] as! Int

            let mi1 = value as! SectionModel
            let int1 = mi1.sectionType
            
            if int1.rawValue == type.rawValue {
                sections.remove(at: index)
//                with(sections){$0.remove(at: index)}
            }
        }
        
    }
}
