//
//  InputRow.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 21/03/21.
//

import UIKit
import Bond

final class InputRow: XibView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
    private var viewModel: InputRowViewModel!
    var shouldChange = true
    var options: [String]?

    func configure(for viewModel: InputRowViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        inputTextField.placeholder = viewModel.placeHolderText
        inputTextField.keyboardType = viewModel.inputType
        inputTextField.delegate = self
        errorLabel.text = viewModel.showableError
        errorLabel.isHidden = true
        inputTextField.autocorrectionType = .no
        inputTextField.underlined(color: UIColor.init(red: 1,
                                                      green: 1,
                                                      blue: 1,
                                                      alpha: 0.5))
    }
    
    func error(visible: Bool) {
        if visible {
            inputTextField.underlined(color: .red)
        } else {
            inputTextField.underlined(color: UIColor.init(red: 1,
                                                          green: 1,
                                                          blue: 1,
                                                          alpha: 0.5))
        }
        errorLabel.isHidden = !visible
    }
}

extension InputRow: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let containerView = superview?.superview else { return }
        let convertedFrame = convert(bounds, to: containerView)
        self.viewModel.neededHeightForDisplay.value = convertedFrame.maxY
        textField.underlined(color: UIColor.init(red: 0,
                                                 green: 0.77,
                                                 blue: 0.8,
                                                 alpha: 1))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.underlined(color: UIColor.init(red: 1,
                                                 green: 1,
                                                 blue: 1,
                                                 alpha: 0.5))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        shouldChange || string.isEmpty
    }
}
