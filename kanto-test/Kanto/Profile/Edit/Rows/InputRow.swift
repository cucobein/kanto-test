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
    @IBOutlet private weak var inputLabel: UILabel!
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
        inputTextField.isHidden = !viewModel.isEditable
        inputLabel.isHidden = viewModel.isEditable
        inputTextField.autocorrectionType = .no
    }
    
    func setUpValidated(text: String) {
        inputTextField.text = text
    }

    func error(visible: Bool) {
        inputTextField.layer.borderColor = visible ? UIColor.red.cgColor : UIColor.gray.cgColor
        inputTextField.layer.borderWidth = visible ? 1 : 0
        inputTextField.layer.cornerRadius = 5
        errorLabel.isHidden = !visible
    }
}

extension InputRow: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let containerView = superview?.superview else { return }
        let convertedFrame = convert(bounds, to: containerView)
        self.viewModel.neededHeightForDisplay.value = convertedFrame.maxY
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        shouldChange || string.isEmpty
    }
}
