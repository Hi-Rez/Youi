//
//  ButtonViewController.swift
//  Youi
//
//  Created by Reza Ali on 2/10/21.
//

import Cocoa
import Satin

open class ButtonViewController: NSViewController {
    public weak var parameter: BoolParameter?
    var observation: NSKeyValueObservation?

    var button: NSButton!
    var defaultState: Bool!

    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false

        if let parameter = self.parameter {
            defaultState = parameter.value
            
            observation = parameter.observe(\BoolParameter.value, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue {
                    self.button.state = (value ? .on : .off)
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
//            button.bezelStyle = .regularSquare
//            button.bezelStyle = .roundRect
//            button.bezelStyle = .texturedRounded
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

    deinit {}
}
