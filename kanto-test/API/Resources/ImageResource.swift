//
//  ImageResource.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import UIKit
import Foundation

class ImageResource: ApiResource {
    
    typealias Model = UIImage?
    
    let urlRequest: URLRequest
    
    init(imageName: String) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "sitio"
        components.path += "/images/\(imageName)"
        urlRequest = URLRequest(url: components.url ?? URL(fileURLWithPath: ""), cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
    }
    
    func makeModel(fromData data: Data) throws -> UIImage? {
        UIImage(data: data)
    }
}
