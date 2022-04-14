//
//  MultiToggleViewController.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/28/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Combine
import Satin

#if os(macOS)

import Cocoa

open class MultiToggleViewController: NSViewController {
    public var parameters: [BoolParameter] = []
    var subscriptions = Set<AnyCancellable>()

    var spacers: [Spacer] = []
    var buttons: [NSButton] = []

    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false

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
        hStack.spacing = 6

        hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -16).isActive = true

        for (index, parameter) in parameters.enumerated() {
            let button = NSButton()
            button.wantsLayer = true
            button.setButtonType(.switch)
            button.title = parameter.label
            button.translatesAutoresizingMaskIntoConstraints = false
            hStack.addView(button, in: .leading)
            button.state = (parameter.value ? .on : .off)
            button.target = self
            button.action = #selector(onButtonChange)
            buttons.append(button)

            if (index + 1) != parameters.count {
                let spacer = Spacer()
                spacer.widthAnchor.constraint(equalToConstant: 1).isActive = true
                hStack.addView(spacer, in: .leading)
                spacer.heightAnchor.constraint(equalTo: hStack.heightAnchor).isActive = true
                spacers.append(spacer)
            }

            parameter.$value.sink { [weak self] value in
                if let _ = self {
                    button.state = (value ? .on : .off)
                }
            }.store(in: &subscriptions)
            
            view.heightAnchor.constraint(equalTo: button.heightAnchor, constant: 16).isActive = true
        }
    }

    @objc func onButtonChange(_ sender: NSButton) {
        let title = sender.title
        for parameter in parameters {
            if parameter.label == title {
                if sender.state == .off {
                    parameter.value = false
                }
                else {
                    parameter.value = true
                }
                break
            }
        }
    }

    deinit {
        parameters = []
        subscriptions.removeAll()
        spacers = []
        buttons = []
    }
}

#endif 
