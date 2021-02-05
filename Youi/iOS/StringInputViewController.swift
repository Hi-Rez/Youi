//
//  StringInputViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/3/21.
//

import Satin
import UIKit

class StringInputViewController: NumberInputViewController {
    override func setupInput() {
        guard let hStack = self.hStack else { return }
        let input = UITextField()
        input.borderStyle = .roundedRect
        input.translatesAutoresizingMaskIntoConstraints = false
        input.font = font
        input.backgroundColor = .clear
        input.textAlignment = .right
        input.contentHuggingPriority(for: .horizontal)
        input.addAction(UIAction(handler: { [unowned self] _ in
            if let input = self.input, let text = input.text {
                setValue(text)
            }
        }), for: .editingChanged)
        hStack.addArrangedSubview(input)
        input.delegate = self
        self.input = input
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        if let input = self.input, let text = input.text {
            setValue(text)
        }
        textField.resignFirstResponder()
    }
    
    func setValue(_ text: String) {
        if let parameter = self.parameter as? StringParameter, parameter.value != text {
            parameter.value = text
        }
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        return true
    }

    override func setupBinding() {
        var stringValue: String = ""
        if let param = self.parameter as? StringParameter {
            stringValue = param.value
            valueObservation = param.observe(\StringParameter.value, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let input = self.input, !input.isFirstResponder {
                    self.setValue(value)
                }
            }
        }
        
        
        guard let input = self.input else { return }
        input.text = stringValue
        
        guard let label = self.label, let parameter = self.parameter else { return }
        label.text = "\(parameter.label)"
    }
    
    deinit {
        valueObservation = nil
        input = nil
    }
}
