//
//  MultiNumberInputViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/3/21.
//

import Satin
import UIKit

class MultiNumberInputViewController: WidgetViewController, UITextFieldDelegate {
    var observers: [NSKeyValueObservation] = []
    var inputs: [UITextField] = []

    var font: UIFont {
        labelFont
    }
    
    override open func loadView() {
        setupView()
        setupStackViews()
        setupLabel()
        setupInputs()
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
    
    func setupInputs() {
        guard let hStack = self.hStack else { return }
        if let param = parameter {
            for i in 0 ..< param.count {
                hStack.addArrangedSubview(createInput("", i))
            }
        }
        
        if parameter is Int2Parameter || parameter is Int3Parameter || parameter is Int3Parameter || parameter is Int4Parameter {
            if let param = parameter as? Int2Parameter {
                inputs[0].text = "\(param.x)"
                inputs[1].text = "\(param.y)"
            }
            else if let param = parameter as? Int3Parameter {
                inputs[0].text = "\(param.x)"
                inputs[1].text = "\(param.y)"
                inputs[2].text = "\(param.z)"
            }
            else if let param = parameter as? Int4Parameter {
                inputs[0].text = "\(param.x)"
                inputs[1].text = "\(param.y)"
                inputs[2].text = "\(param.z)"
                inputs[3].text = "\(param.w)"
            }
        }
        else if parameter is Float2Parameter || parameter is Float3Parameter || parameter is Float4Parameter || parameter is PackedFloat3Parameter {
            if let param = parameter as? Float2Parameter {
                inputs[0].text = String(format: "%.3f", param.x)
                inputs[1].text = String(format: "%.3f", param.y)
            }
            else if let param = parameter as? Float3Parameter {
                inputs[0].text = String(format: "%.3f", param.x)
                inputs[1].text = String(format: "%.3f", param.y)
                inputs[2].text = String(format: "%.3f", param.z)
            }
            else if let param = parameter as? PackedFloat3Parameter {
                inputs[0].text = String(format: "%.3f", param.x)
                inputs[1].text = String(format: "%.3f", param.y)
                inputs[2].text = String(format: "%.3f", param.z)
            }
            else if let param = parameter as? Float4Parameter {
                inputs[0].text = String(format: "%.3f", param.x)
                inputs[1].text = String(format: "%.3f", param.y)
                inputs[2].text = String(format: "%.3f", param.z)
                inputs[3].text = String(format: "%.3f", param.w)
            }
        }
    }
    
    func createInput(_ value: String, _ tag: Int) -> UITextField {
        let input = UITextField()
        input.tag = tag
        input.text = value
        input.borderStyle = .roundedRect
        input.translatesAutoresizingMaskIntoConstraints = false
        input.font = font
        input.backgroundColor = .clear
        input.textAlignment = .right
        input.contentHuggingPriority(for: .horizontal)
        input.keyboardType = .decimalPad
        input.addAction(UIAction(handler: { [unowned self] _ in
            if let text = input.text, let value = Float(text) {
                setValue(value, tag)
            }
        }), for: .editingChanged)
        input.delegate = self
        inputs.append(input)
        return input
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    } // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, let value = Float(text) {
            setValue(value, textField.tag)
        }
        textField.resignFirstResponder()
    }
    
    func setValue(_ value: Float, _ tag: Int) {
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
        
        if textField.keyboardType == .decimalPad {
            if !CharacterSet(charactersIn: "-0123456789.").isSuperset(of: CharacterSet(charactersIn: string)) {
                return false
            }
            if string == ".", let text = textField.text, text.contains(".") {
                return false
            }
        }
        
        // Allow text change
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func setupBinding() {
        if parameter is Int2Parameter || parameter is Int3Parameter || parameter is Int3Parameter || parameter is Int4Parameter {
            if let param = parameter as? Int2Parameter {
                let updateValue: (Int2Parameter, NSKeyValueObservedChange<Int32>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.text = "\(param[i])"
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
            }
            else if let param = parameter as? Int3Parameter {
                let updateValue: (Int3Parameter, NSKeyValueObservedChange<Int32>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.text = String(format: "%d", param[i])
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
                observers.append(param.observe(\.z, changeHandler: updateValue))
            }
            else if let param = parameter as? Int4Parameter {
                let updateValue: (Int4Parameter, NSKeyValueObservedChange<Int32>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.text = String(format: "%d", param[i])
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
                observers.append(param.observe(\.z, changeHandler: updateValue))
                observers.append(param.observe(\.w, changeHandler: updateValue))
            }
        }
        else if parameter is Float2Parameter || parameter is Float3Parameter || parameter is Float4Parameter || parameter is PackedFloat3Parameter {
            if let param = parameter as? Float2Parameter {
                let updateValue: (Float2Parameter, NSKeyValueObservedChange<Float>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.text = String(format: "%.3f", param[i])
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
            }
            else if let param = parameter as? Float3Parameter {
                let updateValue: (Float3Parameter, NSKeyValueObservedChange<Float>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.text = String(format: "%.3f", param[i])
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
                observers.append(param.observe(\.z, changeHandler: updateValue))
            }
            else if let param = parameter as? PackedFloat3Parameter {
                let updateValue: (PackedFloat3Parameter, NSKeyValueObservedChange<Float>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.text = String(format: "%.3f", param[i])
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
                observers.append(param.observe(\.z, changeHandler: updateValue))
            }
            else if let param = parameter as? Float4Parameter {
                let updateValue: (Float4Parameter, NSKeyValueObservedChange<Float>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.text = String(format: "%.3f", param[i])
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
                observers.append(param.observe(\.z, changeHandler: updateValue))
                observers.append(param.observe(\.w, changeHandler: updateValue))
            }
        }
        
        super.setupBinding()
    }
    
    deinit {
        observers = []
        inputs = []
    }
}
