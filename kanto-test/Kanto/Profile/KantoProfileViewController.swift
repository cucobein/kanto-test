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
    }
}

private extension KantoProfileViewController {
    
    func bindViews() {
        _ = gearButton.reactive.controlEvents(.touchUpInside).observeNext { [weak self] in
            guard let self = self else { return }
            self.userPanelState == .shown ?
                self.hidePanel() : self.showPanel()
        }
        
        _ = viewModel.userData.observeNext { [weak self] in
            guard let self = self,
                  let data = $0 else { return }
            self.userDataView != nil ?
                self.userDataView?.configure(with: data) : self.addUserDataPanel()
        }
        
        viewModel.videos.bind(to: tableView, cellType: KantoVideoCell.self) {
            $0.backgroundColor = .clear
            $0.configure(with: $1)
        }
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
    
    func hidePanel() {
        self.userPanelState = .hidden
        self.removeUserDataPanel()
        UIView.animate(withDuration: 0.5) {
            self.panelHeightConstraint.constant = 40
            self.userDataPanelView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func showPanel() {
        self.userPanelState = .shown
        viewModel.stopPlayingVideos()
        UIView.animate(withDuration: 0.5, animations: {
            self.panelHeightConstraint.constant = 340
            self.userDataPanelView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.addUserDataPanel()
        })
    }
}

extension KantoProfileViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if userPanelState == .shown { hidePanel() }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let center = CGPoint(x: self.tableView.bounds.width / 2.0,
                             y: self.tableView.bounds.height / 2.0)
        var centerCell = tableView.visibleCells[0]
        for cell in tableView.visibleCells {
            let centerCellDiff = abs(centerCell.center.y - center.y - tableView.contentOffset.y)
            let cellDiff = abs(cell.center.y - center.y - tableView.contentOffset.y)
            if cellDiff < centerCellDiff { centerCell = cell }
        }
        if let centerCellIndexPath = tableView.indexPath(for: centerCell) {
            viewModel.playVideoOnCell(index: centerCellIndexPath.row)
        }
    }
}
