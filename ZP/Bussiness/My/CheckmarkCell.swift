//
//  CheckmarkCell.swift
//  RS
//
//  Created by Aalto on 2020/3/25.
//  Copyright © 2020 aa. All rights reserved.
//

import UIKit
import Kingfisher
class CheckmarkCell<T>:UITableViewCell  where T: TextPresentable, T: SwitchPresentable,T:ImagePresentable {//, T: IndexPathPresentable
    // !!!:- just_dequeueReusableCell 不能用了/只能用传统的或class cellWithTableView
    private var delegate: T?
    
//    private var btn: UIButton = {
//        let btn = UIButton.init()
//        return btn
//    }()
    private var btn = with(UIButton()){_ in 
    }
    private var nameLabel = with(UILabel()){_ in
    }
    private var descriptionLabel = with(UILabel()){
        $0.numberOfLines = 2
    }
    
    private var checkSwitch = with(UISwitch()){_ in
    }
    
    override func draw(_ rect: CGRect) {
        super.drawLine(rect)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setUp()
    }
    
    func configure(withDelegate delegate: T) {
//        self.delegate = delegate
        nameLabel.text = delegate.text
        nameLabel.textColor = delegate.textColor
        nameLabel.font = delegate.font
        
        btn.isUserInteractionEnabled = false
        btn.kf.setBackgroundImage(with:URL.init(string: ""), for: .normal, placeholder: UIImage.init(named: delegate.imageName), options: nil, progressBlock: nil)//delegate.imageUrl
        //URL.init(string: "")
        
        
        checkSwitch.isOn = delegate.isSwitchTurnedOn
        
        self.accessoryType =
        delegate.isSwitchTurnedOn ? .checkmark : .none
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cellWith(_ tabelView:UITableView) -> UITableViewCell {
        var cell:UITableViewCell? = tabelView.dequeueReusableCell(withIdentifier: "CheckmarkCell")
        if cell == nil {
            cell = CheckmarkCell.init(style: .default, reuseIdentifier: "CheckmarkCell")
        }
        return cell!
    }
    
    func richElementsInCellWithModel(_ item: Array<Any>) {
        nameLabel.text = (item[0] as! String)
        descriptionLabel.text = (item[1] as! String)
    }
    
    class func cellHeightWithModel(_ item: Any) -> CGFloat {
        return 120
    }
}
extension CheckmarkCell{
    fileprivate func setUp() {
        self.contentView.addSubview(btn)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(checkSwitch)
        setLayout()
    }
    private func setLayout() {
        btn.snp.makeConstraints { (maker) in
            maker.left.top.equalToSuperview().offset(10)
            maker.bottom.equalToSuperview().offset(-10)
            maker.width.equalTo(130)
            maker.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(btn.snp.right).offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.top.equalTo(btn).offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(btn.snp.right).offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.bottom.equalTo(btn).offset(-10)
        }
        
        checkSwitch.snp.makeConstraints { (maker) in
//            maker.left.equalTo(btn.snp.right).offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.centerY.equalTo(btn)
        }
    }

}
