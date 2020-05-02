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

open class PanelViewController: ControlViewController, OptionsViewControllerDelegate {
    public weak var parameters: ParameterGroup?
    public var controls: [NSViewController] = []
    public var state: Bool = false
    
    public var stack: NSStackView?
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
    
    open func setupView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer?.backgroundColor = .clear
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
    
    open func setupStackView() {
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
    
    open func setupParameters() {
        if let parameters = self.parameters {
            for param in parameters.params {
                if param is FloatParameter || param is IntParameter || param is DoubleParameter {
                    switch param.controlType {
                    case .unknown:
                        addSlider(param)
                        addSpacer()
                    case .slider:
                        addSlider(param)
                        addSpacer()
                    case .inputfield:
                        addNumberInput(param)
                        addSpacer()
                    default:
                        addSlider(param)
                        addSpacer()
                    }
                }
                if param is Int2Parameter || param is Int3Parameter || param is Int4Parameter || param is Float2Parameter || param is Float3Parameter || param is Float4Parameter {
                    if param is Float4Parameter && param.controlType == .colorpicker {
                        let colorParam = param as! Float4Parameter
                        addColorPicker(colorParam)
                        addSpacer()
                    }
                    else {
                        switch param.controlType {
                        case .inputfield:
                            addMultiNumberInput(param)
                            addSpacer()
                        default:
                            addMultiNumberInput(param)
                            addSpacer()
                        }
                    }
                }
                else if param is BoolParameter {
                    let boolParam = param as! BoolParameter
                    addToggle(boolParam)
                    addSpacer()
                }
                else if param is StringParameter {
                    let stringParam = param as! StringParameter
                    switch param.controlType {
                    case .dropdown:
                        addDropDown(stringParam)
                    case .label:
                        addLabel(stringParam)
                    default:
                        addLabel(stringParam)
                    }
                    addSpacer()
                }
            }
        }
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
        setState(state)
    }
    
    open func setState(_ state: Bool) {
        if state {
            open()
        }
        else {
            close()
        }
    }
    
    @objc open func onButtonChange() {
        if let button = self.button, button.state == .off {
            close()
        }
        else {
            open()
        }
    }
    
    open func close() {
        state = false
        
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
    
    open func open() {
        state = true
        
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
    
    open func isOpen() -> Bool {
        return state
    }
    
    open func addControl(_ control: ControlViewController) {
        guard let stack = self.stack else { return }
        stack.addView(control.view, in: .top)
        control.view.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        controls.append(control)
    }
    
    open func addSpacer() {
        guard let stack = self.stack else { return }
        let spacer = Spacer()
        stack.addView(spacer, in: .top)
        spacer.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    open func addColorPicker(_ parameter: Parameter) {
        let vc = ColorPickerViewController()
        vc.parameter = parameter
        addControl(vc)
    }
    
    open func addNumberInput(_ parameter: Parameter) {
        let vc = NumberInputViewController()
        vc.parameter = parameter
        addControl(vc)
    }
    
    open func addSlider(_ parameter: Parameter) {
        let vc = SliderViewController()
        vc.parameter = parameter
        addControl(vc)
    }
    
    open func addToggle(_ parameter: BoolParameter) {
        let vc = ToggleViewController()
        vc.parameter = parameter
        addControl(vc)
    }
    
    open func addLabel(_ parameter: StringParameter) {
        let vc = LabelViewController()
        vc.parameter = parameter
        addControl(vc)
    }
    
    open func addDropDown(_ parameter: StringParameter) {
        let vc = DropDownViewController()
        vc.parameter = parameter
        vc.options = parameter.options
        addControl(vc)
    }
    
    open func addMultiDropdown(_ parameters: [StringParameter]) {
        let vc = MultiDropdownViewController()
        vc.parameters = parameters
        addControl(vc)
    }
    
    open func addMultiDropdown(_ parameters: [StringParameter], _ options: [[String]]) {
        let vc = MultiDropdownViewController()
        vc.parameters = parameters
        vc.options = options
        addControl(vc)
    }
    
    open func addMultiNumberInput(_ parameter: Parameter) {
        let vc = MultiNumberInputViewController()
        vc.parameter = parameter
        addControl(vc)
    }
    
    open func addInput(_ parameter: StringParameter) {
        let vc = StringInputViewController()
        vc.parameter = parameter
        addControl(vc)
    }
    
    open func addProgressSlider(_ parameter: Parameter) -> ProgressSliderViewController? {
        let vc = ProgressSliderViewController()
        vc.parameter = parameter
        addControl(vc)
        return vc
    }
    
    open func addBindingInput(_ parameter: Parameter) {
        let vc = BindingInputViewController()
        vc.parameter = parameter
        addControl(vc)
    }
    
    open func addToggles(_ parameters: [BoolParameter]) {
        let vc = MultiToggleViewController()
        vc.parameters = parameters
        addControl(vc)
    }
    
    open func addDetails(_ details: [StringParameter]) {
        let vc = DetailsViewController()
        vc.details = details
        addControl(vc)
    }
    
    open func addDropDown(_ parameter: StringParameter, options: [String]) {
        let vc = DropDownViewController()
        vc.options = options
        vc.parameter = parameter
        addControl(vc)
    }
    
    open func addOptions(_ options: [String]) {
        let vc = OptionsViewController()
        vc.options = options
        vc.delegate = self
        addControl(vc)
    }
    
    open func onButtonPressed(_ sender: NSButton) {}
    
    open func removeAll() {
        if let stack = self.stack {
            for view in stack.views {
                view.removeFromSuperview()
            }
        }
        controls = []
    }
    
    open override func viewDidLayout() {
        super.viewDidLayout()
        delegate?.onPanelResized(panel: self)
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
