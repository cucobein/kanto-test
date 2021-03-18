//
//  KantoEditProfileRouter.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit

final class KantoEditProfileRouter: RouterProtocol {
    
    internal weak var viewController: UIViewController?
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
}
