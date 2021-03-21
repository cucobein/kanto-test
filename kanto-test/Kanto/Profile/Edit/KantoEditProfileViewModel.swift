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
    let profileImage = Observable<UIImage?>(nil)
    
    init(dataSource: KantoEditProfileViewModelDataSource, router: KantoEditProfileRouter) {
        self.router = router
        self.dataSource = dataSource
        self.userProfileProvider = dataSource.context.userProfileProvider
    }
    
    func loadImage() {
        guard let userProfile = userProfileProvider.userProfile.value else {
            return
        }
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
}
