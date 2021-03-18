//
//  Builder.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import Foundation

protocol BuilderProtocol {
    
    associatedtype ViewController
}

extension BuilderProtocol where Self.ViewController: ViewControllerProtocol {

    static func build(with dataSource: ViewController.ViewModel.DataSource) -> Self.ViewController {
        let viewController = ViewController.instantiate()
        let router = ViewController.ViewModel.Router(viewController: viewController)
        viewController.configure(with: ViewController.ViewModel(dataSource: dataSource, router: router))
        return viewController
    }
}
