//
//  URLRequest+Helpers.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 18/03/21.
//

import Foundation

extension URLRequest {
    
    init(url: URL, httpMethod: HTTPMethod) {
        self.init(url: url)
        self.httpMethod = httpMethod.rawValue
    }
}
