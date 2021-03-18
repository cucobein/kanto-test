//
//  KantoProfileViewModel.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import Foundation
import Bond

struct KantoProfileViewModelDataSource: ViewModelDataSourceProtocol {
    
    let context: Context
}

final class KantoProfileViewModel: ViewModelProtocol {
    
    private let dataSource: KantoProfileViewModelDataSource
    private let router: KantoProfileRouter
    private let userProfileProvider: UserProfileProvider
    let userData = Observable<KantoProfileUserDataSource?>(nil)
    let videos = MutableObservableArray<KantoVideoCellDataSource>([])
    
    init(dataSource: KantoProfileViewModelDataSource, router: KantoProfileRouter) {
        self.router = router
        self.dataSource = dataSource
        self.userProfileProvider = dataSource.context.userProfileProvider
        fetchData()
    }
}

private extension KantoProfileViewModel {
    
    func fetchData() {
        userProfileProvider.fetchUserDataProfile { [unowned self] (result) in
            switch result {
            case .success(let userData):
                self.userData.value = KantoProfileUserDataSource(context: self.dataSource.context,
                                                                 userData: userData)
            case .failure: ()
            }
        }
    }
}
