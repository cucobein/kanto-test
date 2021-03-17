//
//  UserProfile.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation
import RealmSwift

class UserProfile: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var userName: String = ""
    @objc dynamic var bio: String = ""
    @objc dynamic var followers: Int = 0
    @objc dynamic var followed: Int = 0
    @objc dynamic var views: Int = 0
    @objc dynamic var profilePicture: String = ""
}
