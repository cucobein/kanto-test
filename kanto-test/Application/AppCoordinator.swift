//
//  AppCoordinator.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import UIKit

class AppCoordinator {
    
    private let apiService = ApiService()
    private let keyValueStorage = KeychainHelper()
    private lazy var persistenceController: PersistenceController = {
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

extension AppCoordinator {
    
    func startApplication(on window: UIWindow) {
        let navigationController = KantoNavigationController.navigationController()
        let launchScreen = KantoLaunchScreenViewController.instantiate(from: .launchScreen)
        window.rootViewController = navigationController
        let dispatchGroup = DispatchGroup()
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

private extension AppCoordinator {
    
    func startProfileFlow(on navigationController: UINavigationController) {
        let profileViewController = KantoProfileBuilder.build(with: KantoProfileViewModelDataSource(context: context))
        navigationController.viewControllers = [profileViewController, navigationController.viewControllers.last!]
        navigationController.popViewController(animated: false)
    }
}
