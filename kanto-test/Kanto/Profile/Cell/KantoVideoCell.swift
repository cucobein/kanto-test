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
    let video: UserVideo
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
    @IBOutlet private weak var likesLabel: UILabel!
    
    private var dataSource: KantoVideoCellDataSource!
    private var userProfileProvider: UserProfileProvider!
    private var videoData: UserVideo!
    private lazy var videoPlayer: AVPlayer? = {
        guard let videoURL = URL(string: videoData.recordVideo) else {
            return nil
        }
        let player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = self.videoPlayerImageView.bounds
        self.videoPlayerImageView.layer.addSublayer(playerLayer)
        return player
    }()
    
    func configure(with dataSource: KantoVideoCellDataSource) {
        self.dataSource = dataSource
        self.userProfileProvider = dataSource.context.userProfileProvider
        self.videoData = dataSource.video
        
        userLabel.text = dataSource.video.name
        songLabel.text = dataSource.video.songName
        updateLikes()
        
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
                print(self.videoData.songName)
            } else {
                self.videoPreviewImageView.isHidden = false
                self.videoPlayerImageView.isHidden = true
                self.playButtonImageView.isHidden = false
                self.videoPlayer?.pause()
            }
        }

        _ = likeImageView.reactive.tapGesture().observeNext { [unowned self] _ in
            self.userProfileProvider.toggleUserVideoLikes(with: self.videoData)
            self.updateLikes()
        }

        self.userProfileProvider.getImage(url: videoData.profilePicture) { result in
            switch result {
            case .success(let image):
                self.userImageView.image = image
                self.userImageView.makeRounded()
            case .failure: ()
            }
        }
        
        self.userProfileProvider.getImage(url: videoData.previewImg) { result in
            switch result {
            case .success(let image): self.videoPreviewImageView.image = image
            case .failure: ()
            }
        }
    }
}

private extension KantoVideoCell {
    
    func updateLikes() {
        if self.videoData.liked {
            self.likeImageView.image = UIImage(named: "filledHeart")
        } else {
            self.likeImageView.image = UIImage(named: "emptyHeart")
        }
        self.likesLabel.text = String(self.videoData.likes)
        print("\(self.videoData.songName) - \(self.videoData.likes) likes")
    }
}
