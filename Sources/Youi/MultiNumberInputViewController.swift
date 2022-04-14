//
//  MultiNumberInputViewController.swift
//  Youi-macOS
//
//  Created by Reza Ali on 4/27/20.
//

import Combine
import Satin

#if os(macOS)

import Cocoa

open class MultiNumberInputViewController: InputViewController, NSTextFieldDelegate {
    public weak var parameter: Parameter?

    var cancellables = Set<AnyCancellable>()

    var inputs: [NSTextField] = []
    var labelField: NSTextField?

    override open func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false

        guard let parameter = parameter else { return }

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

        if parameter is Int2Parameter || parameter is Int3Parameter || parameter is Int3Parameter || parameter is Int4Parameter {
            if let param = parameter as? Int2Parameter {
                param.$value.sink { [weak self] _ in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.stringValue = String(format: "%d", param[i])
                        }
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? Int3Parameter {
                param.$value.sink { [weak self] _ in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.stringValue = String(format: "%d", param[i])
                        }
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? Int4Parameter {
                param.$value.sink { [weak self] _ in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.stringValue = String(format: "%d", param[i])
                        }
                    }
                }.store(in: &cancellables)
            }

            for i in 0 ..< parameter.count {
                let value: Int32 = parameter[i]
                let input = createInput("\(value)", i)
                hStack.addView(input, in: .trailing)
            }
        }
        else if parameter is Float2Parameter || parameter is Float3Parameter || parameter is Float4Parameter || parameter is PackedFloat3Parameter {
            if let param = parameter as? Float2Parameter {
                param.$value.sink { [weak self] _ in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.stringValue = String(format: "%d", param[i])
                        }
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? Float3Parameter {
                param.$value.sink { [weak self] _ in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.stringValue = String(format: "%d", param[i])
                        }
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? PackedFloat3Parameter {
                param.$value.sink { [weak self] _ in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.stringValue = String(format: "%d", param[i])
                        }
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? Float4Parameter {
                param.$value.sink { [weak self] _ in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.stringValue = String(format: "%d", param[i])
                        }
                    }
                }.store(in: &cancellables)
            }

            for i in 0 ..< parameter.count {
                let value: Float = parameter[i]
                let input = createInput("\(value)", i)
                hStack.addView(input, in: .trailing)
            }
        }

        self.labelField = labelField

        for (index, input) in inputs.enumerated() {
            input.nextKeyView = inputs[index % inputs.count]
        }
    }

    override open func viewDidAppear() {
        for input in inputs {
            input.isEditable = true
        }
    }

    override open func viewWillDisappear() {
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
        input.alignment = .right
        input.target = self
        input.action = #selector(onInputChanged)
        if inputs.count > 0 {
            inputs[inputs.count - 1].nextKeyView = input
        }
        inputs.append(input)
        return input
    }

    func setValue(_ value: Double, _ tag: Int) {
        guard let parameter = parameter else { return }
        if parameter is Int2Parameter || parameter is Int3Parameter || parameter is Int4Parameter {
            let iValue = Int32(value)
            parameter[tag] = iValue
        }
        else if parameter is Float2Parameter || parameter is Float3Parameter || parameter is Float4Parameter || parameter is PackedFloat3Parameter {
            let fValue = Float(value)
            parameter[tag] = fValue
        }
    }

    @objc func onInputChanged(_ sender: NSTextField) {
        if let value = Double(sender.stringValue) {
            setValue(value, sender.tag)
            let next = sender.tag + 1
            if next != inputs.count {
                inputs[next].becomeFirstResponder()
            }
            else {
                deactivateAsync()
            }
        }
    }

    public func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            let charSet = NSCharacterSet(charactersIn: "-1234567890.").inverted
            let chars = textField.stringValue.components(separatedBy: charSet)
            textField.stringValue = chars.joined()
        }
    }

    public func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        switch commandSelector {
        case #selector(NSResponder.insertTab(_:)):
            let currentIndex = control.tag
            let current = inputs[currentIndex]
            if let value = Double(current.stringValue) {
                setValue(value, currentIndex)
            }
            let next = currentIndex + 1
            if next != inputs.count {
                inputs[next % inputs.count].becomeFirstResponder()
                return true
            }
            else {
                return false
            }
        default:
            return false
        }
    }

    deinit {
        parameter = nil
        inputs = []
        labelField = nil
    }
}

#elseif os(iOS)

import UIKit

class MultiNumberInputViewController: WidgetViewController, UITextFieldDelegate {
    var cancellables = Set<AnyCancellable>()
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

    func setupInputs() {
        guard let hStack = hStack else { return }
        if let param = parameter {
            for i in 0 ..< param.count {
                hStack.addArrangedSubview(createInput("", i))
            }
        }

        if parameter is Int2Parameter || parameter is Int3Parameter || parameter is Int3Parameter || parameter is Int4Parameter {
            if let param = parameter as? Int2Parameter {
                inputs[0].text = "\(param.value.x)"
                inputs[1].text = "\(param.value.y)"
            }
            else if let param = parameter as? Int3Parameter {
                inputs[0].text = "\(param.value.x)"
                inputs[1].text = "\(param.value.y)"
                inputs[2].text = "\(param.value.z)"
            }
            else if let param = parameter as? Int4Parameter {
                inputs[0].text = "\(param.value.x)"
                inputs[1].text = "\(param.value.y)"
                inputs[2].text = "\(param.value.z)"
                inputs[3].text = "\(param.value.w)"
            }
        }
        else if parameter is Float2Parameter || parameter is Float3Parameter || parameter is Float4Parameter || parameter is PackedFloat3Parameter {
            if let param = parameter as? Float2Parameter {
                inputs[0].text = String(format: "%.3f", param.value.x)
                inputs[1].text = String(format: "%.3f", param.value.y)
            }
            else if let param = parameter as? Float3Parameter {
                inputs[0].text = String(format: "%.3f", param.value.x)
                inputs[1].text = String(format: "%.3f", param.value.y)
                inputs[2].text = String(format: "%.3f", param.value.z)
            }
            else if let param = parameter as? PackedFloat3Parameter {
                inputs[0].text = String(format: "%.3f", param.value.x)
                inputs[1].text = String(format: "%.3f", param.value.y)
                inputs[2].text = String(format: "%.3f", param.value.z)
            }
            else if let param = parameter as? Float4Parameter {
                inputs[0].text = String(format: "%.3f", param.value.x)
                inputs[1].text = String(format: "%.3f", param.value.y)
                inputs[2].text = String(format: "%.3f", param.value.z)
                inputs[3].text = String(format: "%.3f", param.value.w)
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
        if parameter is Int2Parameter || parameter is Int3Parameter || parameter is Int3Parameter || parameter is Int4Parameter {
            if let param = parameter as? Int2Parameter {
                param.$value.sink { [weak self] value in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.text = "\(value[i])"
                        }
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? Int3Parameter {
                param.$value.sink { [weak self] value in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.text = "\(value[i])"
                        }
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? Int4Parameter {
                param.$value.sink { [weak self] value in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.text = "\(value[i])"
                        }
                    }
                }.store(in: &cancellables)
            }
        }
        else if parameter is Float2Parameter || parameter is Float3Parameter || parameter is Float4Parameter || parameter is PackedFloat3Parameter {
            if let param = parameter as? Float2Parameter {
                param.$value.sink { [weak self] value in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.text = String(format: "%.3f", value[i])
                        }
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? Float3Parameter {
                param.$value.sink { [weak self] value in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.text = String(format: "%.3f", value[i])
                        }
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? PackedFloat3Parameter {
                param.$value.sink { [weak self] value in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.text = String(format: "%.3f", value[i])
                        }
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? Float4Parameter {
                param.$value.sink { [weak self] value in
                    if let self = self {
                        for (i, input) in self.inputs.enumerated() {
                            input.text = String(format: "%.3f", value[i])
                        }
                    }
                }.store(in: &cancellables)
            }
        }

        super.setupBinding()
    }

    deinit {
        inputs = []
    }
}

#endif
