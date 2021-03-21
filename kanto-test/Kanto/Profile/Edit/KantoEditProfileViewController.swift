//
//  EditProfileViewController.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import UIKit

class KantoEditProfileViewController: UIViewController, ViewControllerProtocol {

    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var galleryButton: UIButton!
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentStackView: UIStackView!
    
    private var viewModel: KantoEditProfileViewModel!
    
    func configure(with viewModel: KantoEditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        loadInputs()
        bindViews()
    }
}

private extension KantoEditProfileViewController {
    
    func loadImage() {
        viewModel.loadImage()
    }
    
    func loadInputs() {
        let nameRow = InputRow()
        let nameViewModel = InputRowViewModel(title: "Name",
                                              placeHolderText: "Name",
                                              showableError: "Ingresa el valor del nombre",
                                              maxCharCount: 24)
        nameViewModel.neededHeightForDisplay.bind(to: viewModel.minHeightNeeded)
        _ = viewModel.showNameError.observeNext { (show) in
            nameRow.error(visible: show)
        }
        nameRow.configure(for: nameViewModel)
        contentStackView.addArrangedSubview(nameRow)

        let usernameRow = InputRow()
        let usernameViewModel = InputRowViewModel(title: "Username",
                                              placeHolderText: "Username",
                                              showableError: "Ingresa el valor del username",
                                              maxCharCount: 24)
        usernameViewModel.neededHeightForDisplay.bind(to: viewModel.minHeightNeeded)
        _ = viewModel.showNameError.observeNext { (show) in
            usernameRow.error(visible: show)
        }
        usernameRow.configure(for: usernameViewModel)
        contentStackView.addArrangedSubview(usernameRow)
        
        let bioRow = InputRow()
        let bioViewModel = InputRowViewModel(title: "Biography",
                                              placeHolderText: "Biography",
                                              showableError: "Ingresa el valor del bio",
                                              maxCharCount: 32)
        bioViewModel.neededHeightForDisplay.bind(to: viewModel.minHeightNeeded)
        _ = viewModel.showNameError.observeNext { (show) in
            bioRow.error(visible: show)
        }
        bioRow.configure(for: bioViewModel)
        contentStackView.addArrangedSubview(bioRow)
    }
    
    func bindViews() {
        
        _ = viewModel.profileImage.observeNext { image in
            if let image = image {
                self.profileImageView.image = image
                self.profileImageView.makeRounded()
            }
        }
            
        _ = closeButton.reactive.controlEvents(.touchUpInside).observeNext { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        
        _ = saveButton.reactive.controlEvents(.touchUpInside).observeNext { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        
        _ = galleryButton.reactive.controlEvents(.touchUpInside).observeNext { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        
        _ = cameraButton.reactive.controlEvents(.touchUpInside).observeNext { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
