//
//  HomeCell.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
import Kingfisher
class MyCell:UITableViewCell {
    // !!!:- just_dequeueReusableCell 不能用了/只能用传统的或class cellWithTableView
    private var btn = with(UIButton()){
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel!.font = UIFont.systemFont(ofSize: 13)
    }
    private var arrowBtn = with(UIButton()){
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel!.font = UIFont.systemFont(ofSize: 13)
        $0.contentHorizontalAlignment = .right
    }
    
    private var nameLabel = with(UILabel()){_ in
    }
    private var descriptionLabel = with(UILabel()){
        $0.numberOfLines = 2
    }
    
    override func draw(_ rect: CGRect) {
        super.drawLine(rect)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setUp()
    }
  
    func configure(_ item: Dictionary< String , String>, _ indexPath: IndexPath) {
//        self.delegate = delegate
        
        btn.isUserInteractionEnabled = false
//        btn.kf.setBackgroundImage(with:URL.init(string: ""), for: .normal, placeholder: UIImage.init(named: "defaultphoto"), options: nil, progressBlock: nil)//delegate.imageUrl
        //URL.init(string: "")
        btn.setImage(UIImage.init(named: item.keys.first!), for: .normal)
        btn.setTitle(item.values.first, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.layoutButtonWithEdgeInsetsStyle(style: .MKButtonEdgeInsetsStyleLeft, space: 10)
        arrowBtn.isUserInteractionEnabled = false
        switch indexPath.section {
        case 2:
            switch indexPath.row {
                case 0:
                   arrowBtn.setImage(UIImage.init(named: ""), for: .normal)
                    let bv = Bundle.main.bundleVersion
                    arrowBtn.setTitle(bv, for: .normal)
                default:
                    arrowBtn.setImage(UIImage.init(named: "arrowIcon"), for: .normal)
                    arrowBtn.setTitle("", for: .normal)
            }
        default:
            arrowBtn.setImage(UIImage.init(named: "arrowIcon"), for: .normal)
            arrowBtn.setTitle("", for: .normal)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cellWith(_ tabelView:UITableView) -> UITableViewCell {
        var cell:UITableViewCell? = tabelView.dequeueReusableCell(withIdentifier: "MyCell")
        if cell == nil {
            cell = MyCell.init(style: .default, reuseIdentifier: "MyCell")
        }
        return cell!
    }
    
    class func cellHeightWithModel(_ item: Any) -> CGFloat {
        return 50
    }
}
extension MyCell{
    fileprivate func setUp() {
        self.contentView.addSubview(btn)
        self.contentView.addSubview(arrowBtn)
        setLayout()
    }
    private func setLayout() {
        arrowBtn.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-10)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(120)
            maker.height.equalTo(30)
        }
        btn.snp.makeConstraints { (maker) in
            maker.left.top.equalToSuperview().offset(10)
            maker.bottom.equalToSuperview().offset(-10)
            maker.right.equalTo(arrowBtn.snp.left).offset(-10)
            maker.height.equalTo(30)
        }
    }

}
