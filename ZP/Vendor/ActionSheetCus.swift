//
//  ActionSheetCus.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit
typealias SelectDataBlock = (_ anyData:Array<Any>,_ selectIndex:Int) -> Void

@objc protocol ActionSheetDelegate:NSObjectProtocol{
    func actionSheetDelegate(actionSheet:ActionSheetCus,index:NSInteger)
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

class ActionSheetCus: UIView {
    @objc var selectDataBlock:SelectDataBlock?
    @objc var delegate:ActionSheetDelegate?
    
    private var dataArray:Array<Any>?
    private var originArrs:Array<Any>?
    
    private var isShowFliterTextFiled:Bool?
    private var inputTfString:String?
    
    // MARK: - lazy 私有控件
    private lazy var bgView = with(UIView()) {
        $0.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        let tapGes:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        $0.addGestureRecognizer(tapGes)
    }
    
    private lazy var containView = with(UIView()) {
        $0.backgroundColor = UIColor.white
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 9.0
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    }
    
    private lazy var barImageview  = with(UIImageView()) {
        $0 = UIImageView.init(image: UIImage.init(named: "navBarBg"))
    }
    
    private lazy var titleLabel = with(UILabel()) {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textAlignment = NSTextAlignment.center;
        $0.textColor = UIColor.green;
        $0.backgroundColor = UIColor.clear
    }
    
    private lazy var fliterTextFiled = with(UITextField()) {
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textAlignment = NSTextAlignment.center;
        $0.returnKeyType = UIReturnKeyType.search
        $0.borderStyle = UITextField.BorderStyle.roundedRect
        $0.clearButtonMode = .whileEditing
        $0.placeholder = "输入筛选";
        $0.textColor = UIColor.black;
        $0.backgroundColor = UIColor.white
        $0.delegate = self;
        $0.layer.masksToBounds = true;
        $0.layer.borderWidth = 1;
        $0.layer.borderColor = UIColor.gray.cgColor;
        $0.addTarget(self, action: #selector(textField1TextChange(_:)), for: .editingChanged)
    }
    private lazy var tableView = with(UITableView()) {
        $0.separatorStyle = UITableViewCell.SeparatorStyle.none
        $0.rowHeight = 46
        $0.backgroundColor = UIColor.clear
        $0.delegate = self
        $0.dataSource = self
    }
    // MARK: - design init方法
    init(array:Array<Any>,title:String) {
        self.originArrs = array + ["取消"]
        self.dataArray = array + ["取消"]
        let rect:CGRect = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        super.init(frame:rect)
        self.backgroundColor = UIColor.clear
        self.frame = rect
        
        setup()
        titleLabel.text = title;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 便利构造方法
    convenience init(array:Array<Any>,title:String,isShowFliterTextFiled:Bool) {
        self.init(array:array,title:title)
        self.isShowFliterTextFiled = isShowFliterTextFiled
        updateLayoutFliterTextField(isShowFliterTextField: self.isShowFliterTextFiled!)
    }
    
    private func updateLayoutFliterTextField(isShowFliterTextField: Bool) {
        if isShowFliterTextFiled == true {
            
            fliterTextFiled.snp.updateConstraints({ (make) in
                make.top.equalTo(self.titleLabel.snp.bottom).offset(3)
                make.height.equalTo(40)
            })
            
            tableView.snp.updateConstraints({ (make) in
                make.top.equalTo(self.fliterTextFiled.snp.bottom)
            })
            //
            setNeedsLayout()
            UIView.animate(withDuration: 0.3) { [weak self] in
                self!.layoutIfNeeded()
            }
        }
    }
    
    
    // MARK:- Animation
    @objc func showWithAnimation(ani:Bool){
        var window:UIWindow? = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal{
            let arr:NSArray = UIApplication.shared.windows as NSArray
            for index in arr{
                let win:UIWindow = index as! UIWindow
                if win.windowLevel == UIWindow.Level.normal{
                    window = win
                    break
                }
            }
        }
        if window == nil {
            return
        }
        window?.addSubview(self)
        if ani == true{
            bgView.alpha = 0.0
            containView.frame.origin.y = self.frame.size.height
            UIView.animate(withDuration: 0.3) {
                self.bgView.alpha = 1.0
                if self.isShowFliterTextFiled == true {
                    self.containView.frame.origin.y = (self.frame.size.height - self.containView.frame.size.height)/2
                    
                    return;
                }
                self.containView.frame.origin.y = self.frame.size.height - self.containView.frame.size.height - 8
                
            }
        }else{
            bgView.alpha = 1.0
            containView.frame.origin.y = self.frame.size.height - containView.frame.size.height - 8
        }
    }
    
    func hiddenWithAnimation(ani:Bool) {
        if ani == true{
            UIView.animate(withDuration: 0.3, animations: {
                self.bgView.alpha = 0.0
                self.containView.frame.origin.y = self.frame.size.height
            }) { (end:Bool) in
                self.delegate = nil
                self.removeFromSuperview()
            }
        }else{
            delegate = nil
            removeFromSuperview()
        }
    }
    
    // MARK: - Target Action
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            hiddenWithAnimation(ani: true)
        }
    }
    
}

// MARK: - Setup 初始化设置
extension ActionSheetCus {
    // MARK: fileprivate暴露内部接口,
    fileprivate func setup() {
        setupView()
        setupLayout()
    }
    // MARK: private内部实现
    private func setupView() {
        
    }
    private func setupLayout() {
        addSubview(bgView);
        bgView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        addSubview(bgView);
        bgView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        addSubview(containView);
        var height:NSInteger = 44 + (dataArray?.count ?? 0)! * 46
        if height < 90{
            height = 90
        }
        if height > NSInteger(self.frame.size.height - 100){
            height = NSInteger(self.frame.size.height - 100)
        }
        let width:NSInteger = NSInteger(self.frame.size.width - 60)
        containView.frame = CGRect.init(x: 30, y: height, width: width, height: height)
        
        
        containView.addSubview(barImageview)
        self.barImageview.snp.makeConstraints({ (make) in
            make.left.equalTo(self.containView)
            make.right.equalTo(self.containView)
            make.top.equalTo(self.containView)
            make.height.equalTo(44)
        })
        
        containView.addSubview(titleLabel);
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.containView)
            make.right.equalTo(self.containView)
            make.top.equalTo(self.containView)
            make.height.equalTo(44)
        })
        
        
        containView.addSubview(fliterTextFiled);
        fliterTextFiled.snp.makeConstraints({ (make) in
            make.left.equalTo(self.containView).offset(20)
            make.right.equalTo(self.containView).offset(-20)
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.height.equalTo(0)
        })
        
        containView.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.left.equalTo(self.containView)
            make.right.equalTo(self.containView)
            make.bottom.equalTo(self.containView)
            make.top.equalTo(self.fliterTextFiled.snp.bottom)
        })
    }
}

// MARK:- TableView DataSource
extension ActionSheetCus: UITableViewDataSource{
    // MARK: DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idef = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: idef)
        if cell == nil{
            cell = UITableViewCell(style:.default, reuseIdentifier: idef)
            
            let label = UILabel(frame: (cell?.bounds)!)
            cell?.addSubview(label)
            label.textAlignment = NSTextAlignment.center
            label.textColor = UIColor.black
            label.font = UIFont.systemFont(ofSize: 16)
            label.tag = 111
            label.snp.makeConstraints({ (make) in
                make.edges.equalTo(cell!)
            })
            let lineView:UIView = UIView()
            cell?.addSubview(lineView)
            lineView.backgroundColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
            lineView.snp.makeConstraints({ (make) in
                make.left.equalTo(cell!).offset(30)
                make.right.equalTo(cell!).offset(-30)
                make.bottom.equalTo(cell!.snp.bottom).offset(-0.5)
                make.height.equalTo(0.5)
            })
        }
        let label:UILabel = cell?.viewWithTag(111) as! UILabel
        let title = dataArray![indexPath.row]
        label.text = title as? String
        return cell!
    }
}

// MARK:- TableView Delegate
extension ActionSheetCus: UITableViewDelegate{
    // MARK: Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if delegate != nil{
            delegate?.actionSheetDelegate(actionSheet: self, index: indexPath.row)
        }
        
        if selectDataBlock != nil {
            selectDataBlock!(dataArray! ,indexPath.row)
        }
        
        hiddenWithAnimation(ani: true)
    }
}

// MARK:- TextField ValueChangeTarget & Delegate
extension ActionSheetCus: UITextFieldDelegate{
    // MARK: TextField ValueChangeTarget
    @objc private func textField1TextChange(_ textField: UITextField) {
        let flterAarray = NSMutableArray.init(array: self.originArrs!)
        let pre = NSPredicate(format: "SELF CONTAINS %@", textField.text!)
        flterAarray.filter(using: pre)
        
        if !textField.text!.isEmpty{
            if textField.text!.isInt{
                //                let i:Int = Int(textField.text!)!
                if Int(textField.text!)  == 0{
                    textField.layer.borderColor = UIColor.red.cgColor
                }else{
                    textField.layer.borderColor = UIColor.gray.cgColor
                }
                
                textField.text = String(Int(textField.text!)!)
            }else{
                textField.layer.borderColor = UIColor.gray.cgColor
            }
            
            let pre = NSPredicate(format: "SELF MATCHES %@", "(^[\u{4e00}-\u{9fa5}]+$)")
            let isMatch = pre.evaluate(with: textField.text!)
            if !isMatch {
                textField.layer.borderColor = UIColor.red.cgColor
            }else{
                textField.layer.borderColor = UIColor.gray.cgColor
            }
            inputTfString = textField.text
            dataArray = (flterAarray as! Array<Any>)
        }else{
            inputTfString = ""
            dataArray = originArrs
        }
        
        tableView.reloadData()
        
    }
    // MARK: TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == fliterTextFiled) {
            //如果是删除减少字数，都返回允许修改
            if string.isEmpty {
                textField.layer.borderColor = UIColor.gray.cgColor
                return true;
            }
            else{
                textField.layer.borderColor = UIColor.red.cgColor
                if range.location >= 10
                {
                    return false;
                }
                //                if range.location == 0 && string == "0"
                //                {
                ////                    if range.location == 1 && string == "0"
                ////                    {
                //                        return false;
                ////                    }
                //                }
            }
        }
        textField.layer.borderColor = UIColor.gray.cgColor
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let offsetx:CGFloat  = self.containView.frame.origin.y - 33;
        UIView.animate(withDuration: 0.5) {
            self.containView.transform = CGAffineTransform(translationX: 0, y: -offsetx)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.containView.transform = CGAffineTransform.identity
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField1TextChange(_ : textField)
        textField.resignFirstResponder()
        self.endEditing(true);
        return true;
    }
    
}
