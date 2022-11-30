//
//  HomeVM.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
/*
 在 MVVM 架构中使用协议
 
 使用协议来配置您的视图
 使用协议扩展来实现默认值——这就是您设置用在您应用当中的所有字体、颜色以及配置的地方。这里最大的障碍就是处理子类了；这就是人们为什么总是使用继承——因为需要在多个类当中使用相同的功能。
 使用视图模型来为协议提供数据。您使用视图模型的目的在于它们易于测试，并且变化带来的耦合度很小。您的视图控制器可以决定在最新版本的代码当中使用哪个版本的视图模型。
 */
/*
struct HomeItem: SwitchWithTextCellProtocol {
    //Type 'HomeItem' does not conform to protocol 'SwitchWithTextCellProtocol'
    //Do you want to add protocol stubs?
    var title = "Minion Mode!!!"
    var titleFont: UIFont {
        return .systemFont(ofSize: 13)
    }
    var titleColor: UIColor {可以不写，因为extension有个全局的
        return .green
    }
 
    var switchOn = true
    var switchColor: UIColor {
        return .yellow
    }
    
    func onSwitchToggleOn(on: Bool) {
        if on {
            print("The Minions are here to stay!")
        } else {
            print("The Minions went out to play!")
        }
    }
}
*/

/*
struct HomeItem: SwitchWithTextCellDataSource {
    //Type 'HomeItem' does not conform to protocol 'SwitchWithTextCellProtocol'
    //Do you want to add protocol stubs?
    var title = "Minion Mode!!!"
    
    var switchOn = true
    
}

extension HomeItem: SwitchWithTextCellDelegate {
    var titleFont: UIFont {
        return .systemFont(ofSize: 13)
    }
    var titleColor: UIColor {
        return .green
    }

    
    var switchColor: UIColor {
        return .yellow
    }
    
    func onSwitchToggleOn(on: Bool) {
        if on {
            print("The Minions are here to stay!")
        } else {
            print("The Minions went out to play!")
        }
    }
}
*/
class  AB {
    var val = 1
}
// MARK:- 计算封装数据结构
struct SectionModel {
    var sectionType:IndexSectionType
    var sectionInfo:Any
    
    var rowItems:[Any]
    var collapsed: Bool!
    
    //MARK: 构造器
    init(sectionType: IndexSectionType, sectionInfo: Any, rowItems: [Any]) {
        self.sectionType = sectionType
        self.sectionInfo = sectionInfo
        self.rowItems = rowItems
        self.collapsed = false
    }
    init(sectionType: IndexSectionType, sectionInfo: Any, rowItems: [Any], collapsed:Bool) {
        self.sectionType = sectionType
        self.sectionInfo = sectionInfo
        self.rowItems = rowItems
        self.collapsed = collapsed
    }
}

// MARK:- 接口数据结构
struct HomeModel: Codable {
    var code: TStrInt
    var data: HomeData
    
    struct HomeData: Codable {
        var stateCode: TStrInt
        var message: String
        var returnData: HomeReturnData?
    }
    
    struct HomeReturnData: Codable {
        var rankinglist: [HomeItem]?
    }
    
}

struct HomeItem: Codable {
    var title: String
    var subTitle: String
    var cover: String
    var argName: String
    var argValue: String
    var rankingType: String
}

extension HomeItem: TextPresentable {
    var text: String { return String("🍎🧧🍎🧧🍎🧧🍎") + self.title }
    var textColor: UIColor { return .darkText }
    var font: UIFont { return .preferredFont(forTextStyle: UIFont.TextStyle.headline) }
}

extension HomeItem: SwitchPresentable {
    var isSwitchTurnedOn: Bool { return false }
    var switchColor: UIColor { return .yellow }
    
    func onSwitchToggleOn(on: Bool) {
        if on {
            print("The Minions are here to stay!")
        } else {
            print("The Minions went out to play!")
        }
    }
}

extension HomeItem: ImagePresentable {
    var imageUrl: URL {
        return URL(string: self.cover)!
    }
}

// MARK:- Banners
struct BannerModel: Codable {
    var code: TStrInt
    var data: BannerData
    
    struct BannerData: Codable {
        var stateCode: TStrInt
        var message: String
        var returnData: BannerReturnData?
    }
    
    struct BannerReturnData: Codable {
        var rankinglist: [BannerItem]?
    }
    
}

struct BannerItem: Codable {
    var title: String
    var subTitle: String
    var cover: String
    var argName: String
    var argValue: String
    var rankingType: String
}

// MARK:- Grids
struct GridModel: Codable {
    var code: TStrInt
    var data: GridData
    
    struct GridData: Codable {
        var stateCode: TStrInt
        var message: String
        var returnData: GridReturnData?
    }
    
    struct GridReturnData: Codable {
        var rankinglist: [GridItem]?
    }
    
}

struct GridItem: Codable {
    var title: String
    var subTitle: String
    var cover: String
    var argName: String
    var argValue: String
    var rankingType: String
}
