//
//  ApplicationCoordinator.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import UIKit

class ApplicationCoordinator {
    
    private let apiService = ApiService()
    private let keyValueStorage = KeychainHelper()
    lazy var persistenceController: PersistenceController = {
        PersistenceController(keyValueStorage: keyValueStorage)
    }()
    private(set) lazy var context: Context = {
        Context(apiService: apiService,
                persistenceController: persistenceController)
    }()
    
    func initialize(on window: UIWindow) {
        startApplication(on: window)
    }
}

extension ApplicationCoordinator {
    
    func startApplication(on window: UIWindow) {
        let navigationController = KantoNavigationController.navigationController()
        let launchScreen = KantoLaunchScreenViewController.instantiate(from: .launchScreen)
        window.rootViewController = navigationController
        let dispatchGroup = DispatchGroup()
        window.rootViewController = navigationController
        dispatchGroup.enter()
        launchScreen.animationFinishedHandler = {
            dispatchGroup.leave()
        }
        navigationController.viewControllers = [launchScreen]
        dispatchGroup.notify(queue: .main) {
            self.startProfileFlow(on: navigationController)
        }
    }
}

private extension ApplicationCoordinator {
    
    func startProfileFlow(on navigationController: UINavigationController) {
//        let dashboardComercioBuilder = DashboardComercioBuilder.build(with: DashboardComercioViewModelDataSource(context: context))
//        let viewcontrollers = [dashboardComercioBuilder, navigationController.viewControllers.last!]
//        navigationController.viewControllers = viewcontrollers
//        navigationController.popViewController(animated: false)
    }
}
