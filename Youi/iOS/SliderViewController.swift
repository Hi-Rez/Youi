//
//  SliderViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/2/21.
//

import Satin
import UIKit

class SliderViewController: WidgetViewController, UITextFieldDelegate {
    var valueObservation: NSKeyValueObservation?
    var minObservation: NSKeyValueObservation?
    var maxObservation: NSKeyValueObservation?

    override var minHeight: CGFloat {
        64
    }
    
    var slider: UISlider?
    var input: UITextField?
    
    var font: UIFont {
        .boldSystemFont(ofSize: 14)
    }

    override open func loadView() {
        setupView()
        setupVerticalStackView()
        setupSlider()
        setupHorizontalStackView()
        setupLabel()
        setupInput()
        setupBinding()
    }
    
    override func setupVerticalStackView() {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .leading
        stack.distribution = .fill
        view.addSubview(stack)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -8).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        vStack = stack
    }
    
    override func setupHorizontalStackView() {
        guard let vStack = self.vStack else { return }
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.distribution = .fill
        vStack.addArrangedSubview(stack)
        stack.centerXAnchor.constraint(equalTo: vStack.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: 0).isActive = true
        hStack = stack
    }
    
    func setupInput() {
        guard let hStack = self.hStack else { return }
        let input = UITextField()
        input.borderStyle = .none
        input.translatesAutoresizingMaskIntoConstraints = false
        input.font = font
        input.backgroundColor = .clear
        input.textAlignment = .right
        input.contentHuggingPriority(for: .horizontal)
        input.addAction(UIAction(handler: { [unowned self] _ in
            if let input = self.input, let text = input.text, let value = Float(text) {
                setValue(value)
            }
        }), for: .editingChanged)
        hStack.addArrangedSubview(input)
        input.delegate = self
        self.input = input
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    } // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let input = self.input, let text = input.text, let value = Float(text) {
            setValue(value)
        }
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard !string.isEmpty else {
            return true
        }
        
        if !CharacterSet(charactersIn: "-0123456789.").isSuperset(of: CharacterSet(charactersIn: string)) {
            return false
        }
        if string == ".", let text = textField.text, text.contains(".") {
            return false
        }
        
        // Allow text change
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupSlider() {
        guard let vStack = self.vStack else { return }
        let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 32, height: 32), primaryAction: UIAction(handler: { [unowned self] _ in
            if let slider = self.slider {
                self.setValue(slider.value)
            }
        }))
        slider.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(slider)
        slider.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: 0).isActive = true
        self.slider = slider
    }

    override func setupBinding() {
        guard let parameter = self.parameter else { return }
        var value: Float = 0.0
        var minValue: Float = 0.0
        var maxValue: Float = 1.0
        var stringValue: String = ""
        if let param = parameter as? FloatParameter {
            value = param.value
            minValue = param.min
            maxValue = param.max
            stringValue = String(format: "%.3f", value)
            valueObservation = param.observe(\FloatParameter.value, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let slider = self.slider, let input = self.input, !input.isFirstResponder {
                    DispatchQueue.main.async {
                        input.text = String(format: "%.3f", value)
                        slider.value = value
                    }
                }
            }
            minObservation = param.observe(\FloatParameter.min, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let slider = self.slider {
                    slider.minimumValue = value
                }
            }
            maxObservation = param.observe(\FloatParameter.max, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let slider = self.slider {
                    slider.maximumValue = value
                }
            }
        }
        else if let param = parameter as? IntParameter {
            value = Float(param.value)
            minValue = Float(param.min)
            maxValue = Float(param.max)
            stringValue = "\(param.value)"
            valueObservation = param.observe(\IntParameter.value, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let slider = self.slider, let input = self.input, !input.isFirstResponder {
                    DispatchQueue.main.async {
                        input.text = "\(value)"
                        slider.value = Float(value)
                    }
                }
            }
            minObservation = param.observe(\IntParameter.min, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let slider = self.slider {
                    slider.minimumValue = Float(value)
                }
            }
            maxObservation = param.observe(\IntParameter.max, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let slider = self.slider {
                    slider.maximumValue = Float(value)
                }
            }
        }
        else if let param = parameter as? DoubleParameter {
            value = Float(param.value)
            minValue = Float(param.min)
            maxValue = Float(param.max)
            stringValue = String(format: "%.3f", value)
            valueObservation = param.observe(\DoubleParameter.value, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let slider = self.slider, let input = self.input, !input.isFirstResponder {
                    DispatchQueue.main.async {
                        input.text = String(format: "%.3f", value)
                        slider.value = Float(value)
                    }
                }
            }
            minObservation = param.observe(\DoubleParameter.min, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let slider = self.slider {
                    slider.minimumValue = Float(value)
                }
            }
            maxObservation = param.observe(\DoubleParameter.max, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let slider = self.slider {
                    slider.maximumValue = Float(value)
                }
            }
        }
        
        if let slider = self.slider {
            slider.minimumValue = minValue
            slider.maximumValue = maxValue
            slider.value = value
        }
        
        if let label = self.label {
            label.text = "\(parameter.label)"
        }
        
        if let input = self.input {
            input.text = "\(stringValue)"
        }
    }

    func setValue(_ value: Float) {
        if let parameter = self.parameter {
            if parameter is FloatParameter {
                let floatParam = parameter as! FloatParameter
                floatParam.value = value
            }
            else if parameter is DoubleParameter {
                let doubleParam = parameter as! DoubleParameter
                doubleParam.value = Double(value)
            }
            else if parameter is IntParameter {
                let intParam = parameter as! IntParameter
                intParam.value = Int(value)
            }
        }
    }
    
    deinit {
        valueObservation = nil
        minObservation = nil
        maxObservation = nil
        slider = nil
    }
}
