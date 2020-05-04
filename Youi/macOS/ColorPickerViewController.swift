//
//  SliderView.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/14/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa
import Satin
import simd

open class ColorPickerViewController: NSViewController {
    public weak var parameter: Parameter?
    var observationR: NSKeyValueObservation?
    var observationG: NSKeyValueObservation?
    var observationB: NSKeyValueObservation?
    var observationA: NSKeyValueObservation?
    var labelField: NSTextField!
    var colorWell: NSColorWell!

    open override func loadView() {
        NSColorPanel.shared.showsAlpha = true

        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true

        if let parameter = self.parameter {
            if parameter is Float4Parameter {
                let param = parameter as! Float4Parameter
                observationR = param.observe(\Float4Parameter.x, options: [.old, .new]) { [unowned self] _, _ in
                    let value = param.value
                    self.colorWell.color = NSColor(calibratedRed: CGFloat(value.x), green: CGFloat(value.y), blue: CGFloat(value.z), alpha: CGFloat(value.w))
                }

                observationG = param.observe(\Float4Parameter.y, options: [.old, .new]) { [unowned self] _, _ in
                    let value = param.value
                    self.colorWell.color = NSColor(calibratedRed: CGFloat(value.x), green: CGFloat(value.y), blue: CGFloat(value.z), alpha: CGFloat(value.w))
                }

                observationB = param.observe(\Float4Parameter.z, options: [.old, .new]) { [unowned self] _, _ in
                    let value = param.value
                    self.colorWell.color = NSColor(calibratedRed: CGFloat(value.x), green: CGFloat(value.y), blue: CGFloat(value.z), alpha: CGFloat(value.w))
                }

                observationA = param.observe(\Float4Parameter.w, options: [.old, .new]) { [unowned self] _, _ in
                    let value = param.value
                    self.colorWell.color = NSColor(calibratedRed: CGFloat(value.x), green: CGFloat(value.y), blue: CGFloat(value.z), alpha: CGFloat(value.w))
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

            let hStack = NSStackView()
            hStack.wantsLayer = true
            hStack.translatesAutoresizingMaskIntoConstraints = false
            vStack.addView(hStack, in: .center)
            hStack.orientation = .horizontal
            hStack.alignment = .centerY
            hStack.distribution = .gravityAreas
            hStack.spacing = 4

            hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -16).isActive = true

            colorWell = NSColorWell()
            colorWell.wantsLayer = true
            if parameter is Float4Parameter {
                let param = parameter as! Float4Parameter
                let value = param.value
                colorWell.color = NSColor(calibratedRed: CGFloat(value.x), green: CGFloat(value.y), blue: CGFloat(value.z), alpha: CGFloat(value.w))
            }
            colorWell.translatesAutoresizingMaskIntoConstraints = false
            colorWell.widthAnchor.constraint(equalToConstant: 24).isActive = true
            colorWell.heightAnchor.constraint(equalToConstant: 24).isActive = true

            colorWell.target = self
            colorWell.action = #selector(ColorPickerViewController.onColorChange)

            hStack.addView(colorWell, in: .leading)

            labelField = NSTextField()
            labelField.font = .labelFont(ofSize: 12)
            labelField.wantsLayer = true
            labelField.translatesAutoresizingMaskIntoConstraints = false
            labelField.isEditable = false
            labelField.isBordered = false
            labelField.backgroundColor = .clear
            labelField.stringValue = parameter.label
            hStack.addView(labelField, in: .leading)
        }
    }

    @objc func onColorChange(_ sender: NSColorWell) {
        if let color = sender.color.usingColorSpace(.deviceRGB) {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            if let parameter = self.parameter {
                if parameter is Float4Parameter {
                    let float4Param = parameter as! Float4Parameter
                    float4Param.value = simd_make_float4(Float(red), Float(green), Float(blue), Float(alpha))
                }
            }
        }
    }

    deinit {}
}
