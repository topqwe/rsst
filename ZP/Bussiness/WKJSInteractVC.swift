//
//  ViewController.swift
//  RS
//
//  Created by cx on 28/11/2018.
//  Copyright © 2018 aa. All rights reserved.
//

import UIKit
import SnapKit
import WebKit
class WKJSInteractVC: BaseVC, WKNavigationDelegate, WKScriptMessageHandler {
    
    lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "WKJSModel")
        
        var webView = WKWebView(frame: self.view.frame, configuration: configuration)
        webView.scrollView.bounces = true
        webView.scrollView.alwaysBounceVertical = true
        webView.navigationDelegate = self
        return webView
    }()
    
    let HTML = try! String(contentsOfFile: Bundle.main.path(forResource: "wkjs", ofType: "html")!, encoding: String.Encoding.utf8)
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isTranslucent = false
        
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(webView)
        
        webView.loadHTMLString(HTML, baseURL: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("sayHello('WebView你好！')") { (result, err) in
//            print(result as Any, err as Any)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        print(message.body)
        UIAlertController.showAlert(message: message.body as! String)
    }

    //TODO:- 登入成功刷新接口数据
    override func loginSuccessBlockMethod() {
        print("登入成功后的某页数据刷新")
    }
    
}





