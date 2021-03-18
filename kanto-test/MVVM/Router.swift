//
//  Router.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit

protocol RouterProtocol {
    
    var viewController: UIViewController? { get }
    init(viewController: UIViewController)
    func routeBack()
}

extension RouterProtocol {
    
    var navigationController: KantoNavigationController? {
        return viewController?.navigationController as? KantoNavigationController
    }
    
    func routeBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
