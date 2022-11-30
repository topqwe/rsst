//
//  ExtensionImageView.swift
//  RS
//
//  Created by Aalto on 2019/6/29.
//  Copyright © 2019 aa. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// 根据图片名称快速创建`ImageView`
    ///
    /// - Parameter hq_imageName: imageName
    convenience init(hq_imageName: String) {
        self.init(image: UIImage.init(named: hq_imageName))
    }
}

