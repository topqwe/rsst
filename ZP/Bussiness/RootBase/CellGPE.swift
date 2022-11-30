//
//  G+P+E.swift
//  G+P+E
//
//  Created by PF on 2017/5/9.
//  Copyright © 2017年 PF. All rights reserved.
//
//https://swift.gg/2016/01/27/generic-tableviewcells/
//https://swift.gg/2017/07/19/the-best-table-view-controller-mar-2016-edition/
//https://swift.gg/2016/05/16/using-swift-extensions/
//https://juejin.im/entry/59b9ee5f6fb9a00a402dd142?utm_source=gold_browser_extension
//python: https://tomoya92.github.io/2019/01/21/python-selenium/
import UIKit
// MARK:- 为cell准备的Identifier
protocol Reusable: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

// MARK:- 利用自己的扩展实现自己
//可以给Extension去实现一些底层的代码，那么就意味着我们不用每次必须遵守协议、实现协议，因为你可以在Class的扩展中让它自己去实现
extension Reusable {
    static var reuseIdentifier: String { return String(describing: self) }
    static var nib: UINib? { return nil }
}

// MARK:- 遵守这个协议，且什么都不用操作,便有了just_Identifier这个属性
extension UITableViewCell: Reusable { }

// MARK:- 泛型Generic，用一个UITableView的扩展去添加一些方法
//拥有共同特性的类型的代表，定义特定的泛型去书写代码，免去了很多不必要的事情。
extension UITableView {
    func registerReusableCell<T: UITableViewCell>(_: T.Type)  {//where T: Reusable
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: NSIndexPath) -> T {// where T: Reusable
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as! T
    }
    
    func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? where T: Reusable {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T?
    }
    
}

extension UICollectionView {
    func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        if let nib = T.nib {
            self.register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: NSIndexPath) -> T where T: Reusable {
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as! T
    }
    
    func registerReusableSupplementaryView<T: Reusable>(elementKind: String, _: T.Type) {
        if let nib = T.nib {
            self.register(nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionViewCell>(elementKind: String, indexPath: NSIndexPath) -> T where T: Reusable {
        return self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as! T
    }
}
// MARK:- protocol声明的变量必须，在声明protocol后的enxtenstion中,或要实现更改的VM处给默认值
// MARK:对cell中臃肿的带有六个参数的 configure 方法，用协议的方式将其进行了重构。
protocol SwitchWithTextCellProtocol {
    var title: String { get }
    var titleFont: UIFont { get }
    var titleColor: UIColor { get }
    
    var switchOn: Bool { get }
    var switchColor: UIColor { get }
    
    func onSwitchToggleOn(on: Bool)
}

extension SwitchWithTextCellProtocol {
    var titleColor: UIColor {
        return .purple
    }
    
    var switchColor: UIColor {
        return .purple
    }
}

// MARK:- 对上面的protocol分离开，分别创建了单元格数据存储和单元格委托
protocol SwitchWithTextCellDataSource {
    var title: String { get }
    
    var switchOn: Bool { get }
}

extension SwitchWithTextCellDataSource {
    
}

protocol SwitchWithTextCellDelegate {
    func onSwitchToggleOn(on: Bool)
    
    var switchColor: UIColor { get }
    var titleColor: UIColor { get }
    var titleFont: UIFont { get }
}

extension SwitchWithTextCellDelegate {
    var titleColor: UIColor {
        return .purple
    }
    
    var switchColor: UIColor {
        return .purple
    }
}

// MARK:- 不用让实际的单元格实现这个协议了，只需要将其与更宽泛的 TextPresentable 联系在一起
protocol TextPresentable {
    var text: String { get }
    var textColor: UIColor { get }
    var font: UIFont { get }
}

protocol SwitchPresentable {
    var isSwitchTurnedOn: Bool { get }
    var switchColor: UIColor { get }
    
    func onSwitchToggleOn(on: Bool)
}

protocol ImagePresentable {
    var imageName: String { get }
    var imageUrl: URL { get }
}

protocol TextFieldPresentable {
    var placeholder: String { get }
    var text: String { get }
    
    func onTextFieldDidEndEditing(textField: UITextField)
}

protocol IndexPathPresentable {
    var indexPath: IndexPath { get }
}
// MARK:- 默认的全局统一配置处
extension TextPresentable {
    var textColor: UIColor {
        return .magenta
    }
    
    var font: UIFont {
        return .systemFont(ofSize: 17)
    }
    
}
extension ImagePresentable {
    var imageName: String {
        return "defaultphoto"
    }
}


