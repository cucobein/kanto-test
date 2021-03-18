//
//  RounderCornersView.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 18/03/21.
//

import UIKit

@IBDesignable
class RoundedCornersView: UIView {

    @IBInspectable
    var leftColor: UIColor = UIColor.clear {
        didSet { setupBackground() }
    }
    @IBInspectable
    var rightColor: UIColor = UIColor.clear {
        didSet { setupBackground() }
    }
    @IBInspectable
    var backgroundImage: UIImage? {
        didSet { setupBackground() }
    }
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet { setupCorners() }
    }
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet { setupCorners() }
    }
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet { setupCorners() }
    }
    @IBInspectable
    var shadowOpacity: CGFloat = 0.0 {
        didSet { setupCorners() }
    }
    @IBInspectable
    var topLeftCornerEnable: Bool = false {
        didSet { setupCorners() }
    }
    @IBInspectable
    var topRightCornerEnable: Bool = false {
        didSet { setupCorners() }
    }
    @IBInspectable
    var bottomLeftCornerEnable: Bool = false {
        didSet { setupCorners() }
    }
    @IBInspectable
    var bottomRightCornerEnable: Bool = false {
        didSet { setupCorners() }
    }
    
    private var maskCorners: UIRectCorner {
        var corners: UIRectCorner = []
        if topLeftCornerEnable { corners = corners.union(.topLeft) }
        if topRightCornerEnable { corners = corners.union(.topRight) }
        if bottomLeftCornerEnable { corners = corners.union(.bottomLeft) }
        if bottomRightCornerEnable { corners = corners.union(.bottomRight) }
        return corners
    }
    private var layerMaskCorners: CACornerMask {
        var maskCorners: CACornerMask = []
        if bottomLeftCornerEnable { maskCorners = maskCorners.union(.layerMinXMaxYCorner) }
        if bottomRightCornerEnable { maskCorners = maskCorners.union(.layerMaxXMaxYCorner) }
        if topLeftCornerEnable { maskCorners = maskCorners.union(.layerMinXMinYCorner) }
        if topRightCornerEnable { maskCorners = maskCorners.union(.layerMaxXMinYCorner) }
        return maskCorners
    }
    private var backgroundLayer: CALayer?
    private var image: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCorners()
    }
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCorners()
    }
      
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCorners()
    }

    private func setupCorners() {
        guard cornerRadius > 0 && bounds.width > 0 && bounds.height > 0 && !maskCorners.isEmpty else { return }
        if #available(iOS 11.0, *) {
            layer.cornerRadius = cornerRadius
            layer.maskedCorners = layerMaskCorners
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
            setupOpacity()
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: maskCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = path.cgPath
            layer.mask = maskLayer
            setupOpacity()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBackground()
    }

    private func setupBackground() {
        if let background = backgroundLayer {
            background.removeFromSuperlayer()
            backgroundLayer = nil
        }
        if backgroundImage != nil {
            setBackgroundAsImage()
        } else {
            setBackgroundAsGradient()
        }
    }
    
    private func setBackgroundAsGradient() {
        let background = CAGradientLayer()
        background.colors = [leftColor.cgColor, rightColor.cgColor]
        background.startPoint = CGPoint(x: 0.0, y: 0.0)
        background.endPoint = CGPoint(x: 1.0, y: 1.0)
        background.frame = bounds
        background.cornerRadius = cornerRadius
        background.maskedCorners = layerMaskCorners
        layer.insertSublayer(background, at: 0)
        backgroundLayer = background
    }
    
    private func setBackgroundAsImage() {
        guard bounds.width > 0 && bounds.height > 0 else { return }
        if let img = image { img.removeFromSuperview() }
        image = UIImageView(frame: bounds)
        if let img = image {
            img.clipsToBounds = true
            img.contentMode = .scaleAspectFill
            img.image = backgroundImage
            insertSubview(img, at: 0)
            if #available(iOS 11.0, *) {
                img.layer.cornerRadius = cornerRadius
                img.layer.maskedCorners = layerMaskCorners
            } else {
                let path = UIBezierPath(roundedRect: img.bounds, byRoundingCorners: maskCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
                let maskLayer = CAShapeLayer()
                maskLayer.frame = bounds
                maskLayer.path = path.cgPath
                img.layer.mask = maskLayer
            }
        }
    }

    private func setupOpacity() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 10
    }
}
