//
//  ApiService.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation

enum ApiServiceError: Error {
    
    case apiError(code: String?, name: String?, message: String)
}

protocol ApiServiceDelegate: class {
    
    func apiServiceDidRecieveUnauthorizedError(_ apiService: ApiService, retryHandler: @escaping () -> Void)
}

class ApiService {
    
    weak var delegate: ApiServiceDelegate?
}

extension ApiService {
    
    private struct ApiServiceResultErrorCodingData: Decodable {
        
        let resultCode: Int
        let resultMessage: String
    }
    
    func perform<Resource>(request: ApiRequest<Resource>, then handler: @escaping (Result<Resource.Model, Error>) -> Void) {
        request.load { [weak self] response in
            guard let self = self else { return }
            if case .failure(let error) = response, case NetworkError.serverError(code: let code, _) = error, code == 401 {
                guard let delegate = self.delegate else {
                    handler(.failure(NetworkError.nilData))
                    return
                }
                delegate.apiServiceDidRecieveUnauthorizedError(self) { [weak self] in
                    guard let self = self else { return }
                    self.perform(request: request, then: handler)
                }
            } else if case .failure(let error) = response, case NetworkError.serverError(code: let code, data: let data) = error,
                      let errorData = data {
                if ((400 ..< 500) ~= code), let error = self.error(fromData: errorData) {
                    handler(.failure(error))
                } else {
                    handler(response)
                }
            } else {
                handler(response)
            }
        }
    }
}

private extension ApiService {
    
    func error(fromData data: Data) -> Error? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        if let errorData = try? decoder.decode(ApiServiceResultErrorCodingData.self, from: data) {
            return ApiServiceError.apiError(code: "\(errorData.resultCode)", name: nil, message: errorData.resultMessage)
        } else {
            return nil
        }
    }
}
