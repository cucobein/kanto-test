//
//  UIButton+Rounded.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 20/03/21.
//

import UIKit

extension UIButton {

    func makeRounded(cornerRadius: CGFloat) {
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
