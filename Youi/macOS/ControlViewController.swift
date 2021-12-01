//
//  ControlViewController.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/14/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import AppKit
import Cocoa
import Satin

open class ControlViewController: InputViewController, OptionsViewControllerDelegate {
    public weak var parameters: ParameterGroup?
    public var controls: [NSViewController] = []
    public var stack: NSStackView?
    
//    public var viewHeightConstraint: NSLayoutConstraint?
    
    public convenience init(_ parameters: ParameterGroup) {
        self.init()
        self.parameters = parameters
    }
    
    open override func loadView() {
        setupView()
        setupStackView()
        setupParameters()
    }
    
    open func setupView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer?.backgroundColor = .clear
    }
    
    open func setupStackView() {
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
        self.stack = stack
    }
    
    open func setupParameters() {
        if let parameters = self.parameters {
            for param in parameters.params {
                if param is FloatParameter || param is IntParameter || param is DoubleParameter {
                    switch param.controlType {
                    case .slider:
                        addSlider(param)
                        addSpacer()
                    case .inputfield:
                        addNumberInput(param)
                        addSpacer()
                    case .unknown:
                        addNumberInput(param)
                        addSpacer()
                        
                    default:
                        break
                    }
                }
                if param is Int2Parameter || param is Int3Parameter || param is Int4Parameter || param is Float2Parameter || param is Float3Parameter || param is Float4Parameter {
                    if param is Float4Parameter, param.controlType == .colorpicker {
                        let colorParam = param as! Float4Parameter
                        addColorPicker(colorParam)
                        addSpacer()
                    }
                    else {
                        switch param.controlType {
                        case .inputfield:
                            addMultiNumberInput(param)
                            addSpacer()
                        case .colorpalette:
                            addColorPalette(param as! Float4Parameter)
                        case .unknown:
                            addMultiNumberInput(param)
                            addSpacer()
                        default:
                            break
                        }
                    }
                }
                else if param is BoolParameter {
                    let boolParam = param as! BoolParameter
                    switch param.controlType {
                    case .toggle:
                        addToggle(boolParam)
                        addSpacer()
                    case .button:
                        addButton(boolParam)
                        addSpacer()
                    case .unknown:
                        addToggle(boolParam)
                        addSpacer()
                    default:
                        break
                    }
                }
                else if param is StringParameter {
                    let stringParam = param as! StringParameter
                    switch param.controlType {
                    case .dropdown:
                        addDropDown(stringParam)
                    case .label:
                        addLabel(stringParam)
                    case .inputfield:
                        addInput(stringParam)
                    case .unknown:
                        addLabel(stringParam)
                    default:
                        break
                    }
                    addSpacer()
                }
                else if param is FileParameter {
                    let fileParam = param as! FileParameter
                    switch param.controlType {
                    case .filepicker:
                        addFilePicker(fileParam)
                    default:
                        break
                    }
                    addSpacer()
                }
            }
        }
    }
    
    open func addControl(_ control: NSViewController) {
        guard !controls.contains(control), let stack = self.stack else { return }
        stack.addView(control.view, in: .top)
        control.view.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
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
    
    open func addColorPalette(_ parameter: Float4Parameter) {
        var vc: ColorPaletteViewController
        
        var needsSpacer = false
        if controls.last is ColorPaletteViewController {
            vc = controls.last as! ColorPaletteViewController
        }
        else {
            vc = ColorPaletteViewController()
            needsSpacer = true
        }
        
        vc.parameters.append(parameter)
        addControl(vc)
        if needsSpacer {
            addSpacer()
        }
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
    
    open func addButton(_ parameter: BoolParameter) {
        let vc = ButtonViewController()
        vc.parameter = parameter
        addControl(vc)
    }
    
    open func addLabel(_ parameter: StringParameter) {
        let vc = LabelViewController()
        vc.parameter = parameter
        addControl(vc)
    }
    
    open func addFilePicker(_ parameter: FileParameter) {
        let vc = FilePickerViewController()
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
    
    open func removeAll() {
        if let stack = self.stack {
            for view in stack.views {
                view.removeFromSuperview()
            }
        }
        controls = []
    }
    
    open func onButtonPressed(_ sender: NSButton) {}
    
    deinit {
//        viewHeightConstraint = nil
        removeAll()
        parameters = nil
        stack = nil
    }
}
