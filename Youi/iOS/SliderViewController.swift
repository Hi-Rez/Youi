//
//  SliderViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/2/21.
//

import UIKit
import Satin

class SliderViewController: WidgetViewController {
    var valueObservation: NSKeyValueObservation?
    var minObservation: NSKeyValueObservation?
    var maxObservation: NSKeyValueObservation?

    override var minHeight: CGFloat {
        64
    }
    
    var slider: UISlider?

    override open func loadView() {
        setupView()
        setupVerticalStackView()
        setupSlider()
        setupHorizontalStackView()
        setupLabel()
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
                if let value = change.newValue, let label = self.label, let slider = self.slider {
                    label.text = "\(param.label): " + String(format: "%.3f", value)
                    slider.value = value
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
                if let value = change.newValue, let label = self.label, let slider = self.slider  {
                    label.text = "\(param.label): " + String(value)
                    slider.value = Float(value)
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
                if let value = change.newValue, let label = self.label, let slider = self.slider  {
                    label.text = "\(param.label): " + String(format: "%.3f", value)
                    slider.value = Float(value)
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
        
        guard let slider = self.slider else { return }
        slider.minimumValue = minValue
        slider.maximumValue = maxValue
        slider.value = value
        guard let label = self.label else { return }
        label.text = "\(parameter.label): \(stringValue)"
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
