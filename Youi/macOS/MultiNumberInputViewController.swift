//
//  MultiNumberInputViewController.swift
//  Youi-macOS
//
//  Created by Reza Ali on 4/27/20.
//

import Cocoa
import Satin

open class MultiNumberInputViewController: ControlViewController, NSTextFieldDelegate {
    public weak var parameter: Parameter?

    var observers: [NSKeyValueObservation] = []
    var inputs: [NSTextField] = []
    var labelField: NSTextField?

    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false

        guard let parameter = self.parameter else { return }

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
        hStack.distribution = .fillProportionally
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

        if parameter is Int2Parameter || parameter is Int3Parameter || parameter is Int3Parameter {
            print("parameter is int: \(parameter.label)")
            if let param = parameter as? Int2Parameter {
                let updateValue: (Int2Parameter, NSKeyValueObservedChange<Int32>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.stringValue = String(format: "%d", param[i])
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
            }
            else if let param = parameter as? Int3Parameter {
                let updateValue: (Int3Parameter, NSKeyValueObservedChange<Int32>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.stringValue = String(format: "%d", param[i])
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
                observers.append(param.observe(\.z, changeHandler: updateValue))
            }
            else if let param = parameter as? Int4Parameter {
                let updateValue: (Int4Parameter, NSKeyValueObservedChange<Int32>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.stringValue = String(format: "%d", param[i])
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
                observers.append(param.observe(\.z, changeHandler: updateValue))
                observers.append(param.observe(\.w, changeHandler: updateValue))
            }

            for i in 0..<parameter.count {
                print("Setting up int input for \(parameter.label): \(i)")
                let value: Int32 = parameter[i]
                hStack.addView(createInput("\(value)", i), in: .trailing)
            }
        }
        else if parameter is Float2Parameter || parameter is Float3Parameter || parameter is Float4Parameter || parameter is PackedFloat3Parameter {
            print("parameter is float: \(parameter.label)")
            
            if let param = parameter as? Float2Parameter {
                print("setting up: \(param.label)")
                let updateValue: (Float2Parameter, NSKeyValueObservedChange<Float>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.stringValue = String(format: "%.5f", param[i])
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
            }
            else if let param = parameter as? Float3Parameter {
                let updateValue: (Float3Parameter, NSKeyValueObservedChange<Float>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.stringValue = String(format: "%.5f", param[i])
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
                observers.append(param.observe(\.z, changeHandler: updateValue))
            }
            else if let param = parameter as? PackedFloat3Parameter {
                let updateValue: (PackedFloat3Parameter, NSKeyValueObservedChange<Float>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.stringValue = String(format: "%.5f", param[i])
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
                observers.append(param.observe(\.z, changeHandler: updateValue))
            }

            else if let param = parameter as? Float4Parameter {
                let updateValue: (Float4Parameter, NSKeyValueObservedChange<Float>) -> Void = { [unowned self, param] _, _ in
                    for (i, input) in self.inputs.enumerated() {
                        input.stringValue = String(format: "%.5f", param[i])
                    }
                }
                observers.append(param.observe(\.x, changeHandler: updateValue))
                observers.append(param.observe(\.y, changeHandler: updateValue))
                observers.append(param.observe(\.z, changeHandler: updateValue))
                observers.append(param.observe(\.w, changeHandler: updateValue))
            }

            for i in 0..<parameter.count {
                print("Setting up float input for \(parameter.label): \(i)")
                let value: Float = parameter[i]
                hStack.addView(createInput("\(value)", i), in: .trailing)
            }
        }

        self.labelField = labelField
    }

    open override func viewDidAppear() {
        for input in inputs {
            input.isEditable = true
        }
    }

    open override func viewWillDisappear() {
        for input in inputs {
            input.isEditable = false
        }
    }

    func createInput(_ value: String, _ tag: Int) -> NSTextField {
        let input = NSTextField()
        input.tag = tag
        input.font = .boldSystemFont(ofSize: 12)
        input.wantsLayer = true
        input.translatesAutoresizingMaskIntoConstraints = false
        input.stringValue = value
        input.isEditable = false
        input.isBezeled = true
        input.backgroundColor = .clear
        input.delegate = self
        input.resignFirstResponder()
        input.alignment = .right
        inputs.append(input)
        return input
    }

    func setValue(_ value: Double, _ tag: Int) {
        print("setting value: \(value), \(tag)")
        guard let parameter = self.parameter else { return }
        if parameter is Int2Parameter || parameter is Int3Parameter || parameter is Int4Parameter {
            let iValue = Int32(value)
            parameter[tag] = iValue
        }
        else if parameter is Float2Parameter || parameter is Float3Parameter || parameter is Float4Parameter || parameter is PackedFloat3Parameter {
            let fValue = Float(value)
            parameter[tag] = fValue
        }
    }

    public func controlTextDidEndEditing(_ obj: Notification) {
        if let input = obj.object as? NSTextField {
            let string = input.stringValue
            if let value = Double(string) {
                setValue(value, input.tag)
            }
            deactivate()
        }
    }

    public func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            let charSet = NSCharacterSet(charactersIn: "-1234567890.").inverted
            let chars = textField.stringValue.components(separatedBy: charSet)
            textField.stringValue = chars.joined()
        }
    }

    open override func mouseDown(with event: NSEvent) {
        for input in inputs {
            if let _ = input.hitTest(event.locationInWindow) {
                input.becomeFirstResponder()
                return
            }
        }
        deactivate()
    }

    deinit {
        parameter = nil
        observers = []
        inputs = []
        labelField = nil
    }
}
