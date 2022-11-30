//
//  LoginVC.swift
//  RS
//
//  Created by cx on 28/11/2018.
//  Copyright © 2018 aa. All rights reserved.
//

import UIKit
import SnapKit
enum LoginInputError: String {
    case loginInputTooLong = "请重新输入：4-16位就行，不用太长"
    case accountEmpty = "请输入账号"
    case pwEmpty = "请输入账号密码"
    case pwShort = "请重新输入密码：密码太短太简单"
    case pwStandard = "请重新输入密码：必须包含大小写字母与数字"
}

fileprivate let loginMargin: CGFloat = 16
fileprivate let buttonHeight: CGFloat = 40.0

fileprivate extension Selector {
    static let togglePasswordVisibility = #selector(LoginVC.togglePasswordVisibility(_:))
    static let loginAction = #selector(LoginVC.loginAction(_:))
    static let leftBarButtonItemAction = #selector(LoginVC.leftBarButtonItemAction(_:))
    static let rightBarButtonItemAction = #selector(LoginVC.rightBarButtonItemAction(_:))
}

class LoginVC: BaseVC {
    
    var successBlock: DataBlock?
    var closeBlock: DataBlock?
    var requestParams :Any?
    
    var centerXAlignUsername: Constraint!
    var centerXAlignPassword: Constraint!
    
    var carve01LeftConstraint: Constraint!
    
    
    var loginButtonLeftConstraint: Constraint!
    var loginButtonRightConstraint: Constraint!
    
    fileprivate lazy var skipButton = with(UIButton()) {
        $0.layer.cornerRadius = 40 / 2
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.ThemeColor
        $0.setTitleColor(.blue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
        $0.titleLabel?.numberOfLines = 2
        $0.titleLabel?.textAlignment = .center
    }
    
    // MARK: - 私有控件
    fileprivate lazy var accountTextField: UITextField = UITextField(hq_placeholder: "请输入账号")
//    fileprivate lazy var carve01: UIView = {
//        $0.backgroundColor = UIColor.lightGray
//        return $0
//    }(UIView())
    fileprivate lazy var carve01 = with(UIView()) {
        $0.backgroundColor = .lightGray
    }
    
    fileprivate lazy var passwordTextField: UITextField = UITextField(hq_placeholder: "请输入密码", isSecureText: true)
    fileprivate lazy var carve02: UIView = {
        let carve = UIView()
        carve.backgroundColor = .lightGray
        return carve
    }()
    
    fileprivate lazy var securePasswordBtn = with(UIButton()) {
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "password_invisible"), for: .normal)
        $0.setImage(UIImage(named: "password_visible"), for: .selected)
    }
    
    fileprivate lazy var loginButton: UIButton = UIButton(title: "登录", normalBackColor: .ThemeColor, hightBackColor: UIColor.green, size: CGSize(width: UIScreen.MAINSCREEN_WIDTH() - (loginMargin * 2), height: buttonHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "登录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: .leftBarButtonItemAction)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", target: self, action: .rightBarButtonItemAction)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        centerXAlignUsername.update(offset: -self.view.layer.bounds.width)
        
        carve01LeftConstraint.update(inset: +self.view.layer.bounds.width)

        loginButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.00, options: UIView.AnimationOptions(), animations: {
            
            self.centerXAlignUsername.update(inset: +self.view.bounds.width)
            self.carve01LeftConstraint.update(offset: +loginMargin)
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
//        UIView.animate(withDuration: 0.5, delay: 0.10, options: UIView.AnimationOptions(), animations: {
//
//            self.centerXAlignPassword.update(inset: +self.view.layer.bounds.width)
//            self.view.layoutIfNeeded()
//
//        }, completion: nil)

        UIView.animate(withDuration: 0.5, delay: 0.20, options: UIView.AnimationOptions(), animations: {

            self.loginButton.alpha = 1

        }, completion: nil)
        
    }
    
//    override func loginSuccessBlockMethod() {
//        print("登入成功的用户数据保存")
//    }
    
}

// MARK:- Target Action
extension LoginVC {
    // MARK: 密码显示隐藏
    @objc fileprivate func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry = !sender.isSelected
        
    }
    // MARK: 登录
    @objc fileprivate func loginAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 1.0, delay: 0.00, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveLinear, animations: {
            
            self.loginButtonLeftConstraint.update(offset: +40)
            self.loginButtonRightConstraint.update(offset: -40)
            self.view.layoutIfNeeded()
            self.loginButton.isEnabled = true
        }, completion: { finished in
            self.loginButton.isEnabled = true
            self.loginButtonLeftConstraint.update(offset: 0)
            self.loginButtonRightConstraint.update(offset: 0)
//            self.view.layoutIfNeeded()
            
        })
        
        view.endEditing(true)
        
        //guard let 语句以及 optional chaining
        guard let username = accountTextField.text, !accountTextField.text!.isEmpty
              else {
                TAlert.show(type:.warning, text: LoginInputError.accountEmpty.rawValue)
            return
        }
        
        guard let password = passwordTextField.text,
            !passwordTextField.text!.isEmpty  else {
                TAlert.show(type:.warning, text: LoginInputError.pwEmpty.rawValue)
                return
        }
        
        guard String.isStandardPW(originString: passwordTextField.text!) else {
            TAlert.show(type:.warning, text: LoginInputError.pwStandard.rawValue)
            return
        }
        
        print(username + password)
        
        // TODO: -请求登入接口，成功后的处理
        //UserDefaults.standard.set(true, forKey: kIsLogin)
        AppManager.shared.userInfo.token = "dfewfe"
        AppManager.shared.userInfo.userName = username
        AppManager.shared.isLogin = true
        AppManager.shared.login()
        
        self.dismiss(animated: true) {
            
        }
//        if self.successBlock != nil {
//            self.successBlock!(true)
//        }
        
        guard let _ = self.successBlock else {
            return
        }
        self.successBlock!(true)
    }
    // MARK: 关闭
    @objc fileprivate func leftBarButtonItemAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
//        AppManager.shared.logout()
        self.dismiss(animated: true) {
            
        }
        guard let _ = self.closeBlock else {
            return
        }
        self.closeBlock!(true)
    }
    
    // MARK: 注册
    @objc fileprivate func rightBarButtonItemAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        print("注册")
    }
    
    
}

// MARK:- TextField ValueChangeTarget & Delegate
extension LoginVC: UITextFieldDelegate{
    // MARK: TextField ValueChangeTarget
    @objc private func textField1TextChange(_ textField: UITextField) {
        //guard let 语句以及 optional chaining
        guard  !accountTextField.text!.isEmpty else {
            loginButton.setBackgroundImage(UIImage.init(hq_color: .ThemeColor), for: .normal)
            return
        }
        guard  !passwordTextField.text!.isEmpty  else {
            loginButton.setBackgroundImage(UIImage.init(hq_color: .ThemeColor), for: .normal)
            return
        }
        loginButton.setBackgroundImage(UIImage.init(hq_color: .green), for: .normal)
    }
    
    // MARK: TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == accountTextField
            ||
            textField == passwordTextField) {
            //如果是删除减少字数，都返回允许修改
            if string.isEmpty {
//                textField.layer.borderColor = UIColor.gray.cgColor
                return true;
            }
            else{
//                textField.layer.borderColor = UIColor.red.cgColor
                if range.location >= 16
                {
                    TAlert.show(type:.warning, text: LoginInputError.loginInputTooLong.rawValue)
                    return false;
                }
            }
        }
//        textField.layer.borderColor = UIColor.gray.cgColor
        return true;
    }
}

// MARK: - 设置登录控制器界面
private typealias ViewStylingHelpers = LoginVC
extension ViewStylingHelpers  {
    
    fileprivate func setupUI() {
        view.addSubview(skipButton)
        
        view.addSubview(accountTextField)
        view.addSubview(carve01)
        
        view.addSubview(passwordTextField)
        view.addSubview(securePasswordBtn)
        view.addSubview(carve02)
        
        view.addSubview(loginButton)
        
        accountTextField.delegate = self
        passwordTextField.delegate = self
        
        accountTextField.addTarget(self, action: #selector(textField1TextChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textField1TextChange(_:)), for: .editingChanged)
        
        securePasswordBtn.addTarget(self, action: .togglePasswordVisibility, for: .touchUpInside)
        
        skipButton.addTarget(self, action: .leftBarButtonItemAction, for: .touchUpInside)
        skipButton.setTitle("关闭", for: .normal)
        
        skipButton.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(20)
            maker.top.equalToSuperview().offset(UIScreen.STATUSBAR_HEIGHT()+40)
            maker.width.equalTo(80)
            maker.height.equalTo(40)
        }
//        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.addTarget(self, action: .loginAction, for: .touchUpInside)
        
        accountTextField.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(loginMargin * 9)
//            make.left.equalTo(view).offset(loginMargin)
//            make.right.equalTo(view).offset(-loginMargin)
            make.height.equalTo(buttonHeight)
            make.width.equalTo(UIScreen.MAINSCREEN_WIDTH() - 2*loginMargin)
            centerXAlignUsername = make.centerX.equalTo(view).constraint
            
        }
        carve01.snp.makeConstraints { (make) in
            carve01LeftConstraint = make.left.equalTo(loginMargin).constraint//accountTextField
            make.bottom.equalTo(accountTextField)
            make.right.equalTo(view)
            make.height.equalTo(0.5)
        }
        
        securePasswordBtn.snp.makeConstraints { (make) in
//            make.top.equalTo(accountTextField.snp.bottom) make.right.equalTo(accountTextField.snp.right).offset(-loginMargin)
//            make.height.equalTo(accountTextField)
            
            //rightViewMode
            make.width.height.equalTo(accountTextField.snp.height)
            
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(accountTextField.snp.bottom)
            make.left.equalTo(accountTextField)
            make.right.equalTo(accountTextField)
//            make.right.equalTo(securePasswordBtn.snp.left).offset(-loginMargin)
            make.height.equalTo(accountTextField)
        }
        
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = securePasswordBtn
        
        carve02.snp.makeConstraints { (make) in
            make.left.equalTo(carve01)
            make.bottom.equalTo(passwordTextField)
            make.right.equalTo(carve01)
            make.height.equalTo(carve01)
        }
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(loginMargin * 2)
            loginButtonLeftConstraint = make.left.equalTo(accountTextField).constraint
            loginButtonRightConstraint = make.right.equalTo(accountTextField).constraint
            make.height.equalTo(accountTextField)
        }
    }
}

// MARK:- class 方法
extension LoginVC {
    /*
     Swift中static func 相当于class final func。禁止这个方法被重写。
     ERROR: Cannot override static method
     ERROR: Class method overrides a 'final` class method
     */
    static func  getVC(requestParams:Any,block:@escaping DataBlock) ->  UIViewController{
        let vc  : LoginVC = LoginVC.init()
        vc.successBlock = block
        vc.requestParams = requestParams
        return vc
    }
    
    static func  pushFromVC(rootVC:UIViewController,requestParams:Any,block:@escaping DataBlock) ->  Void{
        let vc: LoginVC = LoginVC.init()
        vc.successBlock = block
        vc.requestParams = requestParams
        rootVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    class final func  presentFromVC(rootVC:UIViewController,requestParams:Any,block:@escaping DataBlock) ->  Void{
        let vc: LoginVC = LoginVC.init()
        vc.successBlock = block
        vc.requestParams = requestParams
        rootVC.present(vc, animated: true) {
            
        }
    }
    
    class final func  presentFromVC(rootVC:UIViewController,requestParams:Any,successBlock:@escaping DataBlock,closeBlock:@escaping DataBlock) ->  Void{
        let vc: LoginVC = LoginVC.init()
        vc.successBlock = successBlock
        vc.closeBlock = closeBlock
        vc.requestParams = requestParams
        rootVC.present(vc, animated: true) {
            
        }
    }
}



