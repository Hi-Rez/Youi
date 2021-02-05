//
//  DropDownViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/4/21.
//

import Satin
import UIKit

class DropDownViewController: WidgetViewController {
    var valueObservation: NSKeyValueObservation?
    var button: UIButton?
    var options: [String] = []

    var font: UIFont {
        labelFont
    }
    
    override open func loadView() {
        setupView()
        setupStackViews()
        setupLabel()
        setupButton()
        setupBinding()
    }

    override func setupHorizontalStackView() {
        guard let vStack = self.vStack else { return }
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
        guard let hStack = self.hStack else { return }
        let button = UIButton(type: .roundedRect)
        button.setTitleColor(UIColor(named: "Text"), for: .normal)
        button.titleLabel?.font = font
        button.contentHorizontalAlignment = .right
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(named: "Border")?.cgColor
        button.showsMenuAsPrimaryAction = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.addAction(UIAction(handler: { [unowned self] _ in
            if let parameter = self.parameter as? StringParameter {
                var children: [UIAction] = []
                for option in self.options {
                    children.append(UIAction(title: option, state: option == parameter.value ? .on : .off, handler: { [unowned self] _ in self.setValue(option) }))
                }
                let menu = UIMenu(title: "", options: .displayInline, children: children)
                button.menu = menu
            }
        }), for: .touchUpInside)
        hStack.addArrangedSubview(button)
        self.button = button
    }
    
    override func setupBinding() {
        var stringValue: String = ""
        if let param = parameter as? StringParameter {
            stringValue = param.value
            valueObservation = param.observe(\StringParameter.value, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue {
                    self.setValue(value)
                }
            }
        }

        if let button = self.button {
            button.setTitle(stringValue, for: .normal)
            var children: [UIAction] = []
            for option in self.options {
                children.append(UIAction(title: option, state: option == stringValue ? .on : .off, handler: { [unowned self] _ in self.setValue(option) }))
            }
            let menu = UIMenu(title: "", options: .displayInline, children: children)
            button.menu = menu
        }

        if let label = self.label, let parameter = self.parameter {
            label.text = "\(parameter.label)"
        }
    }

    func setValue(_ value: String) {
        if let param = parameter as? StringParameter, param.value != value {
            param.value = value
        }
        if let button = self.button {
            button.setTitle(value, for: .normal)
        }
    }

    deinit {
        valueObservation = nil
        button = nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if let button = self.button {
            button.layer.borderColor = UIColor(named: "Border")?.cgColor
        }
    }
}
