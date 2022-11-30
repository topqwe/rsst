//
//  ViewController.swift
//  RS
//
//  Created by cx on 28/11/2018.
//  Copyright © 2018 aa. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit
class ViewController: BaseVC {
    var locationManager: CLLocationManager!
    
    var startBtn: TimerButton?
    var startBtnConstrains: Constraint?
    var startBtnWHConstrains: Constraint?
    var cancelBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        startBtn = TimerButton.init()
        startBtn?.timeDown(time: 1)
        view.addSubview(self.startBtn!)
//        startBtn!.backgroundColor = UIColor.red
        startBtn!.snp.makeConstraints { (make) in
            startBtnConstrains = make.left.top.equalTo(self.view).offset(200).constraint
            startBtnWHConstrains = make.width.height.equalTo(150).constraint
        }
        
        startBtn!.addTarget(self, action: #selector(updateBtnConstraints(_:)), for: .touchUpInside)
        
//        let dogView = DogView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
//        view.addSubview(dogView)
        view.layoutIfNeeded()
        view.circleFilledWithOutline(circleView: startBtn!, fillColor: UIColor.red, outlineColor: UIColor.blue)
    }
    
    
    @objc func updateBtnConstraints(_ button:UIButton) {
        startBtnConstrains!.update(offset: 50)
        //left\top update same inset\offset

//        self.startBtn.snp.updateConstraints { (make) in
//            make.width.height.equalTo(190)
//        }
        startBtnWHConstrains!.update(offset: 90)
        //width\height update inset-  offset+
        startBtnConstrains!.deactivate()
        startBtn!.setImage(UIImage.init(named: "mono-black-20"), for: .normal)
        startBtn?.setTitle("看看", for: .normal)
        startBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        startBtn?.titleLabel?.textColor = UIColor.lightGray
        startBtn?.layoutButtonWithEdgeInsetsStyle(style: .MKButtonEdgeInsetsStyleTop, space: 5)
        //解除left\top
        view.setNeedsLayout() // 若想达到动画效果，这两个方法一定要这样配合使用，不然你试试.
        UIView.animate(withDuration: 0.3) { [weak self] in
            self!.view.layoutIfNeeded()
            self!.view.circleFilledWithOutline(circleView: self!.startBtn!, fillColor: UIColor.red, outlineColor: UIColor.blue)
        }
        let sheet: ActionSheetCus = ActionSheetCus.init(array: ["fddff","aasda"],title:"请选择", isShowFliterTextFiled: true)
        sheet.showWithAnimation(ani: true)
        sheet.selectDataBlock = {(anyData,selectIndex) in
        
            print(anyData[selectIndex])
        
            RefreshVC.pushFromVC(rootVC: self, requestParams: anyData[selectIndex], block: { (_) in
                
            })
            
        }
    }
    //TODO:- 登入成功刷新接口数据
    override func loginSuccessBlockMethod() {
        print("登入成功后的某页数据刷新")
    }
    
}

// MARK:- LocationManagerDelegate
private typealias LocationManagerDelegate = ViewController
extension LocationManagerDelegate:CLLocationManagerDelegate  {
    // MARK: fileprivate暴露内部接口,
    fileprivate func setup() {
        setupStyle()
    }
    // MARK: private内部实现
    private func setupStyle() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //MARK: 属性 自动暂停位置更新
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        self.locationLabel.text = "Error while updating location" + error.localizedDescription
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler:  { (placeMarks, error) -> Void in
            
            if (error != nil) {
//                self.locationLabel.text = "Reverse geocoder failed with error" + (error!.localizedDescription)
                return
            }
            
            if placeMarks!.count > 0 {
                let PM = placeMarks![0]
                self.showLocationInfo(PM)
            } else {
//                self.locationLabel.text = "Problem with the data received from geocoder"
            }
        })
    }
    
    //MARK: 显示位置
    func showLocationInfo(_ placemark: CLPlacemark?) {
        
        if let containsPlacemark = placemark {
            
            locationManager.startUpdatingLocation()
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            
//            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
//            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
//            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
//            self.locationLabel.text = locality! + " " + postalCode! + " " + administrativeArea! + " " + country!
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: locality!, target: self, action: .rightBarButtonItemAction)
        }
        
    }
    
    // MARK: 选择位置列表
    @objc fileprivate func rightBarButtonItemAction(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        UIAlertController.showAlert(message: "要进行手动选择位置")
    }
}
fileprivate extension Selector {
    static let rightBarButtonItemAction = #selector(ViewController.rightBarButtonItemAction(_:))
}


