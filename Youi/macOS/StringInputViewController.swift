//
//  StringInputViewController.swift
//  Youi-macOS
//
//  Created by Reza Ali on 4/27/20.
//

import Cocoa
import Satin

open class StringInputViewController: InputViewController, NSTextFieldDelegate {
    public weak var parameter: StringParameter?
    var valueObservation: NSKeyValueObservation?

    var inputField: NSTextField?
    var labelField: NSTextField?

    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        if let parameter = self.parameter {
            valueObservation = parameter.observe(\StringParameter.value, options: [.old,.new]) { [unowned self] _, change in
                if let newValue = change.newValue, let oldValue = change.oldValue, oldValue != newValue, let field = self.inputField {
                    field.stringValue = newValue
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
        if let parameter = self.parameter {
            parameter.value = value
        }
    }

    deinit {
        parameter = nil
        valueObservation = nil
    }
}
