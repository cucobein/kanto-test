//
//  KantoProfileUserData.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit

final class KantoProfileUserDataViewModel {  }

final class KantoProfileUserData: XibView {
    
    @IBOutlet private weak var profilePictureImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var biographyLabel: UILabel!
    @IBOutlet private weak var editProfileButton: UIButton!
    @IBOutlet private weak var followersLabel: UILabel!
    @IBOutlet private weak var followedLabel: UILabel!
    @IBOutlet private weak var viewsLabel: UILabel!
    
    private var viewModel: KantoProfileUserDataViewModel!
    
    func configure(with viewModel: KantoProfileUserDataViewModel) {
        self.viewModel = viewModel
    }
}
