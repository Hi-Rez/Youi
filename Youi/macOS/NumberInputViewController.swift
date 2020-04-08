//
//  NumberInputViewController.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/14/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa
import Satin

open class NumberInputViewController: ControlViewController, NSTextFieldDelegate {
    weak var parameter: Parameter?
    var valueObservation: NSKeyValueObservation?
    
    var inputField: NSTextField?
    var labelField: NSTextField?

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
                valueObservation = param.observe(\FloatParameter.value, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        self.inputField?.stringValue = String(format: "%.5f", value)
                    }
                }
            }
            else if parameter is IntParameter {
                let param = parameter as! IntParameter
                value = Double(param.value)
                stringValue = String(format: "%.0f", value)
                valueObservation = param.observe(\IntParameter.value, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        self.inputField?.stringValue = String(value)
                    }
                 }
            }
            else if parameter is DoubleParameter {
                let param = parameter as! DoubleParameter
                value = param.value
                stringValue = String(format: "%.5f", value)
                valueObservation = param.observe(\DoubleParameter.value, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        self.inputField?.stringValue = String(format: "%.5f", value)
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
            hStack.spacing = 0
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
            labelField.stringValue = parameter.label + ":"
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
            inputField.backgroundColor = .clear
            inputField.delegate = self
            inputField.resignFirstResponder()
            hStack.addView(inputField, in: .leading)
            
            self.labelField = labelField
            self.inputField = inputField
        }
    }
    
    func setValue(_ value: Double) {
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

    public func controlTextDidEndEditing(_ obj: Notification) {
        let string = inputField?.stringValue
        if let valueString = string, let value = Double(valueString) {
            setValue(value)
        }
        deactivate()
    }

    public func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            let charSet = NSCharacterSet(charactersIn: "-1234567890.").inverted
            let chars = textField.stringValue.components(separatedBy: charSet)
            textField.stringValue = chars.joined()
        }
    }
    
    deinit {
        print("Removing NumberInputViewController: \(parameter?.label ?? "nil")")
    }
}
