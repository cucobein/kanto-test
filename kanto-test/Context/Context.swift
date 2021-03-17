//
//  Context.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation

final class Context {
    
    private let apiService: ApiService
    private let persistenceController: PersistenceController
    let userProfileProvider: UserProfileProvider

    init(apiService: ApiService,
         persistenceController: PersistenceController) {
        self.apiService = apiService
        self.persistenceController = persistenceController
        userProfileProvider = UserProfileProvider(apiService: apiService, persistenceController: persistenceController)
    }
}
