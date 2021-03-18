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
    private var userDataView: KantoProfileUserDataView?
    
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
        
        _ = viewModel.userData.observeNext { [weak self] in
            guard let self = self,
                  let data = $0 else { return }
            if let userDataView = self.userDataView {
                userDataView.configure(with: data)
            } else {
                self.addUserDataPanel()
            }
        }
        
        viewModel.videos.bind(to: tableView, cellType: KantoVideoCell.self) { $0.configure(with: $1) }
    }
    
    func addUserDataPanel() {
        if let data = viewModel.userData.value {
            userDataView = KantoProfileUserDataView()
            guard let userDataView = userDataView else {
                return
            }
            userDataView.configure(with: data)
            userDataPanelView.addSubview(userDataView)
            userDataView.pin(to: userDataPanelView)
        }
    }
    
    func removeUserDataPanel() {
        if let userDataView = userDataView {
            userDataView.removeFromSuperview()
            self.userDataView = nil
        }
    }
}
