//
//  Error+Code.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation

extension Error {
    
    var code: Int { (self as NSError).code }
    var domain: String { (self as NSError).domain }
}
