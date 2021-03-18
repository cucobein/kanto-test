//
//  KantoEditProfileViewModel.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import Foundation

struct KantoEditProfileViewModelDataSource: ViewModelDataSourceProtocol {
    
    let context: Context
}

final class KantoEditProfileViewModel: ViewModelProtocol {
    
    private let dataSource: KantoEditProfileViewModelDataSource
    private let router: KantoEditProfileRouter
    
    init(dataSource: KantoEditProfileViewModelDataSource, router: KantoEditProfileRouter) {
        self.router = router
        self.dataSource = dataSource
    }
}
