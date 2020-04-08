//
//  ProgressSliderViewController.swift
//  Slate
//
//  Created by Reza Ali on 3/27/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa
import Satin

protocol ProgressSliderViewControllerDelegate: AnyObject {
    func onValueChanged(_ sender: ProgressSliderViewController)
}

open class ProgressSliderViewController: ControlViewController {
    weak var parameter: Parameter?
    var valueObservation: NSKeyValueObservation?
    var minObservation: NSKeyValueObservation?
    var maxObservation: NSKeyValueObservation?
    var slider: NSSlider!
    
    weak var delegate: ProgressSliderViewControllerDelegate?
    
    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true

        if let parameter = self.parameter {
            var value: Double = 0.0
            var minValue: Double = 0.0
            var maxValue: Double = 1.0
            if parameter is FloatParameter {
                let param = parameter as! FloatParameter
                value = Double(param.value)
                minValue = Double(param.min)
                maxValue = Double(param.max)
                valueObservation = param.observe(\FloatParameter.value, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
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
                valueObservation = param.observe(\IntParameter.value, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
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
                valueObservation = param.observe(\DoubleParameter.value, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
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
            slider.ignoresMultiClick = true
            slider.translatesAutoresizingMaskIntoConstraints = false
            vStack.addView(slider, in: .center)
            slider.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -16).isActive = true
            
            slider.target = self
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
        
    deinit {
        print("Removing ProgressSliderViewController: \(parameter?.label ?? "nil")")
        delegate = nil
        parameter = nil
    }
}
