//
//  EditProfileViewController.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import UIKit

class KantoEditProfileViewController: UIViewController, ViewControllerProtocol {

    private var viewModel: KantoEditProfileViewModel!
    
    func configure(with viewModel: KantoEditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
