//
//  NetworkRequest.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import Foundation

enum NetworkError: Error {
    
    case serverError(code: Int, data: Data?)
    case nilData
    case decodeFail(Error?)
    case connectionError
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case let .serverError(code, data):
            if let data = data, let content = String(data: data, encoding: .utf8) {
                return "Error \(code) - \(content)"
            } else {
                return "Error \(code) - Se produjo un error."
            }
        case .nilData:
            return "El contenido de la respuesta está vacio."
        case .decodeFail(let underlying):
            return underlying?.localizedDescription ?? "El contenido de la respuesta tiene un formato invalido."
        case .connectionError:
            return ""
        }
    }
}

extension NetworkError {
    
    var resultMessage: String? {
        switch self {
        case .serverError(_, let data):
            guard let data = data else { return nil }
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
            return json?["result_message"] as? String
        default:
            return nil
        }
    }
    
    var resultCode: Int? {
        switch self {
        case .serverError(_, let data):
            guard let data = data else { return nil }
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
            return (json?["result_code"] as? Int) ?? code
        default:
            return nil
        }
    }
}

class EmptyNetworkResult { }

protocol NetworkRequest {
    
    associatedtype LoadedType
    
    func load(then handler: @escaping (Result<LoadedType, Error>) -> Void) -> Request?
    func decode(_ data: Data, for response: URLResponse?) throws -> LoadedType
}

extension NetworkRequest where Self.LoadedType: EmptyNetworkResult {
    
    @discardableResult
    func load(request: URLRequest,
              then handler: @escaping (Result<EmptyNetworkResult, Error>) -> Void) -> Request? {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(
            configuration: configuration,
            delegate: nil,
            delegateQueue: nil
        )
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let httpResponse = response as? HTTPURLResponse, !(200..<300 ~= httpResponse.statusCode) {
                if httpResponse.statusCode != 401 {
                    let url = request.url?.absoluteString ?? ""
                    _ = NSError(domain: url,
                                        code: httpResponse.statusCode,
                                        userInfo: ["url": request.url?.absoluteString ?? "", "data": data?.utf8String ?? ""])
                }
                DispatchQueue.main.async {
                    handler(Result.failure(NetworkError.serverError(code: httpResponse.statusCode, data: data)))
                }
                return
            }
            if error != nil {
                DispatchQueue.main.async {
                    handler(Result.failure(error!))
                }
                return
            }
            handler(Result.success(EmptyNetworkResult()))
        }
        task.resume()
        return Request(task: task)
    }
}

extension NetworkRequest {
    
    @discardableResult
    func load(request: URLRequest,
              then handler: @escaping (Result<LoadedType, Error>) -> Void) -> Request? {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(
            configuration: configuration,
            delegate: nil,
            delegateQueue: nil
        )
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let httpResponse = response as? HTTPURLResponse, !(200..<300 ~= httpResponse.statusCode) {
                if httpResponse.statusCode != 401 {
                    let url = request.url?.absoluteString ?? ""
                    _ = NSError(domain: url,
                                        code: httpResponse.statusCode,
                                        userInfo: ["url": request.url?.absoluteString ?? "", "data": data?.ascii ?? ""])
                }
                DispatchQueue.main.async {
                    handler(Result.failure(NetworkError.serverError(code: httpResponse.statusCode, data: data)))
                }
                return
            }
            if error != nil {
                DispatchQueue.main.async {
                    if let noConnectionError = error?.code, noConnectionError == -1009 {
                        handler(Result.failure(NetworkError.connectionError))
                    } else {
                        handler(Result.failure(error!))
                    }
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    handler(Result.failure(NetworkError.nilData))
                }
                return
            }
            do {
                let loadedType = try self.decode(data, for: response)
                DispatchQueue.main.async {
                    handler(Result.success(loadedType))
                }
            } catch {
                DispatchQueue.main.async {
                    handler(Result.failure(NetworkError.decodeFail(error)))
                }
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
        
        return Request(task: task)
    }
}
