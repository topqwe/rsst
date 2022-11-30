//
//  DatePickerView.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
    static func show(completionHandler:@escaping(_ time:String) -> ()){
        let window = UIApplication.shared.keyWindow
        let datePick = DatePickerView()
        window?.addSubview(datePick)
        datePick.snp.makeConstraints { (make) in
            make.left.top.height.right.equalToSuperview()
        }
        datePick.completionHandlers = { time in
            completionHandler(time)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.addSubview(datePicker)
        self.addSubview(toolBar)
        datePicker.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(216)
        }
        toolBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(datePicker.snp.top)
            make.height.equalTo(40)
        }
    }
    typealias completion =  (_ time:String ) -> ()
    private var completionHandlers : completion?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var datePicker: UIDatePicker = {
        let da = UIDatePicker()
        da.maximumDate = Date()
        da.backgroundColor = UIColor.white
        da.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        da.datePickerMode = .date
        return da
    }()
   private lazy var bgView: UIView = {
        let vi = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancel))
        vi.addGestureRecognizer(tap)
        return vi
    }()
    lazy var toolBar: UIToolbar = {
        let tool = UIToolbar()
        let cancelItem = UIBarButtonItem(title: "   取消", style: .plain, target: self, action: #selector(cancel))
        let fg = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let determineItem = UIBarButtonItem(title: "确定  ", style: .plain, target: self, action: #selector(determine))
        tool.setItems([cancelItem,fg,determineItem], animated: false)
        return tool
    }()
    private var time : String?
}
extension DatePickerView{
    @objc private func dateChanged(datePicker:UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.time = formatter.string(from: datePicker.date)
        
    }
    ///取消
    @objc private func cancel() {
        dismiss()
    }
    
    @objc private func determine(){
        
        self.completionHandlers?(self.time ?? String.time())
        dismiss()
        
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: UIScreen.MAINSCREEN_WIDTH());
        }) { (_) in
            self.isHidden = true
            for v in self.subviews {
                v.removeFromSuperview()
            }
        }
    }
    
}
