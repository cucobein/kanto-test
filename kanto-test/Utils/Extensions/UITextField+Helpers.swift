//
//  UITextField+Helpers.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 21/03/21.
//

import UIKit

extension UITextField {
    
    func underlined(color: UIColor) {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
