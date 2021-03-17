//
//  ApiRequest.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation

struct ApiRequest<Resource: ApiResource> {
    
    let resource: Resource
}

extension ApiRequest: NetworkRequest {
    
    typealias LoadedType = Resource.Model
    
    @discardableResult
    func load(then handler:
                @escaping (Result<LoadedType, Error>) -> Void) -> Request? {
        return self.load(request: resource.urlRequest, then: handler)
    }
    
    func decode(_ data: Data, for response: URLResponse?) throws -> Resource.Model {
        return try makeModel(with: data)
    }
    
    private func makeModel(with data: Data)  throws -> Resource.Model {
        try resource.makeModel(fromData: data)
    }
}
