//
//  KantoProfileUserData.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit

struct KantoProfileUserDataSource: ViewModelDataSourceProtocol {
    
    var context: Context
    let userProfile: UserProfile
}

final class KantoProfileUserDataView: XibView {
    
    @IBOutlet private weak var profilePictureImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var biographyLabel: UILabel!
    @IBOutlet private weak var editProfileButton: UIButton!
    @IBOutlet private weak var followersLabel: UILabel!
    @IBOutlet private weak var followedLabel: UILabel!
    @IBOutlet private weak var viewsLabel: UILabel!
    
    private var dataSource: KantoProfileUserDataSource!
    private var imageProvider: UserProfileProvider!
    private var userProfile: UserProfile!
    
    func configure(with dataSource: KantoProfileUserDataSource) {
        self.dataSource = dataSource
        self.imageProvider = dataSource.context.userProfileProvider
        self.userProfile = dataSource.userProfile
        
        nameLabel.text = dataSource.userProfile.name
        usernameLabel.text = dataSource.userProfile.userName
        biographyLabel.text = dataSource.userProfile.biography
        followersLabel.text = String(dataSource.userProfile.followers)
        followedLabel.text = String(dataSource.userProfile.followed)
        viewsLabel.text = String(dataSource.userProfile.views)
        
        self.imageProvider.getImage(url: userProfile.profilePicture) { result in
            switch result {
            case .success(let image):
                self.profilePictureImageView.image = image
                self.profilePictureImageView.makeRounded()
            case .failure: ()
            }
        }
        
        editProfileButton.makeRounded(cornerRadius: 8)
    }
}
