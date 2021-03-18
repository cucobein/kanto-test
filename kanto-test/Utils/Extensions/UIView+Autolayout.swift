//
//  UIView+Autolayout.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit

enum LayoutAnchor {
    case all
    case top
    case bottom
    case leading
    case trailing
    case vertical
    case horizontal
    struct Dimension: OptionSet {
        let rawValue: Int
        static let width = Dimension(rawValue: 1 << 0)
        static let height = Dimension(rawValue: 1 << 1)
    }
    struct Center: OptionSet {
        let rawValue: Int
        static let xAxis = Center(rawValue: 1 << 0)
        static let yAxis = Center(rawValue: 1 << 1)
    }
}

extension UIView {
    
    func pin(to view: UIView, anchor: LayoutAnchor = .all, margin: CGFloat = 0) {
        pin(toGuide: view, anchor: anchor, margin: margin)
    }
    
    func pin(toSafeAreaOf view: UIView, anchor: LayoutAnchor = .all, margin: CGFloat = 0) {
        pin(toGuide: view.safeAreaLayoutGuide, anchor: anchor, margin: margin)
    }
    
    private func pin(toGuide guide: AnyObject, anchor: LayoutAnchor = .all, margin: CGFloat = 0) {
        let top = (anchor == .all || anchor == .top || anchor == .vertical)
        let bottom = (anchor == .all || anchor == .bottom || anchor == .vertical)
        let leading = (anchor == .all || anchor == .leading || anchor == .horizontal)
        let trailing = (anchor == .all || anchor == .trailing || anchor == .horizontal)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: guide.topAnchor, constant: margin).isActive = top
        bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -margin).isActive = bottom
        leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: margin).isActive = leading
        trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -margin).isActive = trailing
    }
    
    func set(_ dimension: LayoutAnchor.Dimension, _ value: CGFloat ) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: value).isActive = (dimension == .width)
        heightAnchor.constraint(equalToConstant: value).isActive = (dimension == .height)
    }
    
    func setSize(_ width: CGFloat, _ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        set(.width, width)
        set(.height, height)
    }
    
    func center(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        center(to: view, axis: [.xAxis, .yAxis])
    }
    
    func center(to view: UIView, axis: LayoutAnchor.Center) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = axis.contains(.xAxis)
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = axis.contains(.yAxis)
    }
}
