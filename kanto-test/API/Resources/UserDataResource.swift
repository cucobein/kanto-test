//
//  UserDataResource.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 18/03/21.
//

import Foundation

class UserDataResource: ApiResource {
    
    typealias Model = UserData
    
    let urlRequest: URLRequest
    
    init() {
        var urlBuilder = Endpoint.kanto
        urlBuilder.path += "/v3/4efa83dd-6ff7-4bc1-9c17-3a45016978a7"
        guard let url = urlBuilder.url else { fatalError("Invalid URL") }
        urlRequest = URLRequest(url: url, httpMethod: .get)
    }
    
    func makeModel(fromData data: Data) throws -> Model {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try jsonDecoder.decode(Model.self, from: data)
    }
}

struct UserData: Decodable {
    
    let userIdEncrypted: String?
    let name: String?
    let userName: String?
    let profilePicture: String?
    let biography: String?
    let followers: Int?
    let followed: Int?
    let views: Int?
}
