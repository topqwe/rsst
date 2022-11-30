//
//  HomeCell.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
import Kingfisher

let HomeSectionHeaderViewReuseIdentifier = "HomeSectionHeaderViewReuseIdentifier"
let kHeightForHeaderInSections:CGFloat  = 56

class HomeSectionHV:UITableViewHeaderFooterView {
    private var block :TwoDataBlock?
    private var sectionDic :SectionModel!
    
    private var btn = with(UIButton()){_ in
    }
    
    private var sectionLineView = with(UIImageView()) {
        $0.backgroundColor = UIColor(0xf6f5fa)
    }
    
    private var nameLabel = with(UILabel()){
        $0.numberOfLines = 2
    }
    
    private var arrowBtn = with(UIButton()) {
        $0.isUserInteractionEnabled = false
//        $0.setImage(UIImage(named: "arrowIcon"), for: .normal)
        $0.setTitle(">", for: .normal)
        $0.titleLabel!.font = UIFont.systemFont(ofSize: 13)
        $0.setTitleColor(UIColor.black, for: .normal)
    }
    
    private var descriptionLabel = with(UILabel()){
        $0.numberOfLines = 2
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white;
        backgroundView = UIView.init()
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.MAINSCREEN_WIDTH(), height: kHeightForHeaderInSections)
        
        setUp()
        
        contentView.isUserInteractionEnabled = true
        let tapGes:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        contentView.addGestureRecognizer(tapGes)
    }

    func configure(_ item: Any?) {
//        nameLabel.text = (item[0] as! String)
//        descriptionLabel.text = (item[1] as! String)
        
//        let sectionDic = item as! Dictionary< String , Any?>
//        let sectionType:IndexSectionType = IndexSectionType(rawValue: sectionDic[kIndexSection] as! Int)!
        sectionDic = (item as! SectionModel)
        let sectionType = sectionDic.sectionType
        switch sectionType {
        case .IndexSection1:
            let arr = sectionDic.sectionInfo as! [Any]
            btn.titleLabel?.text = (arr[0] as! String)
            btn.kf.setBackgroundImage(with:URL.init(string: ""), for: .normal, placeholder: UIImage.init(named: "defaultphoto"), options: nil, progressBlock: nil)//data.cover
            btn.layoutButtonWithEdgeInsetsStyle(style: .MKButtonEdgeInsetsStyleLeft, space: 5)
            nameLabel.text = (arr[1] as! String)
//            arrowBtn.rotateAnimation(0.0)
            arrowBtn.rotateAnimation(sectionDic.collapsed! ? 0.0:  .pi/2)
            arrowBtn.isHidden = true
        default: break
            
        }
    }
    func configureCollapsibleHV(_ item: Any?) {
        //        nameLabel.text = (item[0] as! String)
        //        descriptionLabel.text = (item[1] as! String)
        
        //        let sectionDic = item as! Dictionary< String , Any?>
        //        let sectionType:IndexSectionType = IndexSectionType(rawValue: sectionDic[kIndexSection] as! Int)!
        sectionDic = (item as! SectionModel)
        let sectionType = sectionDic.sectionType
//        switch sectionType {
//        case .IndexSection1:
            let arr = sectionDic.sectionInfo as! [Any]
            btn.titleLabel?.text = (arr[0] as! String)
            btn.kf.setBackgroundImage(with:URL.init(string: ""), for: .normal, placeholder: UIImage.init(named: "defaultphoto"), options: nil, progressBlock: nil)//data.cover
            btn.layoutButtonWithEdgeInsetsStyle(style: .MKButtonEdgeInsetsStyleLeft, space: 5)
            nameLabel.text = (arr[1] as! String)
            //arrowBtn.rotateAnimation(0.0)
            arrowBtn.tag = sectionType.rawValue
            arrowBtn.rotateAnimation(sectionDic.collapsed! ? 0.0:  .pi/2)
//            break
//        default: break
//
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func sectionHeaderViewWith(_ tabelView:UITableView)  {
        tabelView .register(HomeSectionHV.classForCoder(), forHeaderFooterViewReuseIdentifier: HomeSectionHeaderViewReuseIdentifier)
    }
    
    class func viewHeightWithModel(_ item: Any) -> CGFloat {
        return kHeightForHeaderInSections
    }
}
// MARK: - Target Action
extension HomeSectionHV{
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let _ = self.block else {
                return
            }
            self.block!(sectionDic as Any, arrowBtn)
        }
    }
    func actionBlock(block:@escaping TwoDataBlock){
        self.block = block
    }
}
extension HomeSectionHV{
    fileprivate func setUp() {
        contentView.addSubview(sectionLineView)
        contentView.addSubview(btn)
        contentView.addSubview(nameLabel)
        contentView.addSubview(arrowBtn)
        contentView.addSubview(descriptionLabel)
        setLayout()
    }
    
    private func setLayout() {
        sectionLineView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.bottom.equalToSuperview().offset(-1)
            maker.height.equalTo(0.5)
        }
        
        btn.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(10)
//            maker.bottom.equalToSuperview().offset(-10)
            maker.width.equalTo(50)
            maker.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(btn.snp.right).offset(10)
            maker.right.equalToSuperview().offset(-40)
            maker.centerY.equalToSuperview()
        }
        
        arrowBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview().offset(-10)
            //            maker.bottom.equalToSuperview().offset(-10)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
        }
        descriptionLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(btn.snp.right).offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.bottom.equalTo(btn).offset(-10)
        }
    }

}
