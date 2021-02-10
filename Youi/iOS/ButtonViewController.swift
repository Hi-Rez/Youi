//
//  ButtonViewController.swift
//  Youi
//
//  Created by Reza Ali on 2/8/21.
//

import UIKit
import Satin

class ButtonViewController: WidgetViewController {
    var valueObservation: NSKeyValueObservation?
    var button: UIButton?

    var font: UIFont {
        labelFont
    }

    override open func loadView() {
        setupView()
        setupStackViews()
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
        button.setTitleColor(UIColor(named: "Text", in: Bundle(for: ButtonViewController.self), compatibleWith: nil), for: .normal)
        button.titleLabel?.font = font    
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(named: "Border", in: Bundle(for: ButtonViewController.self), compatibleWith: nil)?.cgColor
        button.addAction(UIAction(handler: { [unowned self] _ in
            if let param = parameter as? BoolParameter {
                param.value.toggle()
            }
        }), for: .touchUpInside)
        
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        hStack.addArrangedSubview(button)
        self.button = button
    }

    override func setupBinding() {
        var stringValue = ""
        if let param = parameter as? BoolParameter, let button = self.button {
            stringValue = param.label
            button.setTitle(stringValue, for: .normal)
        }
    }

    deinit {
        valueObservation = nil
        button = nil
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if let button = self.button {
            button.layer.borderColor = UIColor(named: "Border", in: Bundle(for: DropDownViewController.self), compatibleWith: nil)?.cgColor
        }
    }
}

