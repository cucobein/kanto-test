//
//  ViewModel.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import Foundation

protocol ViewModelProtocol: class {
    
    associatedtype DataSource: ViewModelDataSourceProtocol
    associatedtype Router: RouterProtocol

    init(dataSource: DataSource, router: Router)
}
