//
//  ToggleViewController.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/14/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Combine
import Satin

#if os(macOS)

import Cocoa

open class ToggleViewController: NSViewController {
    public weak var parameter: BoolParameter?
    var subscriber: AnyCancellable?

    var button: NSButton!

    override open func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false

        if let parameter = parameter {
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
            button.setButtonType(.switch)
            button.title = parameter.label
            button.translatesAutoresizingMaskIntoConstraints = false
            hStack.addView(button, in: .leading)
            button.state = (parameter.value ? .on : .off)
            button.target = self
            button.action = #selector(ToggleViewController.onButtonChange)

            view.heightAnchor.constraint(equalTo: button.heightAnchor, constant: 17).isActive = true
        }
    }

    @objc func onButtonChange() {
        if button.state == .off {
            if let parameter = parameter {
                parameter.value = false
            }
        }
        else {
            if let parameter = parameter {
                parameter.value = true
            }
        }
    }

    deinit {}
}

#elseif os(iOS)

import UIKit

class ToggleViewController: WidgetViewController {
    var subscriber: AnyCancellable?
    var toggle: UISwitch?

    override open func loadView() {
        setupView()
        setupStackViews()
        setupSwitch()
        setupLabel()
        setupBinding()
    }

    override func setupHorizontalStackView() {
        super.setupHorizontalStackView()
        if let stack = hStack {
            stack.spacing = 8
            stack.distribution = .fill
        }
    }

    func setupSwitch() {
        guard let stack = hStack else { return }
        let toggle = UISwitch()
        toggle.addAction(UIAction(handler: { [unowned self] _ in
            if let parameter = self.parameter as? BoolParameter {
                parameter.value = toggle.isOn
            }
        }), for: .primaryActionTriggered)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(toggle)
        self.toggle = toggle
    }

    override func setupBinding() {
        if let parameter = parameter as? BoolParameter {
            subscriber = parameter.publisher.sink { [weak self] value in
                if let self = self, let toggle = self.toggle {
                    DispatchQueue.main.async {
                        toggle.isOn = value
                    }
                }
            }
        }

        if let toggle = toggle, let parameter = parameter as? BoolParameter {
            toggle.isOn = parameter.value
        }

        super.setupBinding()
    }

    deinit {
        toggle = nil
    }
}

#endif
