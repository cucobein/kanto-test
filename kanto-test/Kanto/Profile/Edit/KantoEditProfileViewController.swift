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
        let streetNameRow = InputRow()
        let streetViewModel = InputRowViewModel(title: "Calle",
                                                placeHolderText: "Calle",
                                                showableError: "Ingresa el campo",
                                                maxCharCount: 50)
//        streetNameViewModel.neededHeightForDisplay.bind(to: viewModel.minHeightNeeded)
//        _ = viewModel.showStreetError.observeNext { (show) in
//            streetNameRow.error(visible: show)
//        }
        streetNameRow.configure(for: streetViewModel)
        contentStackView.addArrangedSubview(streetNameRow)
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
