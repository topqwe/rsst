//
//  HomeCell.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

class BannerCell:UITableViewCell  {
    // !!!:- just_dequeueReusableCell 不能用了/只能用传统的或class cellWithTableView
    var dataBlock:DataBlock?
    private var cycleScrollView: CycleScrollView = {
        let cycleScrollView = CycleScrollView(frame: CGRect(x: 0 , y: 0 , width:UIScreen.MAINSCREEN_WIDTH() , height: BannerCell.cellHeightWithModel(1)))
        return cycleScrollView
    }()
    
    
    override func draw(_ rect: CGRect) {
        super.drawLine(rect)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setUp()
    }
    
    func configure(_ items: Array<Any>, block:@escaping DataBlock) {
        self.dataBlock = block
        var imageURLStrings:Array<String> = []
        var imageTitles:Array<String> = []
        
        if !items.isEmpty&&items.count>0 {
            for index in 0..<items.count {
                let data = items[index] as! BannerItem
                imageURLStrings.append(data.cover)
                imageTitles.append(data.subTitle)
            }
//            cycleScrollView.imageStrs = imageURLStrings
//            cycleScrollView.titles = imageTitles
            cycleScrollView.scrollInterval = 3.0
            cycleScrollView.actionBlock { (index) in
                let item = items[index as! Int] as! BannerItem
                if self.dataBlock != nil {
                    self.dataBlock!(item)
                }
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cellWith(_ tabelView:UITableView) -> UITableViewCell {
        var cell:UITableViewCell? = tabelView.dequeueReusableCell(withIdentifier: "BannerCell")
        if cell == nil {
            cell = BannerCell.init(style: .default, reuseIdentifier: "BannerCell")
        }
        return cell!
    }
    
    class func cellHeightWithModel(_ item: Any) -> CGFloat {
        return 120
    }
}
extension BannerCell{
    fileprivate func setUp() {
        self.contentView.addSubview(cycleScrollView)
    }
    

}
