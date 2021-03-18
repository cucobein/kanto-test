//
//  ApiResource.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation

protocol ApiResource {
    
    associatedtype Model
    var urlRequest: URLRequest { get }
    func makeModel(fromData data: Data) throws -> Model
}

extension ApiResource where Self.Model: Decodable {
    
    func makeModel(fromData data: Data) throws -> Model {
        let decored = JSONDecoder()
        decored.keyDecodingStrategy = .useDefaultKeys
        return try decored.decode(Model.self, from: data)
    }
}

extension ApiResource where Self.Model: EmptyNetworkResult {
    
    func makeModel(fromData data: Data) throws -> EmptyNetworkResult {
        EmptyNetworkResult()
    }
}
