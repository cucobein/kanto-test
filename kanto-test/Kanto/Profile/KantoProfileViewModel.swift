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
    
    func stopPlayingVideos() {
        videos.value.collection.forEach { $0.isPlaying.value = false }
    }
    
    func playVideoOnCell(index: Int) {
        stopPlayingVideos()
        videos.value.collection[index].isPlaying.value = true
    }
}

private extension KantoProfileViewModel {
    
    func fetchData() {
        userProfileProvider.fetchUserDataProfile { [unowned self] (result) in
            switch result {
            case .success:
                let editDataSource = KantoEditProfileViewModelDataSource(context: self.dataSource.context)
                self.userData.value = KantoProfileUserDataSource(context: self.dataSource.context,
                                                                 editButtonHandler: {
                                                                    self.router.routeToEditProfile(with: editDataSource)
                                                                 })
            case .failure: ()
            }
        }
        userProfileProvider.fetchUserVideos { [unowned self] (result) in
            switch result {
            case .success(let userVideos):
                if let userVideos = userVideos {
                    let videos = userVideos.map({ video -> KantoVideoCellDataSource in
                        return KantoVideoCellDataSource(context: self.dataSource.context, video: video)
                    })
                    self.videos.replace(with: videos)
                }
            case .failure: ()
            }
        }
    }
}
