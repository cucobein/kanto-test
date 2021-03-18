//
//  ProfileViewController.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import UIKit
import Bond

private enum UserPanelState {
    case hidden
    case shown
}

class KantoProfileViewController: UIViewController, ViewControllerProtocol {

    @IBOutlet private weak var userDataPanelView: RoundedCornersView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var gearButton: UIButton!
    @IBOutlet private weak var panelHeightConstraint: NSLayoutConstraint!
    
    private var viewModel: KantoProfileViewModel!
    private var userPanelState = UserPanelState.shown
    private var userData: KantoProfileUserData?
    
    func configure(with viewModel: KantoProfileViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
        addUserDataPanel()
    }
}

private extension KantoProfileViewController {
    
    func bindViews() {
        
        _ = gearButton.reactive.controlEvents(.touchUpInside).observeNext { [weak self] in
            guard let self = self else { return }
            if self.userPanelState == .shown {
                self.removeUserDataPanel()
                UIView.animate(withDuration: 0.5) {
                    self.panelHeightConstraint.constant = 40
                    self.userDataPanelView.alpha = 0
                    self.userPanelState = .hidden
                    self.view.layoutIfNeeded()
                }
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.panelHeightConstraint.constant = 340
                    self.userDataPanelView.alpha = 1
                    self.userPanelState = .shown
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    self.addUserDataPanel()
                })
            }
        }
    }
    
    func addUserDataPanel() {
        userData = KantoProfileUserData()
        if let userData = userData {
            userData.configure(with: KantoProfileUserDataViewModel())
            userDataPanelView.addSubview(userData)
            userData.pin(to: userDataPanelView)
        }
    }
    
    func removeUserDataPanel() {
        if let userData = userData {
            userData.removeFromSuperview()
            self.userData = nil
        }
    }
}
