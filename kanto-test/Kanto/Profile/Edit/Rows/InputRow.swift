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
    var selectedOption = Observable<String?>(nil)

    func configure(for viewModel: InputRowViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        inputTextField.placeholder = viewModel.placeHolderText
        inputTextField.keyboardType = viewModel.inputType
        self.selectedOption = viewModel.selectedOption
        inputTextField.delegate = self
        errorLabel.text = viewModel.showableError
        errorLabel.isHidden = true
        inputTextField.autocorrectionType = .no
        inputTextField.underlined(color: UIColor.init(red: 1,
                                                      green: 1,
                                                      blue: 1,
                                                      alpha: 0.5))
        bindView()
    }
    
    private func bindView() {
        viewModel.selectedOption.bidirectionalBind(to: inputTextField.reactive.text)
        
        _ = selectedOption.observeNext {
            self.error(visible: false)
            self.shouldChange = ($0 ?? "").count < self.viewModel.maxCharCount
        }
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
    
    override func endEditing(_ force: Bool) -> Bool {
        super.endEditing(force)
        return inputTextField.endEditing(force)
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
