//
//  MultiSliderViewController.swift
//  Youi-macOS
//
//  Created by Reza Ali on 12/9/21.
//

import Satin

#if os(macOS)

import Cocoa

open class MultiSliderViewController: InputViewController, NSTextFieldDelegate {
    public weak var parameter: Parameter?
    
    var valueObservations: [NSKeyValueObservation] = []
    var minObservations: [NSKeyValueObservation] = []
    var maxObservations: [NSKeyValueObservation] = []

    var inputFields: [NSTextField] = []
    var labelFields: [NSTextField] = []
    var sliders: [NSSlider] = []

    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        

        if let parameter = self.parameter {
            let labels: [String] = ["X","Y","Z","W"]
            
            var values: [Double] = []
            var mins: [Double] = []
            var maxes: [Double] = []
            
            
            if let param = parameter as? Float2Parameter {
                values.append(Double(param.x))
                values.append(Double(param.y))
                                
                mins.append(Double(param.min.x))
                mins.append(Double(param.min.y))
                                
                maxes.append(Double(param.max.x))
                maxes.append(Double(param.max.y))
                
                valueObservations.append(param.observe(\Float2Parameter.x, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[0].stringValue = String(format: "%.3f", value)
                            self?.sliders[0].floatValue = value
                        }
                    }
                })
                               
                valueObservations.append(param.observe(\Float2Parameter.y, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[1].stringValue = String(format: "%.3f", value)
                            self?.sliders[1].floatValue = value
                        }
                    }
                })
                
                minObservations.append(param.observe(\Float2Parameter.minX, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[0].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Float2Parameter.maxX, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[0].maxValue = Double(value)
                        }
                    }
                })
                
                minObservations.append(param.observe(\Float2Parameter.minY, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[1].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Float2Parameter.maxY, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[1].maxValue = Double(value)
                        }
                    }
                })
                
            }
            else if let param = parameter as? Float3Parameter {
                values.append(Double(param.x))
                values.append(Double(param.y))
                values.append(Double(param.z))
                
                mins.append(Double(param.min.x))
                mins.append(Double(param.min.y))
                mins.append(Double(param.min.z))
                
                maxes.append(Double(param.max.x))
                maxes.append(Double(param.max.y))
                maxes.append(Double(param.max.z))
                
                valueObservations.append(param.observe(\Float3Parameter.x, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[0].stringValue = String(format: "%.3f", value)
                            self?.sliders[0].floatValue = value
                        }
                    }
                })
                
                valueObservations.append(param.observe(\Float3Parameter.y, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[1].stringValue = String(format: "%.3f", value)
                            self?.sliders[1].floatValue = value
                        }
                    }
                })
                
                valueObservations.append(param.observe(\Float3Parameter.z, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[2].stringValue = String(format: "%.3f", value)
                            self?.sliders[2].floatValue = value
                        }
                    }
                })
                
                minObservations.append(param.observe(\Float3Parameter.minX, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[0].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Float3Parameter.maxX, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[0].maxValue = Double(value)
                        }
                    }
                })
                
                minObservations.append(param.observe(\Float3Parameter.minY, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[1].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Float3Parameter.maxY, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[1].maxValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Float3Parameter.minZ, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[2].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Float3Parameter.maxZ, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[2].maxValue = Double(value)
                        }
                    }
                })
            }
            if let param = parameter as? Float4Parameter {
                values.append(Double(param.x))
                values.append(Double(param.y))
                values.append(Double(param.z))
                values.append(Double(param.w))
                
                mins.append(Double(param.min.x))
                mins.append(Double(param.min.y))
                mins.append(Double(param.min.z))
                mins.append(Double(param.min.w))
                
                maxes.append(Double(param.max.x))
                maxes.append(Double(param.max.y))
                maxes.append(Double(param.max.z))
                maxes.append(Double(param.max.w))
                
                valueObservations.append(param.observe(\Float4Parameter.x, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[0].stringValue = String(format: "%.3f", value)
                            self?.sliders[0].floatValue = value
                        }
                    }
                })
                
                valueObservations.append(param.observe(\Float4Parameter.y, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[1].stringValue = String(format: "%.3f", value)
                            self?.sliders[1].floatValue = value
                        }
                    }
                })
                
                valueObservations.append(param.observe(\Float4Parameter.z, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[2].stringValue = String(format: "%.3f", value)
                            self?.sliders[2].floatValue = value
                        }
                    }
                })
                
                valueObservations.append(param.observe(\Float4Parameter.w, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[3].stringValue = String(format: "%.3f", value)
                            self?.sliders[3].floatValue = value
                        }
                    }
                })
                
                minObservations.append(param.observe(\Float4Parameter.minX, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[0].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Float4Parameter.maxX, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[0].maxValue = Double(value)
                        }
                    }
                })
                
                minObservations.append(param.observe(\Float4Parameter.minY, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[1].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Float4Parameter.maxY, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[1].maxValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Float4Parameter.minZ, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[2].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Float4Parameter.maxZ, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[2].maxValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Float4Parameter.minW, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[3].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Float4Parameter.maxW, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[3].maxValue = Double(value)
                        }
                    }
                })
            }
            else if let param = parameter as? Int2Parameter {
                values.append(Double(param.x))
                values.append(Double(param.y))
                                
                mins.append(Double(param.min.x))
                mins.append(Double(param.min.y))
                                
                maxes.append(Double(param.max.x))
                maxes.append(Double(param.max.y))
                
                valueObservations.append(param.observe(\Int2Parameter.x, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[0].stringValue = String(format: "%.3f", value)
                            self?.sliders[0].doubleValue = Double(value)
                        }
                    }
                })
                               
                valueObservations.append(param.observe(\Int2Parameter.y, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[1].stringValue = String(format: "%.3f", value)
                            self?.sliders[1].doubleValue = Double(value)
                        }
                    }
                })
                
                minObservations.append(param.observe(\Int2Parameter.minX, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[0].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Int2Parameter.maxX, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[0].maxValue = Double(value)
                        }
                    }
                })
                
                minObservations.append(param.observe(\Int2Parameter.minY, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[1].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Int2Parameter.maxY, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[1].maxValue = Double(value)
                        }
                    }
                })
                
            }
            else if let param = parameter as? Int3Parameter {
                values.append(Double(param.x))
                values.append(Double(param.y))
                values.append(Double(param.z))
                
                mins.append(Double(param.min.x))
                mins.append(Double(param.min.y))
                mins.append(Double(param.min.z))
                
                maxes.append(Double(param.max.x))
                maxes.append(Double(param.max.y))
                maxes.append(Double(param.max.z))
                
                valueObservations.append(param.observe(\Int3Parameter.x, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[0].stringValue = String(format: "%.3f", value)
                            self?.sliders[0].doubleValue = Double(value)
                        }
                    }
                })
                
                valueObservations.append(param.observe(\Int3Parameter.y, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[1].stringValue = String(format: "%.3f", value)
                            self?.sliders[1].doubleValue = Double(value)
                        }
                    }
                })
                
                valueObservations.append(param.observe(\Int3Parameter.z, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[2].stringValue = String(format: "%.3f", value)
                            self?.sliders[2].doubleValue = Double(value)
                        }
                    }
                })
                
                minObservations.append(param.observe(\Int3Parameter.minX, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[0].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Int3Parameter.maxX, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[0].maxValue = Double(value)
                        }
                    }
                })
                
                minObservations.append(param.observe(\Int3Parameter.minY, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[1].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Int3Parameter.maxY, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[1].maxValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Int3Parameter.minZ, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[2].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Int3Parameter.maxZ, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[2].maxValue = Double(value)
                        }
                    }
                })
            }
            if let param = parameter as? Int4Parameter {
                values.append(Double(param.x))
                values.append(Double(param.y))
                values.append(Double(param.z))
                values.append(Double(param.w))
                
                mins.append(Double(param.min.x))
                mins.append(Double(param.min.y))
                mins.append(Double(param.min.z))
                mins.append(Double(param.min.w))
                
                maxes.append(Double(param.max.x))
                maxes.append(Double(param.max.y))
                maxes.append(Double(param.max.z))
                maxes.append(Double(param.max.w))
                
                valueObservations.append(param.observe(\Int4Parameter.x, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[0].stringValue = String(format: "%.3f", value)
                            self?.sliders[0].doubleValue = Double(value)
                        }
                    }
                })
                
                valueObservations.append(param.observe(\Int4Parameter.y, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[1].stringValue = String(format: "%.3f", value)
                            self?.sliders[1].doubleValue = Double(value)
                        }
                    }
                })
                
                valueObservations.append(param.observe(\Int4Parameter.z, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[2].stringValue = String(format: "%.3f", value)
                            self?.sliders[2].doubleValue = Double(value)
                        }
                    }
                })
                
                valueObservations.append(param.observe(\Int4Parameter.w, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.inputFields[3].stringValue = String(format: "%.3f", value)
                            self?.sliders[3].doubleValue = Double(value)
                        }
                    }
                })
                
                minObservations.append(param.observe(\Int4Parameter.minX, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[0].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Int4Parameter.maxX, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[0].maxValue = Double(value)
                        }
                    }
                })
                
                minObservations.append(param.observe(\Int4Parameter.minY, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[1].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Int4Parameter.maxY, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[1].maxValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Int4Parameter.minZ, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[2].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Int4Parameter.maxZ, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[2].maxValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Int4Parameter.minW, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[3].minValue = Double(value)
                        }
                    }
                })
                
                maxObservations.append(param.observe(\Int4Parameter.maxW, options: [.old, .new]) { [unowned self] _, change in
                    if let value = change.newValue {
                        DispatchQueue.main.async { [weak self] in
                            self?.sliders[3].maxValue = Double(value)
                        }
                    }
                })
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
        }
    }

    @objc func onSliderChange(_ sender: NSSlider) {
        setValue(sender.doubleValue, sender.tag)
        self.inputFields[sender.tag].stringValue = String(format: "%.3f", sender.floatValue)
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
            self.sliders[sender.tag].doubleValue = value
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
        valueObservations = []
        minObservations = []
        maxObservations = []
        sliders = []
        labelFields = []
        inputFields = []
    }
}

#endif 