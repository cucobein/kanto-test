//
//  KantoProfileViewModel.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import Foundation

struct KantoProfileViewModelDataSource: ViewModelDataSourceProtocol {
    
    let context: Context
}

final class KantoProfileViewModel: ViewModelProtocol {
    
    private let dataSource: KantoProfileViewModelDataSource
    private let router: KantoProfileRouter
    
    init(dataSource: KantoProfileViewModelDataSource, router: KantoProfileRouter) {
        self.router = router
        self.dataSource = dataSource
    }
}
