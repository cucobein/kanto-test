//
//  UserProfileProvider.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import UIKit
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
    
    func fetchUserDataProfile(completion: @escaping(Result<UserProfile?, Error>) -> Void) {
        apiService.getUserData { result in
            switch result {
            case .success(let userData):
                self.persistenceController.storeUserProfile(with: userData)
                completion(.success(self.persistenceController.userProfile.value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUserVideos(completion: @escaping(Result<[UserVideo]?, Error>) -> Void) {
        apiService.getUserVideos { result in
            switch result {
            case .success(let userVideos):
                self.persistenceController.storeUserVideos(with: userVideos)
                completion(.success(self.persistenceController.userVideos.value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getImage(url: String, completion: @escaping(Result<UIImage, Error>) -> Void) {
        guard let imageURL = URL(string: url) else {
            return
        }
        apiService.getImage(fromURL: imageURL) { (image, _) in
            guard let imageResult = image else {
                completion(.failure(NetworkError.nilData))
                return
            }
            completion(.success(imageResult))
        }
    }
    
    func updateUserProfileWith(name: String, username: String, bio: String, selectedImage: Data?) {
        persistenceController.updateUserProfileWith(name: name,
                                                    username: username,
                                                    bio: bio,
                                                    selectedImage: selectedImage)
    }
    
    func toggleUserVideoLikes(with userVideo: UserVideo) {
        persistenceController.toggleUserVideoLikes(with: userVideo)
    }
}
