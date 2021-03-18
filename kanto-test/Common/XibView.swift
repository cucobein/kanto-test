//
//  XibView.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import UIKit

class XibView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXibView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXibView()
    }
    
    func loadXibView() {
        let thisClass = type(of: self)
        let className = String(describing: thisClass).components(separatedBy: ".").last
        Bundle(for: thisClass).loadNibNamed(className!, owner: self, options: nil)
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.frame = self.bounds
    }
}
