//
//  PanelViewController.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/14/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa
import Satin

protocol PanelViewControllerDelegate: AnyObject {
    func onPanelOpen(panel: PanelViewController)
    func onPanelClose(panel: PanelViewController)
    func onPanelResized(panel: PanelViewController)
}

open class PanelViewController: ControlViewController {
    public weak var parameters: ParameterGroup?
    var controls: [NSViewController] = []
    var state: Bool = false
    var button: NSButton?
    var stackView: NSStackView?
    var vStack: NSStackView?
    var labelField: NSTextField?
    
    open override var title: String? {
        didSet {
            if let title = self.title {
                labelField?.stringValue = title
            }
        }
    }
    
    weak var delegate: PanelViewControllerDelegate?
    
    public convenience init(_ title: String, parameters: ParameterGroup) {
        self.init()
        self.title = title
        self.parameters = parameters
    }
    
    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer?.backgroundColor = .clear
        
        let vStack = NSStackView()
        vStack.wantsLayer = true
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.orientation = .vertical
        vStack.spacing = 0
        vStack.distribution = .gravityAreas
        view.addSubview(vStack)
        vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        vStack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vStack.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: vStack.heightAnchor).isActive = true
        
        let hStack = NSStackView()
        hStack.wantsLayer = true
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.orientation = .horizontal
        hStack.spacing = 4
        hStack.alignment = .centerY
        hStack.distribution = .gravityAreas
        vStack.addView(hStack, in: .top)
        hStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hStack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        hStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        hStack.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
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
        
        let labelField = NSTextField()
        labelField.font = .systemFont(ofSize: 14, weight: .regular)
        labelField.wantsLayer = true
        labelField.translatesAutoresizingMaskIntoConstraints = false
        labelField.isEditable = false
        labelField.isBordered = false
        labelField.backgroundColor = .clear
        if let title = self.title {
            labelField.stringValue = title
        }
        else {
            labelField.stringValue = "Panel"
        }
        hStack.addView(labelField, in: .leading)
        
        let spacer = Spacer()
        vStack.addView(spacer, in: .top)
        spacer.heightAnchor.constraint(equalToConstant: 1).isActive = true
        spacer.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
        
        let stackView = NSStackView()
        stackView.wantsLayer = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        vStack.addView(stackView, in: .bottom)
        stackView.orientation = .vertical
        stackView.distribution = .gravityAreas
        stackView.spacing = 0
        
        stackView.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        
        self.button = button
        self.stackView = stackView
        self.vStack = vStack
        self.labelField = labelField
        
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
                if param is Int2Parameter || param is Float2Parameter {
                    switch param.controlType {
                    case .inputfield:
                        addMultiNumberInput(param)
                        addSpacer()
                    default:
                        addMultiNumberInput(param)
                        addSpacer()
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
                else if param is Float4Parameter {
                    let colorParam = param as! Float4Parameter
                    addColorPicker(colorParam)
                    addSpacer()
                }
            }
        }
        
        setState(state)
    }
    
    public func setState(_ state: Bool) {
        if state {
            open()
        }
        else {
            close()
        }
    }
    
    @objc func onButtonChange() {
        if let button = self.button, button.state == .off {
            close()
        }
        else {
            open()
        }
    }
    
    func close() {
        state = false
        
        if let button = self.button {
            button.state = .off
        }
        
        if let vStack = self.vStack, let stackView = self.stackView {
            if vStack.views.contains(stackView) {
                vStack.removeView(stackView)
            }
        }
        
        delegate?.onPanelClose(panel: self)
    }
    
    func open() {
        state = true
        
        if let button = self.button {
            button.state = .on
        }
        
        if let vStack = self.vStack, let stackView = self.stackView {
            if !vStack.views.contains(stackView) {
                vStack.addView(stackView, in: .bottom)
                stackView.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
            }
        }
        
        delegate?.onPanelOpen(panel: self)
    }
    
    public func isOpen() -> Bool {
        return state
    }
    
    func addColorPicker(_ parameter: Parameter) {
        let colorPickerViewController = ColorPickerViewController()
        colorPickerViewController.parameter = parameter
        if let stackView = self.stackView {
            stackView.addView(colorPickerViewController.view, in: .top)
            colorPickerViewController.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        controls.append(colorPickerViewController)
    }
    
    func addNumberInput(_ parameter: Parameter) {
        let numberInputViewController = NumberInputViewController()
        numberInputViewController.parameter = parameter
        if let stackView = self.stackView {
            stackView.addView(numberInputViewController.view, in: .top)
            numberInputViewController.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        controls.append(numberInputViewController)
    }
    
    func addSlider(_ parameter: Parameter) {
        let sliderViewController = SliderViewController()
        sliderViewController.parameter = parameter
        if let stackView = self.stackView {
            stackView.addView(sliderViewController.view, in: .top)
            sliderViewController.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        controls.append(sliderViewController)
    }
    
    func addToggle(_ parameter: BoolParameter) {
        let toggleViewController = ToggleViewController()
        toggleViewController.parameter = parameter
        if let stackView = self.stackView {
            stackView.addView(toggleViewController.view, in: .top)
            toggleViewController.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        controls.append(toggleViewController)
    }
    
    func addLabel(_ parameter: StringParameter) {
        let labelViewController = LabelViewController()
        labelViewController.parameter = parameter
        if let stackView = self.stackView {
            stackView.addView(labelViewController.view, in: .top)
            labelViewController.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        controls.append(labelViewController)
    }
    
    func addDropDown(_ parameter: StringParameter) {
        let vc = DropDownViewController()
        vc.parameter = parameter
        vc.options = parameter.options
        if let stackView = self.stackView {
            stackView.addView(vc.view, in: .top)
            vc.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        controls.append(vc)
    }
    
    func addMultiDropdown(_ parameters: [StringParameter]) {
        let vc = MultiDropdownViewController()
        vc.parameters = parameters
        if let stackView = self.stackView {
            stackView.addView(vc.view, in: .top)
            vc.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        controls.append(vc)
    }
    
    func addMultiDropdown(_ parameters: [StringParameter], _ options: [[String]]) {
        let vc = MultiDropdownViewController()
        vc.parameters = parameters
        vc.options = options
        if let stackView = self.stackView {
            stackView.addView(vc.view, in: .top)
            vc.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        controls.append(vc)
    }
    
    func addMultiNumberInput(_ parameter: Parameter) {
        print("setting ui for: \(parameter.label)")
        let vc = MultiNumberInputViewController()
        vc.parameter = parameter
        if let stackView = self.stackView {
            stackView.addView(vc.view, in: .top)
            vc.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        controls.append(vc)
    }
    
    func addSpacer() {
        let spacer = Spacer()
        if let stackView = self.stackView {
            stackView.addView(spacer, in: .top)
            var dpr = CGFloat(1.0)
            if let window = view.window {
                dpr = CGFloat(window.backingScaleFactor)
            }
            spacer.heightAnchor.constraint(equalToConstant: 1.0 / dpr).isActive = true
            spacer.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
    }
    
    open override func viewDidLayout() {
        super.viewDidLayout()
        delegate?.onPanelResized(panel: self)
    }
    
    deinit {
        controls = []
        parameters = nil
        button = nil
        stackView = nil
        vStack = nil
        labelField = nil
    }
}
