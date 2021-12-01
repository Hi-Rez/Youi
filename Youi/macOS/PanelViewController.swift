//
//  PanelViewController.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/14/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa
import Satin

public protocol PanelViewControllerDelegate: AnyObject {
    func onPanelOpen(panel: PanelViewController)
    func onPanelClose(panel: PanelViewController)
    func onPanelResized(panel: PanelViewController)
    func onPanelRemove(panel: PanelViewController)
}

open class PanelViewController: ControlViewController {
    public var open: Bool = false {
        didSet {
            updateState()
        }
    }
    
    public var vStack: NSStackView?
    public var hStack: NSStackView?
    public var button: NSButton?
    public var label: NSTextField?
    
    open override var title: String? {
        didSet {
            if let title = self.title {
                label?.stringValue = title
            }
        }
    }
    
    public weak var delegate: PanelViewControllerDelegate?
    
    public convenience init(_ title: String, parameters: ParameterGroup) {
        self.init()
        self.title = title
        self.parameters = parameters
    }
    
    open func setupVerticalStackView() {
        let stack = NSStackView()
        stack.wantsLayer = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        stack.spacing = 0
        stack.distribution = .equalSpacing
        view.addSubview(stack)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: stack.heightAnchor).isActive = true
        vStack = stack
    }
    
    open func setupHorizontalStackView() {
        guard let vStack = self.vStack else { return }
        let hStack = NSStackView()
        hStack.wantsLayer = true
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.orientation = .horizontal
        hStack.spacing = 4
        hStack.alignment = .centerY
        hStack.distribution = .gravityAreas
        vStack.addView(hStack, in: .center)
        hStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hStack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        hStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        hStack.heightAnchor.constraint(equalToConstant: 42).isActive = true
        self.hStack = hStack
    }
    
    open func setupDisclosureButton() {
        guard let hStack = self.hStack else { return }
        let button = NSButton()
        button.wantsLayer = true
        button.bezelStyle = .disclosure
        button.title = ""
        button.setButtonType(.onOff)
        button.state = .on
        button.target = self
        button.action = #selector(PanelViewController.onButtonChange)
        button.translatesAutoresizingMaskIntoConstraints = false
        hStack.addView(button, in: .leading)
        self.button = button
    }
    
    open func setupLabel() {
        guard let hStack = self.hStack else { return }
        let label = NSTextField()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.wantsLayer = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = .clear
        if let title = self.title {
            label.stringValue = title
        }
        else {
            label.stringValue = "Panel"
        }
        hStack.addView(label, in: .leading)
        self.label = label
    }
    
    open func setupSpacer() {
        guard let vStack = self.vStack else { return }
        let spacer = Spacer()
        vStack.addView(spacer, in: .bottom)
        spacer.heightAnchor.constraint(equalToConstant: 1).isActive = true
        spacer.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
    }
    
    open override func setupStackView() {
        guard let vStack = self.vStack else { return }
        let stack = NSStackView()
        stack.wantsLayer = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        vStack.addView(stack, in: .bottom)
        stack.orientation = .vertical
        stack.distribution = .gravityAreas
        stack.spacing = 0
        stack.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true
        self.stack = stack
    }
    
    open func setupContainer() {
        setupDisclosureButton()
        setupLabel()
    }
    
    open override func loadView() {
        setupView()
        setupVerticalStackView()
        setupSpacer()
        setupHorizontalStackView()
        setupContainer()
        setupStackView()
        setupParameters()
        updateState()
    }
        
    @objc open func onButtonChange() {
        if let button = self.button, button.state == .off {
            open = false
        }
        else {
            open = true
        }
    }
    
    open func _close() {
        if let button = self.button {
            button.state = .off
        }
        
        if let vStack = self.vStack, let stack = self.stack {
            if vStack.views.contains(stack) {
                vStack.removeView(stack)
            }
        }
        
        delegate?.onPanelClose(panel: self)
    }
    
    open func _open() {
        if let button = self.button {
            button.state = .on
        }
        
        if let vStack = self.vStack, let stack = self.stack {
            if !vStack.views.contains(stack) {
                vStack.addView(stack, in: .bottom)
                stack.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
            }
        }
        
        delegate?.onPanelOpen(panel: self)
    }
    
    open override func viewDidLayout() {
        super.viewDidLayout()
        delegate?.onPanelResized(panel: self)
    }
    
    func updateState()
    {
        if open {
            _open()
        }
        else {
            _close()
        }
    }
    
    deinit {
        controls = []
        parameters = nil
        button = nil
        stack = nil
        vStack = nil
        label = nil
    }
}
