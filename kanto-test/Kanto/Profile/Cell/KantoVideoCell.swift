//
//  KantoVideoCell.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 18/03/21.
//

import UIKit

struct KantoVideoCellDataSource: ViewModelDataSourceProtocol {
    
    var context: Context
}

final class KantoVideoCell: UITableViewCell {
    
    private var dataSource: KantoVideoCellDataSource!
    
    func configure(with dataSource: KantoVideoCellDataSource) {
        self.dataSource = dataSource
    }
}
