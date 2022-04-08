//
//  ButtonViewController.swift
//  Youi
//
//  Created by Reza Ali on 2/8/21.
//

import Combine
import Satin

#if os(macOS)

import Cocoa

open class ButtonViewController: NSViewController {
    public weak var parameter: BoolParameter?
    var subscriber: AnyCancellable?

    var button: NSButton!
    var defaultState: Bool!

    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false

        if let parameter = self.parameter {
            defaultState = parameter.value
            
            subscriber = parameter.$value.sink { [weak self] value in
                if let self = self {
                    DispatchQueue.main.async {
                        self.button.state = (value ? .on : .off)
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
            vStack.addView(hStack, in: .center)
            hStack.orientation = .horizontal
            hStack.alignment = .centerY
            hStack.distribution = .gravityAreas
            hStack.spacing = 0

            hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -16).isActive = true

            button = NSButton()
            button.wantsLayer = true
            button.setButtonType(.pushOnPushOff)
            button.bezelStyle = .rounded
            
            button.title = parameter.label
            button.translatesAutoresizingMaskIntoConstraints = false
            hStack.addView(button, in: .leading)
            button.widthAnchor.constraint(equalTo: hStack.widthAnchor).isActive = true
            button.state = (parameter.value ? .on : .off)
            button.target = self
            button.action = #selector(ButtonViewController.onButtonChange)
            
            view.heightAnchor.constraint(equalTo: button.heightAnchor, constant: 16).isActive = true
        }
    }

    @objc func onButtonChange() {
        if button.state == .off {
            if let parameter = self.parameter {
                parameter.value = false
            }
        }
        else {
            if let parameter = self.parameter {
                parameter.value = true
            }
        }
        
        if let parameter = self.parameter, defaultState != parameter.value {
            parameter.value = defaultState
        }
    }

    deinit {
        subscriber?.cancel()
    }
}

#elseif os(iOS)

import UIKit

class ButtonViewController: WidgetViewController {
    var valueObservation: NSKeyValueObservation?
    var button: UIButton?

    var font: UIFont {
        .boldSystemFont(ofSize: 14)
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
        button.setTitleColor(UIColor(named: "Text", in: getBundle(), compatibleWith: nil), for: .normal)
        button.titleLabel?.font = font
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(named: "Border", in: getBundle(), compatibleWith: nil)?.cgColor
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
            button.layer.borderColor = UIColor(named: "Border", in: getBundle(), compatibleWith: nil)?.cgColor
        }
    }
}

#endif
