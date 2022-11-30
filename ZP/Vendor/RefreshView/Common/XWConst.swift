//
//  XWConst.swift
//  XWRefresh
//
//  Created by Aalto on 12/1/17.
//  Copyright © 2017年 AaltoChen. All rights reserved.



import UIKit

let XWRefreshLabelTextColor = xwColor(r: 100, g: 100, b: 100)
let XWRefreshLabelFont = UIFont.boldSystemFont(ofSize: 13)
let XWRefreshHeaderHeight:CGFloat = 64
let XWRefreshFooterHeight:CGFloat = 44
let XWRefreshGifViewWidthDeviation:CGFloat = 99
let XWRefreshFooterActivityViewDeviation:CGFloat = 100
let XWRefreshFastAnimationDuration = 0.25
let XWRefreshSlowAnimationDuration = 0.4
let XWRefreshHeaderLastUpdatedTimeKey = "XWRefreshHeaderLastUpdatedTimeKey"
let XWRefreshKeyPathContentOffset = "contentOffset"
let XWRefreshKeyPathContentSize = "contentSize"
let XWRefreshKeyPathContentInset = "contentInset"
let XWRefreshKeyPathPanKeyPathState = "state"
//let XWRefreshHeaderStateIdleText = "Pull to refresh"
//let XWRefreshHeaderStatePullingText = "Release to refresh"
//let XWRefreshHeaderStateRefreshingText = "Loading ..."
let XWRefreshHeaderStateIdleText = "下拉可以刷新"
let XWRefreshHeaderStatePullingText = "松开立即刷新"
let XWRefreshHeaderStateRefreshingText = "正在刷新数据中..."


let XWRefreshFooterStateIdleText = "点击加载更多"
let XWRefreshFooterStateRefreshingText = "正在加载更多的数据..."
let XWRefreshFooterStateNoMoreDataText = "已经全部加载完毕"

let XWIconSrcPath:String = "Frameworks/XWSwiftRefresh.framework/xw_icon.bundle/xw_down.png"
let XWIconLocalPath:String = "xw_icon.bundle/xw_down.png"


