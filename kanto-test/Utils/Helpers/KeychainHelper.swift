//
//  KeychainHelper.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation

class KeychainHelper: KeyValueStorage {
    
    private var serviceName: String
    private var accessGroup: String?
    private static let defaultServiceName: String = {
        let seriveName = Bundle.main.bundleIdentifier ?? "KeychainHelper"
        return seriveName
    }()

    convenience init() {
        self.init(serviceName: KeychainHelper.defaultServiceName)
    }

    init(serviceName: String, accessGroup: String? = nil) {
        self.serviceName = serviceName
        self.accessGroup = accessGroup
    }

    /// Returns the string associated with the specified key.
    ///
    /// - parameter defaultName: The key associated with the string.
    func string(forKey defaultName: String) -> String? {
        guard let keychainData = internalData(forKey: defaultName) else { return nil }
        return String(data: keychainData, encoding: String.Encoding.utf8) as String?
    }

    /// Returns the double value associated with the specified key.
    ///
    /// - parameter defaultName: The key associated with value.
    func double(forKey defaultName: String) -> Double {
        guard let numberValue = object(forKey: defaultName) as? NSNumber else { return 0 }
        return numberValue.doubleValue
    }
    
    /// Returns the Data value associated with the specified key.
    ///
    /// - parameter defaultName: The key associated with value.
    func data(forKey defaultName: String) -> Data? {
        internalData(forKey: defaultName)
    }

    /// Save a double value to the keychain associated with a specified key. If data already exists for the given key, the data will be overwritten with the new value.
    ///
    /// - parameter value: The double value to save.
    /// - parameter defaultName: The key associated with value.
    func set(_ value: Double, forKey defaultName: String) {
        set(NSNumber(value: value), forKey: defaultName)
    }

    /// Save a NSCoding object to the keychain associated with a specified key. If data already exists for the given key, the data will be overwritten with the new value.
    ///
    /// - parameter value: The NSCoding object to save.
    /// - parameter defaultName: The key associated with value.
    func set(_ value: NSCoding, forKey defaultName: String) {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false) {
            internalSet(data, forKey: defaultName)
        }
    }

    /// Save the Any value to the keychain associated with a specified key. If data already exists for the given key, the data will be overwritten with the new value.
    ///
    /// - parameter value: The value to save.
    /// - parameter defaultName: The key associated with value.
    func set(_ value: Any?, forKey defaultName: String) {
        if let data = (value as? String)?.data(using: .utf8) {
            internalSet(data, forKey: defaultName)
        } else if let data = value as? Data {
            internalSet(data, forKey: defaultName)
        } else {
            fatalError("Unsupported type")
        }
    }

    /// Remove an object associated with a specified key.
    ///
    /// - parameter defaultName: The key value to remove data for.
    func removeObject(forKey defaultName: String) {
        let keychainQueryDictionary: [String: Any] = setupKeychainQueryDictionary(forKey: defaultName)
        SecItemDelete(keychainQueryDictionary as CFDictionary)
    }

    // MARK: - Private functions
    private func object(forKey key: String) -> NSCoding? {
        guard let keychainData = internalData(forKey: key) else { return nil }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(keychainData) as? NSCoding
    }

    private func internalData(forKey key: String) -> Data? {
        var keychainQueryDictionary = setupKeychainQueryDictionary(forKey: key)
        keychainQueryDictionary[kSecMatchLimit as String] = kSecMatchLimitOne
        keychainQueryDictionary[kSecReturnData as String] = kCFBooleanTrue

        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQueryDictionary as CFDictionary, &result)

        return status == noErr ? result as? Data : nil
    }

    private func internalSet(_ value: Data, forKey key: String) {
        var keychainQueryDictionary: [String: Any] = setupKeychainQueryDictionary(forKey: key)
        keychainQueryDictionary[kSecValueData as String] = value

        let status: OSStatus = SecItemAdd(keychainQueryDictionary as CFDictionary, nil)
        if status == errSecDuplicateItem {
            update(value, forKey: key)
        }
    }

    private func update(_ value: Data, forKey key: String) {
        let keychainQueryDictionary: [String: Any] = setupKeychainQueryDictionary(forKey: key)
        let updateDictionary = [kSecValueData as String: value]
        SecItemUpdate(keychainQueryDictionary as CFDictionary, updateDictionary as CFDictionary)
    }

    private func setupKeychainQueryDictionary(forKey key: String) -> [String: Any] {
        var keychainQueryDictionary: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
        keychainQueryDictionary[kSecAttrService as String] = serviceName

        if let accessGroup = accessGroup {
            keychainQueryDictionary[kSecAttrAccessGroup as String] = accessGroup
        }

        let encodedIdentifier: Data? = key.data(using: String.Encoding.utf8)
        keychainQueryDictionary[kSecAttrGeneric as String] = encodedIdentifier
        keychainQueryDictionary[kSecAttrAccount as String] = encodedIdentifier

        return keychainQueryDictionary
    }
}
