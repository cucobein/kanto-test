//
//  InputRowViewModel.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 21/03/21.
//

import UIKit
import Bond

struct InputRowViewModel {
    
    let title: String
    let placeHolderText: String
    var inputType: UIKeyboardType = .default
    var showableError = ""
    var maxCharCount = 256
    let neededHeightForDisplay = Observable<CGFloat>(0.0)
}
