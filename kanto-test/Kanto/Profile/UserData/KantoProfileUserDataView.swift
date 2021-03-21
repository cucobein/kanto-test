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
    let editButtonHandler: () -> Void
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
        configureUI()
        loadImage()
        bindViews()
    }
}

private extension KantoProfileUserDataView {
    
    func configureUI() {
        nameLabel.text = userProfile.name
        usernameLabel.text = userProfile.userName
        biographyLabel.text = userProfile.biography
        followersLabel.text = String(userProfile.followers)
        followedLabel.text = String(userProfile.followed)
        viewsLabel.text = String(userProfile.views)
        editProfileButton.makeRounded(cornerRadius: 8)
    }
    
    func loadImage() {
        guard let userImageData = userProfile.selectedImageData else {
            self.imageProvider.getImage(url: userProfile.profilePicture) { result in
                switch result {
                case .success(let image):
                    self.profilePictureImageView.image = image
                    self.profilePictureImageView.makeRounded()
                case .failure: ()
                }
            }
            return
        }
        profilePictureImageView.image = UIImage(data: userImageData)
        profilePictureImageView.makeRounded()
    }
   
    func bindViews() {
        _ = editProfileButton.reactive.controlEvents(.touchUpInside).observeNext { [weak self] in
            guard let self = self else { return }
            self.dataSource.editButtonHandler()
        }
    }
}
