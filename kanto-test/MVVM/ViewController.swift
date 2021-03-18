//
//  ViewController.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit

protocol ViewControllerProtocol: UIViewController {
    
    associatedtype ViewModel: ViewModelProtocol
    func configure(with viewModel: ViewModel)
    static func instantiate() -> Self
}

extension ViewControllerProtocol {
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as! Self
    }
}

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
