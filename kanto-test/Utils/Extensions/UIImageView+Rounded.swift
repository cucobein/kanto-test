//
//  UIImageView+Rounded.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 20/03/21.
//

import UIKit

extension UIImageView {

    func makeRounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
