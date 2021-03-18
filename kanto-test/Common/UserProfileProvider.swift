//
//  UserProfileProvider.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation
import Bond

enum UserProfileProviderError: Error {
    case invalidUserId
}

class UserProfileProvider {
    
    private let apiService: ApiService
    private let persistenceController: PersistenceController
    let userProfile = Observable<UserProfile?>(nil)
    
    init(apiService: ApiService, persistenceController: PersistenceController) {
        self.apiService = apiService
        self.persistenceController = persistenceController
        _ = persistenceController.userProfile.observeNext { [weak self] in
            self?.userProfile.value = $0
        }
    }
    
    var name: String? {
        guard let profile = userProfile.value else {
            return nil
        }
        return profile.name
    }
    
    var username: String? {
        guard let profile = userProfile.value else {
            return nil
        }
        return profile.userName
    }
    
    func fetchUserDataProfile(completion: @escaping(Result<UserData, Error>) -> Void) {
        apiService.getUserData { result in
            switch result {
            case .success(let userData):
                completion(.success(userData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUserVideos(completion: @escaping(Result<[VideoData], Error>) -> Void) {
        apiService.getUserVideos { result in
            switch result {
            case .success(let userVideos):
                completion(.success(userVideos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
