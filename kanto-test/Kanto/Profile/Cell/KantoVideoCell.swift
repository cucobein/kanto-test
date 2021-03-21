//
//  KantoVideoCell.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 18/03/21.
//

import UIKit
import AVKit
import Bond

struct KantoVideoCellDataSource: ViewModelDataSourceProtocol {
    
    var context: Context
    let video: VideoData
    var isPlaying = Observable(false)
}

final class KantoVideoCell: UITableViewCell {
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var songLabel: UILabel!
    @IBOutlet private weak var videoPreviewImageView: UIImageView!
    @IBOutlet private weak var videoPlayerImageView: UIImageView!
    @IBOutlet private weak var playButtonImageView: UIImageView!
    @IBOutlet private weak var likeImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var likesLabel: UILabel!
    
    private var isLike = true {
        didSet {
            if isLike {
                likeImageView.image = UIImage(named: "filledHeart")
            } else {
                likeImageView.image = UIImage(named: "emptyHeart")
            }
        }
    }
    private var dataSource: KantoVideoCellDataSource!
    private var imageProvider: UserProfileProvider!
    private var videoData: VideoData!
    private lazy var videoPlayer: AVPlayer? = {
        guard let url = videoData.recordVideo,
              let videoURL = URL(string: url) else {
            return nil
        }
        let player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoPlayerImageView.bounds
        self.videoPlayerImageView.layer.addSublayer(playerLayer)
        return player
    }()
    
    func configure(with dataSource: KantoVideoCellDataSource) {
        self.dataSource = dataSource
        self.imageProvider = dataSource.context.userProfileProvider
        self.videoData = dataSource.video
        
        userLabel.text = dataSource.video.user?.name
        songLabel.text = dataSource.video.songName
        likesLabel.text = String(dataSource.video.likes ?? 0)
        
        _ = dataSource.isPlaying.observeNext { isPlaying in
            if isPlaying {
                self.videoPreviewImageView.isHidden = true
                self.videoPlayerImageView.isHidden = false
                self.playButtonImageView.isHidden = true
                if self.videoPlayer?.timeControlStatus == .playing ||
                    self.videoPlayer?.timeControlStatus == .waitingToPlayAtSpecifiedRate {
                    return
                }
                self.videoPlayer?.seek(to: CMTime.zero)
                self.videoPlayer?.play()
                print(self.videoData.songName ?? "")
            } else {
                self.videoPreviewImageView.isHidden = false
                self.videoPlayerImageView.isHidden = true
                self.playButtonImageView.isHidden = false
                self.videoPlayer?.pause()
            }
        }
        
        _ = likeButton.reactive.controlEvents(.touchUpInside).observeNext { [weak self] in
            guard let self = self else { return }
            if self.isLike {
                self.isLike = false
            } else {
                self.isLike = true
            }
        }
        
        if let profilePicture = videoData.user?.profilePicture {
            self.imageProvider.getImage(url: profilePicture) { result in
                switch result {
                case .success(let image):
                    self.userImageView.image = image
                    self.userImageView.makeRounded()
                case .failure: ()
                }
            }
        }
        
        if let previewImg = videoData.previewImg {
            self.imageProvider.getImage(url: previewImg) { result in
                switch result {
                case .success(let image): self.videoPreviewImageView.image = image
                case .failure: ()
                }
            }
        }
    }
}
