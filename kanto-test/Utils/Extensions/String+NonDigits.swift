//
//  String+NonDigits.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation

extension String {
    var removingNonDecimalDigits: String {
        String(compactMap { $0.isNumber ? $0 : nil })
    }
    
    func replacingOccurences(ofRegex regexString: String, with replacementString: String) throws -> String {
        let regex = try NSRegularExpression(pattern: regexString, options: [])
        let mutableString = NSMutableString(string: self)
        regex.replaceMatches(in: mutableString,
                             options: [],
                             range: NSRange(location: 0, length: mutableString.length),
                             withTemplate: replacementString)
        return String(mutableString)
    }
}
