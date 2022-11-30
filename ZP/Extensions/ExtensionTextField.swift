
//
//  ExtensionTextField.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

extension UITextField {
    
    /// 占位文字 + 边框样式(Optional) + 是否是密文(Optional)
    ///
    /// - Parameters:
    ///   - hq_placeholder: hq_placeholder
    ///   - border: border
    ///   - isSecureText: isSecureText
    convenience init(hq_placeholder: String, border: UITextField.BorderStyle = .none, isSecureText: Bool = false) {
        self.init()
        
        placeholder = hq_placeholder
        borderStyle = border
        clearButtonMode = .whileEditing
        isSecureTextEntry = isSecureText
    }
}
// MARK:- 如果禁用的文本选择适合您，请尝试此操作。
class NoMoreSelectionTextField: UITextField {
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override var selectedTextRange: UITextRange? {
        get { return nil }
        set { return }
    }
}
