//
//  KantoProfileUserData.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit

struct KantoProfileUserDataSource: ViewModelDataSourceProtocol {
    
    var context: Context
    let userData: UserData
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
    
    func configure(with dataSource: KantoProfileUserDataSource) {
        self.dataSource = dataSource
        
        nameLabel.text = dataSource.userData.name
        usernameLabel.text = dataSource.userData.userName
        biographyLabel.text = dataSource.userData.biography
        followersLabel.text = String(dataSource.userData.followers ?? 0)
        followedLabel.text = String(dataSource.userData.followed ?? 0)
        viewsLabel.text = String(dataSource.userData.views ?? 0)
    }
}
