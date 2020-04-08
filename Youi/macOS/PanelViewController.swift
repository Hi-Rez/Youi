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
    public var parameters: ParameterGroup?
    var numberInputs: [NumberInputViewController] = []
    var sliders: [SliderViewController] = []
    var toggles: [ToggleViewController] = []
    var labels: [LabelViewController] = []
    var colorPickers: [ColorPickerViewController] = []
    
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
        hStack.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
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
        labelField.font = .boldSystemFont(ofSize: 12)
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
                else if param is BoolParameter {
                    let boolParam = param as! BoolParameter
                    addToggle(boolParam)
                    addSpacer()
                }
                else if param is StringParameter {
                    let stringParam = param as! StringParameter
                    addLabel(stringParam)
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
        colorPickers.append(colorPickerViewController)
    }
    
    func addNumberInput(_ parameter: Parameter) {
        let numberInputViewController = NumberInputViewController()
        numberInputViewController.parameter = parameter
        if let stackView = self.stackView {
            stackView.addView(numberInputViewController.view, in: .top)
            numberInputViewController.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        numberInputs.append(numberInputViewController)
    }
    
    func addSlider(_ parameter: Parameter) {
        let sliderViewController = SliderViewController()
        sliderViewController.parameter = parameter
        if let stackView = self.stackView {
            stackView.addView(sliderViewController.view, in: .top)
            sliderViewController.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        sliders.append(sliderViewController)
    }
    
    func addToggle(_ parameter: BoolParameter) {
        let toggleViewController = ToggleViewController()
        toggleViewController.parameter = parameter
        if let stackView = self.stackView {
            stackView.addView(toggleViewController.view, in: .top)
            toggleViewController.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        toggles.append(toggleViewController)
    }
    
    func addLabel(_ parameter: StringParameter) {
        let labelViewController = LabelViewController()
        labelViewController.parameter = parameter
        if let stackView = self.stackView {
            stackView.addView(labelViewController.view, in: .top)
            labelViewController.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        }
        labels.append(labelViewController)
    }
    
    func addSpacer()
    {
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
        print("Removing PanelViewController: \(title ?? "nil")")
    }
}
