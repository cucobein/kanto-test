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
    
    let nameRow = InputRow()
    let usernameRow = InputRow()
    let bioRow = InputRow()
    
    func configure(with viewModel: KantoEditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupInputs()
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotificatinos()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterForKeyboardNotifications()
    }
}

private extension KantoEditProfileViewController {
    
    func loadData() {
        viewModel.loadData()
    }
    
    func setupInputs() {
        
        let nameViewModel = InputRowViewModel(title: "Name",
                                              placeHolderText: "Name",
                                              selectedOption: viewModel.name,
                                              showableError: "Ingresa el valor del nombre",
                                              maxCharCount: 24)
        nameViewModel.neededHeightForDisplay.bind(to: viewModel.minHeightNeeded)
        _ = viewModel.showNameError.observeNext { (show) in
            self.nameRow.error(visible: show)
        }
        nameRow.configure(for: nameViewModel)
        contentStackView.addArrangedSubview(nameRow)

        let usernameViewModel = InputRowViewModel(title: "Username",
                                              placeHolderText: "Username",
                                              selectedOption: viewModel.username,
                                              showableError: "Ingresa el valor del username",
                                              maxCharCount: 24)
        usernameViewModel.neededHeightForDisplay.bind(to: viewModel.minHeightNeeded)
        _ = viewModel.showUsernameError.observeNext { (show) in
            self.usernameRow.error(visible: show)
        }
        usernameRow.configure(for: usernameViewModel)
        contentStackView.addArrangedSubview(usernameRow)
        
        let bioViewModel = InputRowViewModel(title: "Biography",
                                              placeHolderText: "Biography",
                                              selectedOption: viewModel.bio,
                                              showableError: "Ingresa el valor del bio",
                                              maxCharCount: 32)
        bioViewModel.neededHeightForDisplay.bind(to: viewModel.minHeightNeeded)
        _ = viewModel.showBioError.observeNext { (show) in
            self.bioRow.error(visible: show)
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
            self.dismiss(animated: true,
                         completion: nil)
        }
        
        _ = saveButton.reactive.controlEvents(.touchUpInside).observeNext { [weak self] in
            guard let self = self else { return }
            if self.viewModel.storeData() { self.dismiss(animated: true,
                                                         completion: nil)}
        }
        
        _ = galleryButton.reactive.controlEvents(.touchUpInside).observeNext { [weak self] in
//            guard let self = self else { return }
//            self.dismiss(animated: true, completion: nil)
        }
        
        _ = cameraButton.reactive.controlEvents(.touchUpInside).observeNext { [weak self] in
//            guard let self = self else { return }
//            self.dismiss(animated: true, completion: nil)
        }
        
        _ = scrollView.reactive.tapGesture().observeNext { _ in
            self.view.endEditing(true)
        }
    }
}

private extension KantoEditProfileViewController {
    
    func registerForKeyboardNotificatinos() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInsets(withNotification:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInsets(withNotification:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func adjustInsets(withNotification notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let frameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber ?? NSNumber(value: 0.5)
        let screenHeight = UIScreen.main.bounds.height
        let keyBoardHeight = screenHeight - frameEnd.minY
        let inset = keyBoardHeight == 0 ? 0 : keyBoardHeight + 8
        let offset = inset - (scrollView.bounds.height - scrollView.contentSize.height)
        UIView.animate(withDuration: animationDuration.doubleValue) { [weak self] in
            self?.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
            self?.scrollView.contentOffset = CGPoint(x: 0, y: max(0, offset - 80))
        }
    }
}
