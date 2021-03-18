//
//  VideosResource.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 18/03/21.
//

import Foundation

class VideosResource: ApiResource {
    
    typealias Model = [VideoData]
    
    let urlRequest: URLRequest
    
    init() {
        var urlBuilder = Endpoint.kanto
        urlBuilder.path += "/v3/2f188654-7f58-4267-8887-ede536d8382e"
        guard let url = urlBuilder.url else { fatalError("Invalid URL") }
        urlRequest = URLRequest(url: url, httpMethod: .get)
    }
    
    func makeModel(fromData data: Data) throws -> Model {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(Model.self, from: data)
    }
}

struct UserVideoData: Decodable {

    let name: String?
    let userName: String?
    let profilePicture: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case userName = "user_name"
        case profilePicture
    }
}

struct VideoData: Decodable {
    
    let user: UserVideoData?
    let songName: String?
    let recordVideo: String?
    let previewImg: String?
    let likes: Int?
    
    enum CodingKeys: String, CodingKey {
        case user
        case songName
        case recordVideo = "record_video"
        case previewImg = "preview_img"
        case likes
    }
}
