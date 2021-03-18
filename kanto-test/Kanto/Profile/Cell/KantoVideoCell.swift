//
//  KantoVideoCell.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 18/03/21.
//

import UIKit

struct KantoVideoCellDataSource: ViewModelDataSourceProtocol {
    
    var context: Context
    let video: VideoData
}

final class KantoVideoCell: UITableViewCell {
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var songLabel: UILabel!
    @IBOutlet private weak var videoPreviewImageView: UIImageView!
    @IBOutlet private weak var videoPlayerView: UIView!
    @IBOutlet private weak var playButtonImageView: UIImageView!
    @IBOutlet private weak var likeImageView: UIImageView!
    @IBOutlet private weak var likesLabel: UILabel!
    private var dataSource: KantoVideoCellDataSource!
    
    func configure(with dataSource: KantoVideoCellDataSource) {
        self.dataSource = dataSource
        
        userLabel.text = dataSource.video.user?.name
        songLabel.text = dataSource.video.songName
        likesLabel.text = String(dataSource.video.likes ?? 0)
    }
}
