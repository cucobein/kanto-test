//
//  KantoProfileRouter.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit

final class KantoProfileRouter: RouterProtocol {
    
    internal weak var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func routeToEditProfile(with dataSource: KantoEditProfileViewModelDataSource) {
        let vc = KantoEditProfileBuilder.build(with: dataSource)
        vc.modalPresentationStyle = .overFullScreen
        viewController?.present(vc, animated: true, completion: nil)
    }
}
