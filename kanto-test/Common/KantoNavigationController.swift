//
//  KantoNavigationController.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit

enum NavigationBarStyle {
    
    case clear
}

protocol ViewControllerNavigationStyle {
    var navigationBarStyle: NavigationBarStyle { get }
}

class KantoNavigationController: UINavigationController {

    static func navigationController() -> KantoNavigationController {
        let navController = KantoNavigationController()
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.tintColor = .white
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.animosaBoldFont(withSize: 17)
        ]
        navController.navigationBar.titleTextAttributes = textAttributes
        navController.delegate = navController
        return navController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        viewControllers.last?.preferredStatusBarStyle ?? .default
    }
    
    func adjustNavigationBar(forViewController viewController: UIViewController) {
        if let viewControllerNavigationStyle = viewController as? ViewControllerNavigationStyle {
            adjustNavigationBar(forStyle: viewControllerNavigationStyle.navigationBarStyle)
        } else {
            adjustNavigationBar(forStyle: .clear)
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        interactivePopGestureRecognizer?.isEnabled = false
    }
}

extension KantoNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    // First view controller. You may be unable to push the next one
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}

extension KantoNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        adjustNavigationBar(forViewController: viewController)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func adjustNavigationBar(forStyle style: NavigationBarStyle) {
        let textColor: UIColor
        textColor = .gray
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: UIFont.animosaBoldFont(withSize: 17)
        ]
        navigationBar.barTintColor = .clear
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
