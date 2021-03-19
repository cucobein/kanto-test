//
//  ApiService+CDN.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import UIKit
import Foundation

extension ApiService {
    
    func getImage(fromURL url: URL, completion: @escaping (UIImage?, URL) -> Void) {
        let cache = URLCache.shared
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        if let response = cache.cachedResponse(for: request), let image = UIImage(data: response.data) {
            completion(image, url)
        } else {
            let task = URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let data = data, let image = UIImage(data: data) {
                    if let response = response {
                        cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                    }
                    DispatchQueue.main.async {
                        completion(image, url)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, url)
                    }
                }
            }
            task.resume()
        }
    }
}
