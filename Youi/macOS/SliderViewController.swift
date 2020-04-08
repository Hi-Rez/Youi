//
//  SliderView.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/14/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa
import Satin

protocol SliderViewControllerDelegate: AnyObject {
    func onValueChanged(_ sender: SliderViewController)
}

open class SliderViewController: ControlViewController, NSTextFieldDelegate {
    public weak var parameter: Parameter?
    var valueObservation: NSKeyValueObservation?
    var minObservation: NSKeyValueObservation?
    var maxObservation: NSKeyValueObservation?

    var inputField: NSTextField!
    var labelField: NSTextField!
    var slider: NSSlider!
    
    var delegate: SliderViewControllerDelegate?
    
    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 52).isActive = true

        if let parameter = self.parameter {
            var value: Double = 0.0
            var minValue: Double = 0.0
            var maxValue: Double = 1.0
            var stringValue: String = ""
            if parameter is FloatParameter {
                let param = parameter as! FloatParameter
                value = Double(param.value)
                minValue = Double(param.min)
                maxValue = Double(param.max)
                stringValue = String(format: "%.5f", value)
                valueObservation = param.observe(\FloatParameter.value, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        self.inputField.stringValue = String(format: "%.5f", value)
                        self.slider.doubleValue = Double(value)
                    }
                }
                minObservation = param.observe(\FloatParameter.min, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        self.slider.minValue = Double(value)
                    }
                }
                maxObservation = param.observe(\FloatParameter.max, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        self.slider.maxValue = Double(value)
                    }
                }
            }
            else if parameter is IntParameter {
                let param = parameter as! IntParameter
                value = Double(param.value)
                minValue = Double(param.min)
                maxValue = Double(param.max)
                stringValue = String(format: "%.0f", value)
                valueObservation = param.observe(\IntParameter.value, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        self.inputField.stringValue = String(value)
                        self.slider.doubleValue = Double(value)
                    }
                }
                minObservation = param.observe(\IntParameter.min, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        self.slider.minValue = Double(value)
                    }
                }
                maxObservation = param.observe(\IntParameter.max, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        self.slider.maxValue = Double(value)
                    }
                }
            }
            else if parameter is DoubleParameter {
                let param = parameter as! DoubleParameter
                value = param.value
                minValue = param.min
                maxValue = param.max
                stringValue = String(format: "%.5f", value)
                valueObservation = param.observe(\DoubleParameter.value, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        self.inputField.stringValue = String(format: "%.5f", value)
                        self.slider.doubleValue = value
                    }
                }
                minObservation = param.observe(\DoubleParameter.min, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        self.slider.minValue = value
                    }
                }
                maxObservation = param.observe(\DoubleParameter.max, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        self.slider.maxValue = value
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

            slider = NSSlider(value: value, minValue: minValue, maxValue: maxValue, target: self, action: #selector(onSliderChange))

            slider.wantsLayer = true
            slider.translatesAutoresizingMaskIntoConstraints = false

            vStack.addView(slider, in: .center)
            slider.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -16).isActive = true

            let hStack = NSStackView()
            hStack.wantsLayer = true
            hStack.translatesAutoresizingMaskIntoConstraints = false
            hStack.orientation = .horizontal
            hStack.spacing = 0
            hStack.alignment = .centerY
            hStack.distribution = .gravityAreas
            vStack.addView(hStack, in: .center)
            hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -14).isActive = true

            labelField = NSTextField()
            labelField.font = .labelFont(ofSize: 12)
            labelField.translatesAutoresizingMaskIntoConstraints = false
            labelField.isEditable = false
            labelField.isBordered = false
            labelField.backgroundColor = .clear
            labelField.stringValue = parameter.label + ":"
            hStack.addView(labelField, in: .leading)

            inputField = NSTextField()
            inputField.font = .boldSystemFont(ofSize: 12)
            inputField.stringValue = stringValue
            inputField.wantsLayer = true
            inputField.translatesAutoresizingMaskIntoConstraints = false
            inputField.stringValue = stringValue
            inputField.isEditable = true
            inputField.isBordered = false
            inputField.backgroundColor = .clear
            inputField.delegate = self
            inputField.resignFirstResponder()
            hStack.addView(inputField, in: .leading)            
        }
    }

    @objc func onSliderChange() {
        setValue(slider.doubleValue)
        deactivate()
        delegate?.onValueChanged(self)
    }

    func setValue(_ value: Double) {
        if let parameter = self.parameter {
            if parameter is FloatParameter {
                let floatParam = parameter as! FloatParameter
                floatParam.value = Float(value)
            }
            else if parameter is DoubleParameter {
                let doubleParam = parameter as! DoubleParameter
                doubleParam.value = value
            }
            else if parameter is IntParameter {
                let intParam = parameter as! IntParameter
                intParam.value = Int(value)
            }
        }
    }

    public func controlTextDidEndEditing(_ obj: Notification) {
        if let value = Double(inputField.stringValue) {
            setValue(value)
            delegate?.onValueChanged(self)
        }
        deactivate()
    }

    public func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            let charSet = NSCharacterSet(charactersIn: "-1234567890.").inverted
            let chars = textField.stringValue.components(separatedBy: charSet)
            textField.stringValue = chars.joined()
        }
    }
    
    deinit {
        print("Removing SliderViewController: \(parameter?.label ?? "nil")")
    }
}
