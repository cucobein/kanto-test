//
//  Video.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 20/03/21.
//

import Foundation
import RealmSwift

class UserVideo: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var userName: String = ""
    @objc dynamic var profilePicture: String = ""
    @objc dynamic var songName: String = ""
    @objc dynamic var recordVideo: String = ""
    @objc dynamic var previewImg: String = ""
    @objc dynamic var likes: Int = 0
    @objc dynamic var liked: Bool = false
}
