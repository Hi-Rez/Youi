//
//  DropDownViewController.swift
//  Slate
//
//  Created by Reza Ali on 3/24/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa
import Satin

open class DropDownViewController: ControlViewController {
    public weak var parameter: StringParameter?
    var observation: NSKeyValueObservation?

    public var options: [String] = []
    var labelField: NSTextField!
    var dropDownMenu: NSPopUpButton!

    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false

        if let parameter = self.parameter {
            observation = parameter.observe(\StringParameter.value, options: [.old, .new]) { [unowned self] _, _ in
                if let param = self.parameter {
                    self.dropDownMenu.selectItem(withTitle: param.value)
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

            dropDownMenu = NSPopUpButton()
            dropDownMenu.wantsLayer = true
            dropDownMenu.translatesAutoresizingMaskIntoConstraints = false
            dropDownMenu.addItems(withTitles: options)
            dropDownMenu.selectItem(withTitle: parameter.value)
            dropDownMenu.target = self
            dropDownMenu.action = #selector(onSelected)
            dropDownMenu.bezelStyle = .texturedRounded
            hStack.addView(dropDownMenu, in: .trailing)
        }
    }

    @objc func onSelected(_ sender: NSPopUpButton) {
        if let parameter = self.parameter {
            parameter.value = sender.title
        }
    }

    deinit {
        print("Removing DropDownViewController: \(options)")
    }
}
