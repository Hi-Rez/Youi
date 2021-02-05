//
//  ControlViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/2/21.
//

import Satin
import UIKit

open class ControlViewController: UIViewController {
    public weak var parameters: ParameterGroup?
    public var controls: [UIViewController] = []
    public var controlsStack: UIStackView?
    
    public convenience init(_ parameters: ParameterGroup) {
        self.init()
        self.parameters = parameters
    }
    
    var param = FloatParameter("Slider", 0.5, 0.0, 1.0, .slider)
    
    open override func loadView() {
        setupView()
        setupStackView()
        setupParameters()
    }
    
    func setupView() {
        view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 240).isActive = true
    }
    
    func setupStackView() {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .center
        view.addSubview(stack)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        controlsStack = stack
    }
    
    func setupParameters() {
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
                        addSpacer()
                    case .label:
                        addLabel(stringParam)
                        addSpacer()
                    case .inputfield:
                        addInput(stringParam)
                        addSpacer()
                    case .unknown:
                        addLabel(stringParam)
                        addSpacer()
                    default:
                        break
                    }
                }
                else if param is FileParameter {
                    let fileParam = param as! FileParameter
                    switch param.controlType {
                    case .filepicker:
                        addFilePicker(fileParam)
                        addSpacer()
                    default:
                        break
                    }
                }
            }
        }
    }
    
    open func addControl(_ control: UIViewController) {
        guard let stack = controlsStack else { return }
        stack.addArrangedSubview(control.view)
        control.view.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        control.view.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        controls.append(control)
    }
    
    open func addSpacer() {
        guard let stack = controlsStack else { return }
        let spacer = Spacer()
        stack.addArrangedSubview(spacer)
        spacer.heightAnchor.constraint(equalToConstant: 1).isActive = true
        spacer.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
    }
    
    open func addColorPicker(_ parameter: Parameter) {
        let vc = ColorPickerViewController()
        vc.parameter = parameter as? Float4Parameter
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
    
    open func addFilePicker(_ parameter: FileParameter) {
//        let vc = FilePickerViewController()
//        vc.parameter = parameter
//        addControl(vc)
    }
    
    open func addDropDown(_ parameter: StringParameter) {
        let vc = DropDownViewController()
        vc.parameter = parameter
        vc.options = parameter.options
        addControl(vc)
    }
    
    open func addMultiDropdown(_ parameters: [StringParameter]) {
//        let vc = MultiDropdownViewController()
//        vc.parameters = parameters
//        addControl(vc)
    }
    
    open func addMultiDropdown(_ parameters: [StringParameter], _ options: [[String]]) {
//        let vc = MultiDropdownViewController()
//        vc.parameters = parameters
//        vc.options = options
//        addControl(vc)
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
    
//    open func addProgressSlider(_ parameter: Parameter) -> ProgressSliderViewController? {
//        let vc = ProgressSliderViewController()
//        vc.parameter = parameter
//        addControl(vc)
//        return vc
//    }
    
    open func addBindingInput(_ parameter: Parameter) {
//        let vc = BindingInputViewController()
//        vc.parameter = parameter
//        addControl(vc)
    }
    
    open func addToggles(_ parameters: [BoolParameter]) {
//        let vc = MultiToggleViewController()
//        vc.parameters = parameters
//        addControl(vc)
    }
    
    open func addDetails(_ details: [StringParameter]) {
//        let vc = DetailsViewController()
//        vc.details = details
//        addControl(vc)
    }
    
    open func addDropDown(_ parameter: StringParameter, options: [String]) {
//        let vc = DropDownViewController()
//        vc.options = options
//        vc.parameter = parameter
//        addControl(vc)
    }
    
    open func addOptions(_ options: [String]) {
//        let vc = OptionsViewController()
//        vc.options = options
//        vc.delegate = self
//        addControl(vc)
    }
    
    open func removeAll() {
        if let stack = controlsStack {
            for view in stack.subviews {
                view.removeFromSuperview()
            }
        }
        controls = []
    }
    
    deinit {
        removeAll()
        parameters = nil
        controlsStack = nil
    }
}
