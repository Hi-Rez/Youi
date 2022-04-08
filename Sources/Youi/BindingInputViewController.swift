//
//  BindingInputViewController.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/24/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Combine
import Satin

#if os(macOS)

import Cocoa

open class BindingInputViewController: InputViewController, NSTextFieldDelegate {
    public weak var parameter: Parameter?
    var cancellable: AnyCancellable?

    var stepper: NSStepper!
    var inputField: NSTextField!
    var labelField: NSTextField!

    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false

        if let parameter = self.parameter {
            var value: Double = 0.0
            var stringValue: String = ""
            if parameter is FloatParameter {
                let param = parameter as! FloatParameter
                value = Double(param.value)
                stringValue = String(format: "%.5f", value)
                
                cancellable = param.$value.sink { [weak self] newValue in
                    if let self = self {
                        DispatchQueue.main.async {
                            self.inputField.stringValue = String(format: "%.5f", newValue)
                            self.stepper.floatValue = newValue
                        }
                    }
                }
                
            }
            else if parameter is IntParameter {
                let param = parameter as! IntParameter
                value = Double(param.value)
                stringValue = String(format: "%.0f", value)
                
                cancellable = param.$value.sink { [weak self] newValue in
                    if let self = self {
                        DispatchQueue.main.async {
                            self.inputField.stringValue = String(format: "%.5f", newValue)
                            self.stepper.doubleValue = Double(newValue)
                        }
                    }
                }
            }
            else if parameter is DoubleParameter {
                let param = parameter as! DoubleParameter
                value = param.value
                stringValue = String(format: "%.5f", value)
                
                cancellable = param.$value.sink { [weak self] newValue in
                    if let self = self {
                        DispatchQueue.main.async {
                            self.inputField.stringValue = String(format: "%.5f", newValue)
                            self.stepper.doubleValue = Double(newValue)
                        }
                    }
                }
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

            labelField = NSTextField()
            labelField.font = .labelFont(ofSize: 12)
            labelField.translatesAutoresizingMaskIntoConstraints = false
            labelField.isEditable = false
            labelField.isBordered = false
            labelField.backgroundColor = .clear
            labelField.stringValue = parameter.label
            hStack.addView(labelField, in: .leading)
            view.heightAnchor.constraint(equalTo: labelField.heightAnchor, constant: 16).isActive = true

            inputField = NSTextField()
            inputField.font = .boldSystemFont(ofSize: 12)
            inputField.stringValue = stringValue
            inputField.wantsLayer = true
            inputField.translatesAutoresizingMaskIntoConstraints = false
            inputField.stringValue = stringValue
            inputField.isEditable = true
            inputField.isBordered = false
            inputField.alignment = .right
            inputField.backgroundColor = .clear
            inputField.delegate = self
            inputField.target = self
            inputField.action = #selector(onInputChanged)
            inputField.resignFirstResponder()
            inputField.widthAnchor.constraint(equalToConstant: 24).isActive = true
            hStack.addView(inputField, in: .trailing)

            stepper = NSStepper()
            stepper.wantsLayer = true
            stepper.translatesAutoresizingMaskIntoConstraints = false
            stepper.target = self
            stepper.action = #selector(onStepperPressed)
            stepper.increment = 1
            if parameter is IntParameter {
                let param = parameter as! IntParameter
                stepper.intValue = Int32(param.value)
            }
            stepper.minValue = -100
            stepper.maxValue = 100
            stepper.valueWraps = true
            hStack.addView(stepper, in: .trailing)
        }
    }

    @objc func onStepperPressed(_ sender: NSStepper) {
        setValue(sender.doubleValue)
    }

    func setValue(_ value: Double) {
        stepper.doubleValue = value
        if let parameter = self.parameter {
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
            let charSet = NSCharacterSet(charactersIn: "-1234567890").inverted
            let chars = textField.stringValue.components(separatedBy: charSet)
            textField.stringValue = chars.joined()
        }
    }
}

#endif
