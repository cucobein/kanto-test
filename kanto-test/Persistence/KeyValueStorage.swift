//
//  KeyValueStorage.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation

protocol KeyValueStorage {
    
    func string(forKey defaultName: String) -> String?
    func double(forKey defaultName: String) -> Double
    func data(forKey defaultName: String) -> Data?
    func set(_ value: Double, forKey defaultName: String)
    func set(_ value: Any?, forKey defaultName: String)
    func removeObject(forKey defaultName: String)
}
