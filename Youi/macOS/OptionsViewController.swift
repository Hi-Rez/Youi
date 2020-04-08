//
//  OptionsViewController.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/25/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa
import Satin

public protocol OptionsViewControllerDelegate: AnyObject {
    func onButtonPressed(_ sender: NSButton)
}

open class OptionsViewController: NSViewController, NSTextFieldDelegate {
    public var options: [String] = []
    public weak var delegate: OptionsViewControllerDelegate?
    
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
        hStack.spacing = 8

        hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -16).isActive = true

        for option in options  {
            let button = NSButton()
            button.wantsLayer = true
            button.title = option
            button.bezelStyle = .inline
            button.isSpringLoaded = true
            button.target = self
            button.action = #selector(onButtonPressed)
            hStack.addView(button, in: .leading)
        }
                
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    @objc func onButtonPressed(_ sender: NSButton)
    {
        delegate?.onButtonPressed(sender)
    }
    
    deinit {
        print("Removing OptionsViewController: \(options)")
        options = []
        delegate = nil
    }
}
