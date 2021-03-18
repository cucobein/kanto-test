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
    
    // periphery:ignore
    var navigationController: KantoNavigationController? {
        return viewController?.navigationController as? KantoNavigationController
    }
    
//    func routeToAlert(with alertControllerViewModel: AlertControllerViewModel) {
//        let alertController = AlertControllerBuilder.buildAlertController(withViewModel: alertControllerViewModel)
//        viewController?.present(alertController, animated: true)
//    }
    
    func routeBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
//    @discardableResult
//    func routeBackToViewController(_ vcClass: UIViewController.Type, animated: Bool = true) -> Bool {
//        guard let navigationController = viewController?.navigationController else {
//            return false
//        }
//        let vcStack = navigationController.viewControllers
//        for vc in vcStack {
//            if vc.isKind(of: vcClass.self) {
//                navigationController.popToViewController(vc, animated: animated)
//                return true
//            }
//        }
//        return false
//    }
    
//    func push(viewController: UIViewController, isAlphaTransition: Bool = false) {
//        guard isAlphaTransition else {
//            self.viewController?.navigationController?.delegate = nil
//            self.viewController?.navigationController?.pushViewController(viewController, animated: true)
//            return
//        }
//        let delegate = NavigationDelegate()
//        self.viewController?.navigationController?.delegate = delegate
//        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
//    }
//
//    func pop() {
//        viewController?.navigationController?.popViewController(animated: true)
//    }
//
//    func pop(to: UIViewController, from: UIViewController, animated: Bool = true) {
//        guard let navigationController = from.navigationController else { return }
//        navigationController.viewControllers = [to, from]
//        navigationController.popViewController(animated: animated)
//    }
//
//    func routeToOTP(dataSource: CommerceOTPViewModelDataSource) {
//        push(viewController: CommerceOTPBuilder.build(with: dataSource))
//    }
//
//    func routetoDashboard(with viewModelDataSource: DashboardComercioViewModelDataSource) {
//        guard let navigationController = viewController?.navigationController else { return }
//        if navigationController.viewControllers.first is DashboardComercioViewController {
//            navigationController.popToRootViewController(animated: true)
//        } else {
//            let dashboard = DashboardComercioBuilder.build(with: viewModelDataSource)
//            navigationController.viewControllers = [dashboard, viewController!]
//            navigationController.popViewController(animated: true)
//        }
//    }
//
//    func displayLoadingIndicator(type: LoadingViewController.AnimationType = .loading) {
//        viewController?.displayLoadingView(traslucent: true, animationType: type)
//    }
//
//    func displayLoadingIndicator(traslucent: Bool) {
//        viewController?.displayLoadingView(traslucent: traslucent, animationType: .loading)
//    }
//
//    func hideLoadingIndicator() {
//        viewController?.dismissLoadingView()
//    }
//
//    func routeToError(with errorData: ErrorData) {
//        self.viewController?.present(ErrorBuilder.build(with: errorData), animated: true)
//    }
//
//    func routeToAlert(with dataSource: AlertViewModelDataSource) {
//        let alertVC = AlertBuilder.build(with: dataSource)
//        viewController?.present(alertVC, animated: true)
//    }
//
//    func routeToFeedBackAlert(with dataSource: FeedBackAlertViewModelDataSource) {
//        viewController?.present(FeedBackAlertBuilder.build(with: dataSource), animated: true, completion: nil)
//    }
//
//    func routeToDismiss(completion: (() -> Void)?) {
//        viewController?.dismiss(animated: true, completion: completion)
//    }
//
//    func routeError(dataSource: GenericErrorViewModelDataSource) {
//        let newViewController = GenericErrorBuilder.build(with: dataSource)
//        newViewController.modalPresentationStyle = .overFullScreen
//        self.viewController?.present(newViewController, animated: true)
//    }
//
//    func routeToFullScreenAlert(with dataSource: FullScreenAlertViewModelDataSource, isPushing: Bool = false) {
//        let alert = FullScreenAlertBuilder.build(with: dataSource)
//        if isPushing {
//            push(viewController: alert)
//        } else {
//            alert.modalPresentationStyle = .overFullScreen
//            viewController?.present(alert, animated: true, completion: nil)
//        }
//    }
}
