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
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
        var configuration = Realm.Configuration.defaultConfiguration
//        configuration.schemaVersion = UInt64(Int(VersionManager.currentVersion()) ?? 1)
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
}

private extension PersistenceController {
    
    func loadObjects() { }
}
