//
//  MultiSliderViewController.swift
//  Youi-macOS
//
//  Created by Reza Ali on 12/9/21.
//

import Combine
import Satin

#if os(macOS)

import Cocoa

open class MultiSliderViewController: InputViewController, NSTextFieldDelegate {
    public weak var parameter: Parameter?
    
    var cancellables = Set<AnyCancellable>()
    
    var inputFields: [NSTextField] = []
    var labelFields: [NSTextField] = []
    var sliders: [NSSlider] = []

    override open func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if let parameter = parameter {
            let labels: [String] = ["X", "Y", "Z", "W"]
            
            var values: [Double] = []
            var mins: [Double] = []
            var maxes: [Double] = []
            
            if let param = parameter as? Float2Parameter {
                for i in 0..<param.count {
                    values.append(Double(param.value[i]))
                    mins.append(Double(param.min[i]))
                    maxes.append(Double(param.max[i]))
                }
            }
            else if let param = parameter as? Float3Parameter {
                for i in 0..<param.count {
                    values.append(Double(param.value[i]))
                    mins.append(Double(param.min[i]))
                    maxes.append(Double(param.max[i]))
                }
            }
            else if let param = parameter as? Float4Parameter {
                for i in 0..<param.count {
                    values.append(Double(param.value[i]))
                    mins.append(Double(param.min[i]))
                    maxes.append(Double(param.max[i]))
                }
            }
            else if let param = parameter as? Int2Parameter {
                for i in 0..<param.count {
                    values.append(Double(param.value[i]))
                    mins.append(Double(param.min[i]))
                    maxes.append(Double(param.max[i]))
                }
            }
            else if let param = parameter as? Int3Parameter {
                for i in 0..<param.count {
                    values.append(Double(param.value[i]))
                    mins.append(Double(param.min[i]))
                    maxes.append(Double(param.max[i]))
                }
            }
            if let param = parameter as? Int4Parameter {
                for i in 0..<param.count {
                    values.append(Double(param.value[i]))
                    mins.append(Double(param.min[i]))
                    maxes.append(Double(param.max[i]))
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
            vStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
            vStack.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            vStack.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -8).isActive = true

            let hs0 = NSStackView()
            hs0.wantsLayer = true
            hs0.translatesAutoresizingMaskIntoConstraints = false
            hs0.orientation = .horizontal
            hs0.spacing = 0
            hs0.alignment = .centerY
            hs0.distribution = .fill
            vStack.addView(hs0, in: .leading)
            hs0.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -14).isActive = true
            
            let labelField = NSTextField()
            labelField.font = .labelFont(ofSize: 12)
            labelField.translatesAutoresizingMaskIntoConstraints = false
            labelField.isEditable = false
            labelField.isSelectable = true
            labelField.isBordered = false
            labelField.backgroundColor = .clear
            labelField.stringValue = parameter.label
            labelField.alignment = .natural
            hs0.addView(labelField, in: .leading)
            labelField.widthAnchor.constraint(equalTo: hs0.widthAnchor).isActive = true
            
            labelFields.append(labelField)
            
            let sliderStack = NSStackView()
            sliderStack.wantsLayer = true
            sliderStack.translatesAutoresizingMaskIntoConstraints = false
            sliderStack.orientation = .horizontal
            sliderStack.spacing = 2
            sliderStack.alignment = .centerY
            sliderStack.distribution = .fillEqually
            vStack.addView(sliderStack, in: .trailing)
            sliderStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -16).isActive = true
            
            for i in 0..<parameter.count {
                let vs = NSStackView()
                vs.wantsLayer = true
                vs.translatesAutoresizingMaskIntoConstraints = false
                vs.orientation = .vertical
                vs.spacing = 2
                vs.alignment = .leading
                vs.distribution = .fillEqually
                sliderStack.addView(vs, in: .leading)
                
                let slider = NSSlider(value: values[i], minValue: mins[i], maxValue: maxes[i], target: self, action: #selector(onSliderChange))
                slider.tag = i
                slider.wantsLayer = true
                slider.translatesAutoresizingMaskIntoConstraints = false
                vs.addView(slider, in: .top)
                
                sliders.append(slider)
                
                let hs = NSStackView()
                hs.wantsLayer = true
                hs.translatesAutoresizingMaskIntoConstraints = false
                hs.orientation = .horizontal
                hs.spacing = 0
                hs.alignment = .centerY
                hs.distribution = .gravityAreas
                vs.addView(hs, in: .leading)
                
                let labelField = NSTextField()
                labelField.font = .boldSystemFont(ofSize: 12)
                labelField.translatesAutoresizingMaskIntoConstraints = false
                labelField.isEditable = false
                labelField.isSelectable = true
                labelField.isBordered = false
                labelField.backgroundColor = .clear
                labelField.stringValue = "\(labels[i]):"
                labelField.alignment = .natural
        
                hs.addView(labelField, in: .leading)
                
                labelFields.append(labelField)
                
                let inputField = NSTextField()
                inputField.tag = i
                inputField.font = .boldSystemFont(ofSize: 12)
                inputField.wantsLayer = true
                inputField.translatesAutoresizingMaskIntoConstraints = false
                inputField.stringValue = "\(values[i])"
                inputField.isEditable = true
                inputField.isSelectable = true
                inputField.isBordered = false
                inputField.backgroundColor = .clear
                inputField.delegate = self
                inputField.target = self
                inputField.action = #selector(onInputChanged)
                hs.addView(inputField, in: .trailing)
                
                inputFields.append(inputField)
            }
            
            if let param = parameter as? Float2Parameter {
                param.$value.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.inputFields[i].stringValue = String(format: "%.3f", newValue[i])
                            self.sliders[i].doubleValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
                
                param.$min.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.sliders[i].minValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
                
                param.$max.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.sliders[i].maxValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? Float3Parameter {
                param.$value.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.inputFields[i].stringValue = String(format: "%.3f", newValue[i])
                            self.sliders[i].doubleValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
                
                param.$min.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.sliders[i].minValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
                
                param.$max.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.sliders[i].maxValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
            }
            if let param = parameter as? Float4Parameter {
                param.$value.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.inputFields[i].stringValue = String(format: "%.3f", newValue[i])
                            self.sliders[i].doubleValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
                
                param.$min.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.sliders[i].minValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
                
                param.$max.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.sliders[i].maxValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? Int2Parameter {
                param.$value.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.inputFields[i].stringValue = String(format: "%.3f", newValue[i])
                            self.sliders[i].doubleValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
                
                param.$min.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.sliders[i].minValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
                
                param.$max.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.sliders[i].maxValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? Int3Parameter {
                param.$value.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.inputFields[i].stringValue = String(format: "%.3f", newValue[i])
                            self.sliders[i].doubleValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
                
                param.$min.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.sliders[i].minValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
                
                param.$max.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.sliders[i].maxValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
            }
            if let param = parameter as? Int4Parameter {
                param.$value.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.inputFields[i].stringValue = String(format: "%.3f", newValue[i])
                            self.sliders[i].doubleValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
                
                param.$min.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.sliders[i].minValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
                
                param.$max.sink { [weak self] newValue in
                    if let self = self {
                        for i in 0..<param.count {
                            self.sliders[i].maxValue = Double(newValue[i])
                        }
                    }
                }.store(in: &cancellables)
            }
        }
    }

    @objc func onSliderChange(_ sender: NSSlider) {
        setValue(sender.doubleValue, sender.tag)
        inputFields[sender.tag].stringValue = String(format: "%.3f", sender.floatValue)
        deactivate()
    }

    func setValue(_ value: Double, _ tag: Int) {
        guard let parameter = parameter else { return }
        if parameter is Int2Parameter || parameter is Int3Parameter || parameter is Int4Parameter {
            let iValue = Int32(value)
            parameter[tag] = iValue
        }
        else if parameter is Float2Parameter || parameter is Float3Parameter || parameter is Float4Parameter || parameter is PackedFloat3Parameter {
            let fValue = Float(value)
            parameter[tag] = fValue
        }
    }

    @objc func onInputChanged(_ sender: NSTextField) {
        if let value = Double(sender.stringValue) {
            setValue(value, sender.tag)
            sliders[sender.tag].doubleValue = value
            deactivateAsync()
        }
    }
    
    public func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            let charSet = NSCharacterSet(charactersIn: "-1234567890.").inverted
            let chars = textField.stringValue.components(separatedBy: charSet)
            textField.stringValue = chars.joined()
        }
    }

    deinit {
        sliders = []
        labelFields = []
        inputFields = []
    }
}

#endif
