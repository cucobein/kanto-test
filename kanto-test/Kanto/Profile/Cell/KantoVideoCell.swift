//
//  KantoVideoCell.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 18/03/21.
//

import UIKit

struct KantoVideoCellViewModel {  }

final class KantoVideoCell: UITableViewCell {
    
    private var viewModel: KantoVideoCellViewModel!
    
    func configure(with viewModel: KantoVideoCellViewModel) {
        self.viewModel = viewModel
    }
}
