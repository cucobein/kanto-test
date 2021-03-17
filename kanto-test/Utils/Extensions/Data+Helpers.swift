//
//  Data+Helpers.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation

extension Data {
    
    var utf8String: String {
        String(data: self, encoding: .utf8) ?? "[Not a String]"
    }
    
    var ascii: String {
        String(data: self, encoding: .ascii) ?? "[Not a String]"
    }
}
