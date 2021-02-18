//
//  InputViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/3/21.
//

import Satin
import UIKit

class NumberInputViewController: WidgetViewController, UITextFieldDelegate {
    var valueObservation: NSKeyValueObservation?
    var input: UITextField?
    
    var font: UIFont {
        .boldSystemFont(ofSize: 14)
    }

    override open func loadView() {
        setupView()
        setupStackViews()
        setupLabel()
        setupInput()
        setupBinding()
    }
    
    override func setupHorizontalStackView() {
        guard let vStack = self.vStack else { return }
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillEqually
        vStack.addArrangedSubview(stack)
        stack.centerXAnchor.constraint(equalTo: vStack.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: 0).isActive = true
        hStack = stack
    }
    
    func setupInput() {
        guard let hStack = self.hStack else { return }
        let input = UITextField()
        input.borderStyle = .roundedRect
        input.translatesAutoresizingMaskIntoConstraints = false
        input.font = font
        input.backgroundColor = .clear
        input.textAlignment = .right
        input.contentHuggingPriority(for: .horizontal)
        input.addAction(UIAction(handler: { [unowned self] _ in
            if let input = self.input, let text = input.text, let value = Float(text) {
                setValue(value)
            }
        }), for: .editingChanged)
        hStack.addArrangedSubview(input)
        input.delegate = self
        self.input = input
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    } // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let input = self.input, let text = input.text, let value = Float(text) {
            setValue(value)
        }
        textField.resignFirstResponder()
    }
    
    func setValue(_ value: Float) {
        if let parameter = self.parameter {
            if parameter is FloatParameter {
                let floatParam = parameter as! FloatParameter
                if value != floatParam.value {
                    floatParam.value = value
                }
            }
            else if parameter is DoubleParameter {
                let doubleParam = parameter as! DoubleParameter
                let doubleValue = Double(value)
                if doubleValue != doubleParam.value {
                    doubleParam.value = Double(value)
                }
            }
            else if parameter is IntParameter {
                let intParam = parameter as! IntParameter
                let intValue = Int(value)
                if intValue != intParam.value {
                    intParam.value = intValue
                }
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard !string.isEmpty else {
            return true
        }
        
        if !CharacterSet(charactersIn: "-0123456789.").isSuperset(of: CharacterSet(charactersIn: string)) {
            return false
        }
        if string == ".", let text = textField.text, text.contains(".") {
            return false
        }
                
        // Allow text change
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func setupBinding() {
        var stringValue: String = ""
        if let param = self.parameter as? FloatParameter {
            stringValue = String(format: "%.3f", param.value)
            valueObservation = param.observe(\FloatParameter.value, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let input = self.input, !input.isFirstResponder {
                    input.text = String(format: "%.3f", value)
                }
            }
        }
        else if let param = self.parameter as? IntParameter {
            stringValue = "\(param.value)"
            valueObservation = param.observe(\IntParameter.value, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let input = self.input, !input.isFirstResponder {
                    input.text = "\(value)"
                }
            }
        }
        else if let param = self.parameter as? DoubleParameter {
            stringValue = String(format: "%.3f", param.value)
            valueObservation = param.observe(\DoubleParameter.value, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let input = self.input, !input.isFirstResponder {
                    input.text = String(format: "%.3f", value)
                }
            }
        }
        
        guard let input = self.input else { return }
        input.text = stringValue
        
        super.setupBinding()
    }
    
    deinit {
        valueObservation = nil
        input = nil
    }
}
