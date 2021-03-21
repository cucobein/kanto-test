//
//  PersistenceController.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation
import RealmSwift
import ReactiveKit
import Bond

class PersistenceController {
    
    private let keyValueStorage: KeyValueStorage
    private let database: Realm
    private static let databaseEncryptionStorageKey = "dbKey"
    private static func generateDatabaseEncryptionKey() -> Data {
        let bytes = (0 ..< 64).map { _ in UInt8.random(in: 0..<255) }
        return bytes.withUnsafeBufferPointer { (buffer: UnsafeBufferPointer<UInt8>) -> Data in
            Data(buffer: buffer)
        }
    }
    
    private(set) var userProfile = Observable<UserProfile?>(nil)
    private(set) var userVideos = Observable<[UserVideo]?>(nil)
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
        var configuration = Realm.Configuration.defaultConfiguration
        if let databaseEncryptionKey = keyValueStorage.data(forKey: PersistenceController.databaseEncryptionStorageKey) {
            configuration.encryptionKey = databaseEncryptionKey
        } else {
            let newKey = PersistenceController.generateDatabaseEncryptionKey()
            keyValueStorage.set(newKey, forKey: PersistenceController.databaseEncryptionStorageKey)
            configuration.encryptionKey = newKey
        }
        do {
            database = try Realm(configuration: configuration)
            loadObjects()
        } catch {
            do {
                configuration.deleteRealmIfMigrationNeeded = true
                database = try Realm(configuration: configuration)
                loadObjects()
            } catch {
                fatalError("Unable to load database: \(error)")
            }
        }
    }
    
    func storeUserProfile(with userData: UserData) {
        guard userProfile.value == nil else { return }
        let userProfile = UserProfile()
        userProfile.name = userData.name ?? ""
        userProfile.userName = userData.userName ?? ""
        userProfile.profilePicture = userData.profilePicture ?? ""
        userProfile.biography = userData.biography ?? ""
        userProfile.followers = userData.followers ?? 0
        userProfile.followed = userData.followed ?? 0
        userProfile.views = userData.views ?? 0
        do {
            try database.write {
                database.add(userProfile)
            }
            self.userProfile.value = userProfile
        } catch {
            fatalError("Unable to save in database: \(error)")
        }
    }
    
    func updateUserProfileWith(name: String, username: String, bio: String, selectedImage: Data?) {
        guard let currentUser = userProfile.value else { return }
        let userProfile = UserProfile()
        userProfile.name = name
        userProfile.userName = username
        userProfile.profilePicture = currentUser.profilePicture
        userProfile.biography = bio
        userProfile.followers = currentUser.followers
        userProfile.followed = currentUser.followed
        userProfile.views = currentUser.views
        if selectedImage != nil {
            userProfile.selectedImageData = selectedImage
        } else {
            userProfile.selectedImageData = currentUser.selectedImageData
        }
        
        do {
            
            try database.write {
                database.delete(database.objects(UserProfile.self))
                database.add(userProfile)
            }
            self.userProfile.value = userProfile
        } catch {
            fatalError("Unable to save in database: \(error)")
        }
    }
    
    func storeUserVideos(with dataOfVideos: [VideoData]) {
        if let vids = userVideos.value, !vids.isEmpty {
            return
        }
        var userVideos = [UserVideo]()
        for videoData in dataOfVideos {
            let userVideo = UserVideo()
            userVideo.name = videoData.user?.name ?? ""
            userVideo.userName = videoData.user?.userName ?? ""
            userVideo.profilePicture = videoData.user?.profilePicture ?? ""
            userVideo.songName = videoData.songName ?? ""
            userVideo.recordVideo = videoData.recordVideo ?? ""
            userVideo.previewImg = videoData.previewImg ?? ""
            userVideo.likes = videoData.likes ?? 0
            userVideo.liked = false
            userVideos.append(userVideo)
        }
        database.beginWrite()
        do {
            userVideos.forEach { database.add($0) }
            try database.commitWrite()
            self.userVideos.value = userVideos
        } catch {
            fatalError("Unable to save in database: \(error)")
        }
    }
    
    func toggleUserVideoLikes(with userVideo: UserVideo) {
        do {
            try database.write {
                if userVideo.liked {
                    userVideo.liked = false
                    if userVideo.likes > 0 { userVideo.likes -= 1 }
                } else {
                    userVideo.liked = true
                    userVideo.likes += 1
                }
            }
        } catch {
            fatalError("Unable to save in database: \(error)")
        }
    }
}

private extension PersistenceController {
    
    func loadObjects() {
        retrieveUserProfile()
        retrieveUserVideos()
    }
    
    func retrieveUserProfile() {
        userProfile = Observable(database.objects(UserProfile.self).first)
    }
    
    func retrieveUserVideos() {
        userVideos = Observable(Array(database.objects(UserVideo.self)))
    }
}
