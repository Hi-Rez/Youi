//
//  StringInputViewController.swift
//  Youi-macOS
//
//  Created by Reza Ali on 4/27/20.
//

import Combine
import Satin

#if os(macOS)

import Cocoa

open class StringInputViewController: InputViewController, NSTextFieldDelegate {
    public weak var parameter: StringParameter?
    var subscription: AnyCancellable?

    var inputField: NSTextField?
    var labelField: NSTextField?

    override open func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true

        if let parameter = parameter {
            subscription = parameter.$value.sink { [weak self] value in
                if let self = self, let field = self.inputField, field.stringValue != value {
                    field.stringValue = value
                    field.layout()
                    self.view.needsLayout = true
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
            inputField.wantsLayer = true
            inputField.translatesAutoresizingMaskIntoConstraints = false
            inputField.stringValue = parameter.value
            inputField.isEditable = true
            inputField.isBordered = false
            inputField.isBezeled = true
            inputField.backgroundColor = .clear
            inputField.delegate = self
            inputField.alignment = .right
            inputField.isSelectable = true
            inputField.target = self
            inputField.action = #selector(onInputChanged)
            hStack.addView(inputField, in: .trailing)
            inputField.widthAnchor.constraint(lessThanOrEqualTo: hStack.widthAnchor, multiplier: 0.5).isActive = true

            self.labelField = labelField
            self.inputField = inputField
        }
    }

    @objc func onInputChanged(_ sender: NSTextField) {
        setValue(sender.stringValue)
        deactivateAsync()
    }

    func setValue(_ value: String) {
        if let parameter = parameter {
            parameter.value = value
        }
    }

    deinit {
        parameter = nil
    }
}

#elseif os(iOS)

import UIKit

class StringInputViewController: NumberInputViewController {
    override func setupInput() {
        guard let hStack = hStack else { return }
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
        if let input = input, let text = input.text {
            setValue(text)
        }
        textField.resignFirstResponder()
    }

    func setValue(_ text: String) {
        if let parameter = parameter as? StringParameter, parameter.value != text {
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
            param.$value.sink { [weak self] value in
                if let self = self, let input = self.input, !input.isFirstResponder {
                    self.setValue(value)
                }
            }.store(in: &cancellables)
        }

        guard let input = input else { return }
        input.text = stringValue

        guard let label = label, let parameter = parameter else { return }
        label.text = "\(parameter.label)"
    }

    deinit {
        input = nil
    }
}

#endif
