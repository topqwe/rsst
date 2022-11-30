//
//  CheckmarkModel.swift
//  RS
//
//  Created by Aalto on 2020/3/25.
//  Copyright © 2020 aa. All rights reserved.
//

import UIKit

// MARK:- 接口数据结构
struct CheckmarkModel: Codable {
    var code: TStrInt
    var data: CheckmarkData
    
    struct CheckmarkData: Codable {
        var stateCode: TStrInt
        var message: String
        var returnData: CheckmarkReturnData?
    }
    
    struct CheckmarkReturnData: Codable {
        var rankinglist: [CheckmarkItem]?
    }
    
}

struct CheckmarkItem: Codable {
    var title: String
    var isChecked = false
//    var subTitle: String
    var cover: String
//    var argName: String
//    var argValue: String
//    var rankingType: String
    
    init(title: String, isChecked: Bool, cover: String) {
        self.title = title
        self.isChecked = isChecked
        self.cover = cover
    }
}

extension CheckmarkItem: TextPresentable {
    var text: String { return String("🍎") + self.title }
    var textColor: UIColor { return .darkText }
    var font: UIFont { return .preferredFont(forTextStyle: UIFont.TextStyle.headline) }
}

extension CheckmarkItem: SwitchPresentable {
    var isSwitchTurnedOn: Bool  { return self.isChecked }
    var switchColor: UIColor { return .yellow }
    
    func onSwitchToggleOn(on: Bool) {
        if on {
            print("The Minions are here to stay!")
        } else {
            print("The Minions went out to play!")
        }
    }
}

extension CheckmarkItem: ImagePresentable {
    var imageUrl: URL {
        return URL(string: self.cover)!
    }
}

