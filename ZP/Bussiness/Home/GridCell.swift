//
//  HomeCell.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
import Kingfisher
private let GridCollectionViewCellId = "GridCollectionViewCellId"
let kGridCellHeight : CGFloat = 100

class GridCell:UITableViewCell {
    // !!!:- just_dequeueReusableCell 不能用了/只能用传统的或class cellWithTableView
    var dataBlock:DataBlock?
    private var selectedIndexPath:IndexPath?
    
    private lazy var datas = [Any?]()
    
    private var collectionView:UICollectionView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.white
        backgroundView = UIView.init()
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func cellWith(_ tabelView:UITableView) -> UITableViewCell {
        var cell:UITableViewCell? = tabelView.dequeueReusableCell(withIdentifier: "GridCell")
        if cell == nil {
            cell = GridCell.init(style: .default, reuseIdentifier: "GridCell")
        }
        return cell!
    }
    
    func configure(_ item: Array<Any>, block:@escaping DataBlock){
        datas = item;
        
        collectionView?.snp.updateConstraints({ (make) in
       
            make.height.equalTo(GridCell.cellHeightWithModel(item))
        })
        collectionView?.reloadData()
        self.dataBlock = block
    }
    
    class func cellHeightWithModel(_ item: Array<Any>) -> Int {
        return (item.count%4 == 0 ? item.count/4:item.count/4+1)*Int(kGridCellHeight)
    }
}

//遵循协议(用扩展方式分类出来)
extension GridCell: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCellId, for: indexPath)
        cell!.tag = indexPath.row
        
        if (cell != nil) {
            let icon:UIButton = UIButton.init()
            icon.isUserInteractionEnabled = false
            icon.tag = 7001;
            icon.backgroundColor = UIColor.white
            cell!.contentView.addSubview(icon)
            icon.snp.makeConstraints({ (make) in
               make.top.equalTo(15);
                make.centerX.equalTo(cell!.contentView);
                make.width.height.equalTo(44);
            })
            
            let title:UILabel = UILabel.init()
            title.tag = 7003
            cell!.contentView.addSubview(title)
            title.snp.makeConstraints({ (make) in
                make.top.equalTo(icon.snp.bottom).offset(5);
               make.centerX.equalTo(cell!.contentView);
               make.left.equalTo(3);
               make.bottom.equalTo(cell!.contentView);
            })
            title.backgroundColor = UIColor.white
            title.textAlignment = .center
            title.font = UIFont.systemFont(ofSize: 13)
            title.textColor = UIColor(0x202020)
            
//            let shadowPath = UIBezierPath.init(rect: icon.bounds)
//            icon.layer.masksToBounds = false
            icon.layer.shadowColor = UIColor.clear.cgColor
            icon.layer.shadowOpacity = 0.25
            icon.layer.shadowRadius = 3
//            icon.layer.shadowPath = shadowPath.cgPath
            icon.layer.shadowOffset = CGSize(width: 10, height: 5)
            // shadow on the bottom right
        }
        
        
        let data = datas[indexPath.row] as! GridItem
        let icon = cell!.contentView.viewWithTag(7001) as! UIButton
        icon.contentMode = .scaleAspectFill
//        icon.clipsToBounds = true
        icon.kf.setBackgroundImage(with:URL.init(string: ""), for: .normal, placeholder: UIImage.init(named: "defaultphoto"), options: nil, progressBlock: nil)//data.cover
        //    [icon setImageWithURL:URLFromString(@"icon") placeholderImage:kSQUARE_PLACEDHOLDER_IMG options:SDWebImageRetryFailed];
        
        let title = cell!.contentView.viewWithTag(7003) as! UILabel
        title.text = "🍎"+data.title
        if (selectedIndexPath != nil) {
            if (selectedIndexPath == indexPath) {
                title.textColor = UIColor.red
                icon.layer.shadowColor = UIColor.black.cgColor
            }else{
                title.textColor = UIColor(0x202020)
                icon.layer.shadowColor = UIColor.clear.cgColor
            }
        }else{
            if cell!.tag == 0 {
                title.textColor = UIColor.red
                icon.layer.shadowColor = UIColor.black.cgColor
            }
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = datas[indexPath.row] as! GridItem
        
        if (selectedIndexPath != nil) {
            let cell:UICollectionViewCell = collectionView.cellForItem(at:selectedIndexPath!)!
            let title = cell.contentView.viewWithTag(7003) as! UILabel
            title.textColor = UIColor(0x202020)
            let icon = cell.contentView.viewWithTag(7001) as! UIButton
            icon.layer.shadowColor = UIColor.clear.cgColor
        }
        let cell:UICollectionViewCell = collectionView.cellForItem(at:indexPath)!
        let title = cell.contentView.viewWithTag(7003) as! UILabel
        title.textColor = UIColor.red
        let icon = cell.contentView.viewWithTag(7001) as! UIButton
        icon.layer.shadowColor = UIColor.black.cgColor
        
        if (indexPath.row != 0) {
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell:UICollectionViewCell = collectionView.cellForItem(at:indexPath)!
            let title = cell.contentView.viewWithTag(7003) as! UILabel
            title.textColor = UIColor(0x202020)
            let icon = cell.contentView.viewWithTag(7001) as! UIButton
            icon.layer.shadowColor = UIColor.clear.cgColor
        }
        
        selectedIndexPath = indexPath

        if self.dataBlock != nil {
            self.dataBlock!(item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4, height: kGridCellHeight)
    }
}
extension GridCell{
    fileprivate func setUp() {
        if (collectionView  != nil) {
            collectionView!.removeFromSuperview()
            collectionView = nil
        }
        
        let layout = UICollectionViewFlowLayout()
        //        layout.scrollDirection = UICollectionViewScrollDirectionVertical
        
        //水平分item，还是竖直分item
        //设置第一个cell和最后一个cell,与父控件之间的间距
        layout.sectionInset = UIEdgeInsets(top: 0, left:0,bottom:0,right:0)
        //设置cell行、列的间距
        layout.minimumLineSpacing = 0//row5 -10
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame:self.contentView.bounds,collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.isScrollEnabled = false
        //如果row = 5
        //        collectionView.isScrollEnabled = true;
        //        collectionView.alwaysBounceHorizontal = true
        //        collectionView.showsHorizontalScrollIndicator = true
        //        collectionView.contentSize =
        //        CGSize(width:collectionView.frame.width*5 / 4, height:kGridCellHeight)
        
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: GridCollectionViewCellId)
//        return collectionView
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}
