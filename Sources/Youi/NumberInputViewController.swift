//
//  NumberInputViewController.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/14/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Combine
import Satin

#if os(macOS)

import Cocoa

open class NumberInputViewController: InputViewController, NSTextFieldDelegate {
    public weak var parameter: Parameter?
    var cancellables = Set<AnyCancellable>()

    var inputField: NSTextField?
    var labelField: NSTextField?

    override open func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false

        if let parameter = parameter {
            var value: Double = 0.0
            var stringValue: String = ""
            if parameter is FloatParameter {
                let param = parameter as! FloatParameter
                value = Double(param.value)
                stringValue = String(format: "%.3f", value)

                param.$value.sink { [weak self] newValue in
                    if let self = self {
                        self.inputField?.stringValue = String(format: "%.5f", newValue)
                    }
                }.store(in: &cancellables)
            }
            else if parameter is IntParameter {
                let param = parameter as! IntParameter
                value = Double(param.value)
                stringValue = "\(param.value)"

                param.$value.sink { [weak self] newValue in
                    if let self = self {
                        self.inputField?.stringValue = String(newValue)
                    }
                }.store(in: &cancellables)
            }
            else if parameter is DoubleParameter {
                let param = parameter as! DoubleParameter
                value = param.value
                stringValue = String(format: "%.3f", value)

                param.$value.sink { [weak self] newValue in
                    if let self = self {
                        self.inputField?.stringValue = String(format: "%.5f", newValue)
                    }
                }.store(in: &cancellables)
            }

            let vStack = NSStackView()
            vStack.wantsLayer = true
            vStack.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(vStack)
            vStack.orientation = .vertical
            vStack.distribution = .gravityAreas
            vStack.spacing = 4

            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            vStack.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            vStack.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

            let hStack = NSStackView()
            hStack.wantsLayer = true
            hStack.translatesAutoresizingMaskIntoConstraints = false
            hStack.orientation = .horizontal
            hStack.spacing = 4
            hStack.alignment = .centerY
            hStack.distribution = .gravityAreas
            vStack.addView(hStack, in: .center)
            hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -14).isActive = true

            let labelField = NSTextField()
            labelField.font = .labelFont(ofSize: 12)
            labelField.translatesAutoresizingMaskIntoConstraints = false
            labelField.isEditable = false
            labelField.isBordered = false
            labelField.backgroundColor = .clear
            labelField.stringValue = parameter.label
            hStack.addView(labelField, in: .leading)
            view.heightAnchor.constraint(equalTo: labelField.heightAnchor, constant: 16).isActive = true

            let inputField = NSTextField()
            inputField.font = .boldSystemFont(ofSize: 12)
            inputField.stringValue = stringValue
            inputField.wantsLayer = true
            inputField.translatesAutoresizingMaskIntoConstraints = false
            inputField.stringValue = stringValue
            inputField.isEditable = true
            inputField.isBordered = false
            inputField.isBezeled = true
            inputField.backgroundColor = .clear
            inputField.delegate = self
            inputField.target = self
            inputField.action = #selector(onInputChanged)
            inputField.alignment = .right
            hStack.addView(inputField, in: .trailing)
            inputField.widthAnchor.constraint(lessThanOrEqualTo: hStack.widthAnchor, multiplier: 0.5).isActive = true

            self.labelField = labelField
            self.inputField = inputField
        }
    }

    func setValue(_ value: Double) {
        if let parameter = parameter {
            if parameter is FloatParameter {
                let floatParam = parameter as! FloatParameter
                floatParam.value = Float(value)
            }
            else if parameter is DoubleParameter {
                let doubleParam = parameter as! DoubleParameter
                doubleParam.value = value
            }
            else if parameter is IntParameter {
                let intParam = parameter as! IntParameter
                intParam.value = Int(value)
            }
        }
    }

    @objc func onInputChanged(_ sender: NSTextField) {
        if let value = Double(sender.stringValue) {
            setValue(value)
            deactivateAsync()
        }
    }

    public func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            let charSet = NSCharacterSet(charactersIn: "-1234567890.").inverted
            let chars = textField.stringValue.components(separatedBy: charSet)
            textField.stringValue = chars.joined()
        }
    }

    deinit {}
}

#elseif os(iOS)

import UIKit

class NumberInputViewController: WidgetViewController, UITextFieldDelegate {
    var cancellables = Set<AnyCancellable>()
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
        guard let vStack = vStack else { return }
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
        guard let hStack = hStack else { return }
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
        if let input = input, let text = input.text, let value = Float(text) {
            setValue(value)
        }
        textField.resignFirstResponder()
    }

    func setValue(_ value: Float) {
        if let parameter = parameter {
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
        if let param = parameter as? FloatParameter {
            stringValue = String(format: "%.3f", param.value)
            param.$value.sink { [weak self] value in
                if let self = self, let input = self.input, !input.isFirstResponder {
                    input.text = String(format: "%.3f", value)
                }
            }.store(in: &cancellables)
        }
        else if let param = parameter as? IntParameter {
            stringValue = "\(param.value)"
            param.$value.sink { [weak self] value in
                if let self = self, let input = self.input, !input.isFirstResponder {
                    input.text = "\(value)"
                }
            }.store(in: &cancellables)
        }
        else if let param = parameter as? DoubleParameter {
            stringValue = String(format: "%.3f", param.value)
            param.$value.sink { [weak self] value in
                if let self = self, let input = self.input, !input.isFirstResponder {
                    input.text = String(format: "%.3f", value)
                }
            }.store(in: &cancellables)
        }

        guard let input = input else { return }
        input.text = stringValue

        super.setupBinding()
    }

    deinit {
        input = nil
    }
}

#endif
