//
//  KantoProfileUserData.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit
import Bond

struct KantoProfileUserDataSource: ViewModelDataSourceProtocol {
    
    var context: Context
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
    private var userProfileProvider: UserProfileProvider!
    
    func configure(with dataSource: KantoProfileUserDataSource) {
        self.dataSource = dataSource
        self.userProfileProvider = dataSource.context.userProfileProvider
        configureUI()
        bindViews()
    }
}

private extension KantoProfileUserDataView {
    
    func configureUI() {
        editProfileButton.makeRounded(cornerRadius: 8)
        profilePictureImageView.makeRounded()
    }

    func bindViews() {
        _ = userProfileProvider.userProfile.observeNext(with: { userProfile in
            guard let userProfile = userProfile else { return }
            self.nameLabel.text = userProfile.name
            self.usernameLabel.text = userProfile.userName
            self.biographyLabel.text = userProfile.biography
            self.followersLabel.text = String(userProfile.followers)
            self.followedLabel.text = String(userProfile.followed)
            self.viewsLabel.text = String(userProfile.views)
            guard let userImageData = userProfile.selectedImageData else {
                self.userProfileProvider.getImage(url: userProfile.profilePicture) { result in
                    switch result {
                    case .success(let image):
                        self.profilePictureImageView.image = image
                    case .failure: ()
                    }
                }
                return
            }
            self.profilePictureImageView.image = UIImage(data: userImageData)
        })
        
        _ = editProfileButton.reactive.controlEvents(.touchUpInside).observeNext { [weak self] in
            guard let self = self else { return }
            self.dataSource.editButtonHandler()
        }
    }
}
