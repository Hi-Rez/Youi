//
//  ProgressSliderViewController.swift
//  Slate
//
//  Created by Reza Ali on 3/27/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Combine
import Satin

#if os(macOS)

import Cocoa

public protocol ProgressSliderViewControllerDelegate: AnyObject {
    func onValueChanged(_ sender: ProgressSliderViewController)
}

open class ProgressSliderViewController: NSViewController {
    public weak var parameter: Parameter?
    var cancellables = Set<AnyCancellable>()

    public var slider: NSSlider!

    public weak var delegate: ProgressSliderViewControllerDelegate?

    override open func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true

        if let parameter = parameter {
            var value: Double = 0.0
            var minValue: Double = 0.0
            var maxValue: Double = 1.0
            if parameter is FloatParameter {
                let param = parameter as! FloatParameter
                value = Double(param.value)
                minValue = Double(param.min)
                maxValue = Double(param.max)
                param.$value.sink { [weak self] newValue in
                    if let self = self {
                        self.slider.doubleValue = Double(newValue)
                    }
                }.store(in: &cancellables)

                param.$min.sink { [weak self] newValue in
                    if let self = self {
                        self.slider.minValue = Double(newValue)
                    }
                }.store(in: &cancellables)

                param.$max.sink { [weak self] newValue in
                    if let self = self {
                        self.slider.maxValue = Double(newValue)
                    }
                }.store(in: &cancellables)
            }
            else if parameter is IntParameter {
                let param = parameter as! IntParameter
                value = Double(param.value)
                minValue = Double(param.min)
                maxValue = Double(param.max)
                param.$value.sink { [weak self] newValue in
                    if let self = self {
                        self.slider.doubleValue = Double(newValue)
                    }
                }.store(in: &cancellables)

                param.$min.sink { [weak self] newValue in
                    if let self = self {
                        self.slider.minValue = Double(newValue)
                    }
                }.store(in: &cancellables)

                param.$max.sink { [weak self] newValue in
                    if let self = self {
                        self.slider.maxValue = Double(newValue)
                    }
                }.store(in: &cancellables)
            }
            else if parameter is DoubleParameter {
                let param = parameter as! DoubleParameter
                value = param.value
                minValue = param.min
                maxValue = param.max

                param.$value.sink { [weak self] newValue in
                    if let self = self {
                        self.slider.doubleValue = Double(newValue)
                    }
                }.store(in: &cancellables)

                param.$min.sink { [weak self] newValue in
                    if let self = self {
                        self.slider.minValue = Double(newValue)
                    }
                }.store(in: &cancellables)

                param.$max.sink { [weak self] newValue in
                    if let self = self {
                        self.slider.maxValue = Double(newValue)
                    }
                }.store(in: &cancellables)
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
        delegate?.onValueChanged(self)
    }

    func setValue(_ value: Double) {
        if let parameter = parameter {
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
        delegate = nil
        parameter = nil
    }
}

#endif
