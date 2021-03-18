//
//  StoryboardInstantiable.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import UIKit

protocol StoryboardInstantiable {
    
    static func instantiate(from storyboard: Storyboard) -> Self
}

extension StoryboardInstantiable where Self: UIViewController {
    
    static func instantiate(from storyboard: Storyboard) -> Self {
        let moduleClassName = NSStringFromClass(self)
        let className = moduleClassName.components(separatedBy: ".").last!
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
