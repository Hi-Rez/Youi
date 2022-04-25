//
//  DropDownViewController.swift
//  Slate
//
//  Created by Reza Ali on 3/24/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Combine
import Satin

#if os(macOS)

import Cocoa

open class DropDownViewController: NSViewController {
    public weak var parameter: StringParameter?
    var cancellable: AnyCancellable?

    public var options: [String] = []
    var labelField: NSTextField!
    var dropDownMenu: NSPopUpButton!

    override open func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false

        if let parameter = parameter {
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
            
            
            cancellable = parameter.$value.sink { [weak self] value in
                if let self = self, let selectedItem = self.dropDownMenu.selectedItem, selectedItem.title != value {
                    self.dropDownMenu.selectItem(withTitle: value)
                }
            }

        }
    }

    @objc func onSelected(_ sender: NSPopUpButton) {
        if let parameter = parameter {
            parameter.value = sender.title
        }
    }

    deinit {}
}

#elseif os(iOS)

import UIKit

class DropDownViewController: WidgetViewController {
    var cancellables = Set<AnyCancellable>()
    var button: UIButton?
    var options: [String] = []

    var font: UIFont {
        .boldSystemFont(ofSize: 14)
    }

    override open func loadView() {
        setupView()
        setupStackViews()
        setupLabel()
        setupButton()
        setupBinding()
    }

    override func setupHorizontalStackView() {
        guard let vStack = vStack else { return }
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillProportionally
        vStack.addArrangedSubview(stack)
        stack.centerXAnchor.constraint(equalTo: vStack.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: 0).isActive = true
        hStack = stack
    }

    func setupButton() {
        guard let hStack = hStack else { return }
        let button = UIButton(type: .roundedRect)

        button.setTitleColor(UIColor(named: "Text", in: getBundle(), compatibleWith: nil), for: .normal)
        button.titleLabel?.font = font
        button.contentHorizontalAlignment = .right
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(named: "Border", in: getBundle(), compatibleWith: nil)?.cgColor
        button.showsMenuAsPrimaryAction = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        hStack.addArrangedSubview(button)
        self.button = button
    }

    override func setupBinding() {
        var stringValue: String = ""
        if let param = parameter as? StringParameter {
            stringValue = param.value
            param.$value.sink { [weak self] value in
                if let self = self {
                    self.setValue(value)
                }
            }.store(in: &cancellables)
        }

        if let button = button {
            button.setTitle(stringValue, for: .normal)
            var children: [UIAction] = []
            for option in options {
                children.append(UIAction(title: option, handler: { [unowned self] _ in self.setValue(option) }))
            }
            let menu = UIMenu(title: "", options: .displayInline, children: children)
            button.menu = menu
        }

        if let label = label, let parameter = parameter {
            label.text = "\(parameter.label)"
        }
    }

    func setValue(_ value: String) {
        if let param = parameter as? StringParameter, param.value != value {
            param.value = value
        }
        if let button = button {
            button.setTitle(value, for: .normal)
        }
    }

    deinit {
        button = nil
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if let button = button {
            button.layer.borderColor = UIColor(named: "Border", in: getBundle(), compatibleWith: nil)?.cgColor
        }
    }
}

#endif
