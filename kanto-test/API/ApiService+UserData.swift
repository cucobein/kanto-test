//
//  ApiService+UserData.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 18/03/21.
//

import Foundation

extension ApiService {
    
    typealias GetUserDataHandler = (Result<UserData, Error>) -> Void
    
    func getUserData(then handler: @escaping GetUserDataHandler) {
        let resource = UserDataResource()
        let request = ApiRequest(resource: resource)
        perform(request: request, then: handler)
    }
}
