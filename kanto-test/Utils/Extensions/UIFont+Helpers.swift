//
//  UIFont+Helpers.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit

enum AnimosaFontWeight: String {
    case bold = "Animosa-Bold"
    case extraBold = "Animosa-ExtraBold"
    case extraLight = "Animosa-ExtraLight"
    case light = "Animosa-Light"
    case regular = "Animosa-Regular"
}

extension UIFont {
    
    class func animosaBoldFont(withSize size: CGFloat) -> UIFont {
        animosaFont(.bold, size: size)
    }
    
    class func animosaExtraBoldFont(withSize size: CGFloat) -> UIFont {
        animosaFont(.extraBold, size: size)
    }
    
    class func animosaExtraLightFont(withSize size: CGFloat) -> UIFont {
        animosaFont(.extraLight, size: size)
    }
    
    class func animosaLightFont(withSize size: CGFloat) -> UIFont {
        animosaFont(.light, size: size)
    }
    
    class func animosaRegularFont(withSize size: CGFloat) -> UIFont {
        animosaFont(.regular, size: size)
    }
    
    private class func animosaFont(_ weight: AnimosaFontWeight, size: CGFloat) -> UIFont {
        UIFont(name: weight.rawValue, size: size)!
    }
}
