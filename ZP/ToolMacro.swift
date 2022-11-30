//
//  ToolMacro.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

// MARK: - 全局通知定义
let kNotify_IsLoginRefresh = "kNotify_IsLoginRefresh"

// MARK: - 常量
let kIsLogin = "kIsLogin"
let kUserInfo = "kUserInfo"
let kUserToken = "kUserToken"
let kUserName = "kUserName"

let kIndexSection = "kIndexSection";
let kIndexInfo = "kIndexInfo";
let kIndexRow = "kIndexRow";

let kType = "kType";
let kIsOn = "kIsOn";
let kImg = "kImg";
let kTip = "kTip";
let kSubTip = "kSubTip";
let kUrl = "kUrl";
let kArr = "kArr";
let kData = "kData";

// MARK: - 共用枚举
enum IndexSectionType:Int {
    case IndexSection0
    case IndexSection1
    case IndexSection2
    case IndexSection3
    case IndexSection4
    case IndexSection5
}

enum EnumActionTag:Int {
    case EnumActionTag0
    case EnumActionTag1
    case EnumActionTag2
    case EnumActionTag3
    case EnumActionTag4
    case EnumActionTag5
}

// MARK: - Block
typealias DataBlock = (_ anyData:Any) -> Void
typealias TwoDataBlock = (_ anyData:Any,_ anyData2:Any) -> Void
typealias TableViewDataBlock = (_ anyData:Any,_ anyData2:Any,_ view:UIView,_ tableView:UITableView,_ dataSource:[Any],_ indexPath:NSIndexPath) -> Void
// MARK: -

