//
//  KantoEditProfileViewModel.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit
import Bond

struct KantoEditProfileViewModelDataSource: ViewModelDataSourceProtocol {
    
    let context: Context
}

final class KantoEditProfileViewModel: ViewModelProtocol {
    
    private let dataSource: KantoEditProfileViewModelDataSource
    private let userProfileProvider: UserProfileProvider
    private let router: KantoEditProfileRouter
    let minHeightNeeded = Observable<CGFloat>(0)
    let name = Observable<String?>("")
    let username = Observable<String?>("")
    let bio = Observable<String?>("")
    let imageData = Observable<Data?>(nil)
    let showNameError = Observable<Bool>(false)
    let showUsernameError = Observable<Bool>(false)
    let showBioError = Observable<Bool>(false)
    let profileImage = Observable<UIImage?>(nil)
    
    init(dataSource: KantoEditProfileViewModelDataSource, router: KantoEditProfileRouter) {
        self.router = router
        self.dataSource = dataSource
        self.userProfileProvider = dataSource.context.userProfileProvider
    }
    
    func loadData() {
        guard let userProfile = userProfileProvider.userProfile.value else {
            return
        }
        self.name.value = userProfile.name
        self.username.value = userProfile.userName
        self.bio.value = userProfile.biography
        guard let userImageData = userProfile.selectedImageData else {
            self.userProfileProvider.getImage(url: userProfile.profilePicture) { result in
                switch result {
                case .success(let image):
                    self.profileImage.value = image
                case .failure: ()
                }
            }
            return
        }
        profileImage.value = UIImage(data: userImageData)
    }
    
    func storeData() -> Bool {
        self.showNameError.value = false
        self.showUsernameError.value = false
        self.showBioError.value = false
        
        guard let name = self.name.value,
              !name.isEmpty else {
            self.showNameError.value = true
            return false
        }
        
        guard let username = self.username.value,
              !username.isEmpty else {
            self.showUsernameError.value = true
            return false
        }
        
        guard let bio = self.bio.value,
              !bio.isEmpty else {
            self.showBioError.value = true
            return false
        }
        userProfileProvider.updateUserProfileWith(name: name,
                                                  username: username,
                                                  bio: bio,
                                                  selectedImage: nil)
        return true
    }
}
