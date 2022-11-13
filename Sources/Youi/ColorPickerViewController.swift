//
//  SliderView.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/14/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Combine
import simd

import Satin

#if os(macOS)

import Cocoa

open class ColorPickerViewController: NSViewController {
    public weak var parameter: Parameter?
    var cancellable: AnyCancellable?

    var labelField: NSTextField?
    var colorWell: NSColorWell?
    
    var hasAlpha: Bool {
        return parameter is Float4Parameter
    }

    override open func loadView() {
        NSColorPanel.shared.showsAlpha = true

        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true

        guard let parameter = parameter else { return }

        var value: simd_float4 = .one
        
        if let param = parameter as? Float4Parameter {
            cancellable = param.$value.sink { [weak self] value in
                if let self = self, let colorWell = self.colorWell {
                    colorWell.color = NSColor(deviceRed: CGFloat(value.x), green: CGFloat(value.y), blue: CGFloat(value.z), alpha: CGFloat(value.w))
                }
            }
            value = param.value
        }
        else if let param = parameter as? Float3Parameter {
            cancellable = param.$value.sink { [weak self] value in
                if let self = self, let colorWell = self.colorWell {
                    colorWell.color = NSColor(deviceRed: CGFloat(value.x), green: CGFloat(value.y), blue: CGFloat(value.z), alpha: 1.0)
                }
            }
            value = simd_make_float4(param.value, 1.0)
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

        let colorWell = NSColorWell()
        colorWell.wantsLayer = true
        
        colorWell.color = NSColor(deviceRed: CGFloat(value.x), green: CGFloat(value.y), blue: CGFloat(value.z), alpha: CGFloat(value.w))
        
        colorWell.translatesAutoresizingMaskIntoConstraints = false
        colorWell.widthAnchor.constraint(equalToConstant: 24).isActive = true
        colorWell.heightAnchor.constraint(equalToConstant: 24).isActive = true
        colorWell.target = self
        colorWell.action = #selector(ColorPickerViewController.onColorChange)
        hStack.addView(colorWell, in: .leading)
        self.colorWell = colorWell

        let labelField = NSTextField()
        labelField.font = .labelFont(ofSize: 12)
        labelField.wantsLayer = true
        labelField.translatesAutoresizingMaskIntoConstraints = false
        labelField.isEditable = false
        labelField.isBordered = false
        labelField.backgroundColor = .clear
        labelField.stringValue = parameter.label
        hStack.addView(labelField, in: .leading)
        self.labelField = labelField
    }
    
    @objc func onColorChange(_ sender: NSColorWell) {
        if let parameter = parameter, let color = sender.color.usingColorSpace(.deviceRGB) {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            if let param = parameter as? Float4Parameter {
                param.value = simd_make_float4(Float(red), Float(green), Float(blue), Float(alpha))
            }
            else if let param = parameter as? Float3Parameter {
                param.value = simd_make_float3(Float(red), Float(green), Float(blue))
            }
        }
    }
}

#elseif os(iOS)

import UIKit

class ColorPickerViewController: WidgetViewController {
    var cancellables = Set<AnyCancellable>()
    var colorWell: UIColorWell?

    override var minHeight: CGFloat {
        56
    }

    override open func loadView() {
        setupView()
        setupStackViews()
        setupColorWell()
        setupLabel()
        setupBinding()
    }

    override func setupHorizontalStackView() {
        super.setupHorizontalStackView()
        if let stack = hStack {
            stack.spacing = 8
            stack.distribution = .fill
            stack.alignment = .center
        }
    }

    func setupColorWell() {
        guard let stack = hStack else { return }
        let colorWell = UIColorWell()
        colorWell.translatesAutoresizingMaskIntoConstraints = false
        colorWell.addAction(UIAction(handler: { [unowned self] _ in
            if let well = self.colorWell, let param = self.parameter as? Float4Parameter, let color = well.selectedColor {
                var red: CGFloat = 0
                var green: CGFloat = 0
                var blue: CGFloat = 0
                var alpha: CGFloat = 0
                color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                param.value = simd_make_float4(Float(red), Float(green), Float(blue), Float(alpha))
            }
        }), for: .valueChanged)
        stack.addArrangedSubview(colorWell)
        self.colorWell = colorWell
    }

    override func setupBinding() {
        guard let param = parameter as? Float4Parameter else { return }
        param.$value.sink { [weak self] value in
            if let self = self, let colorWell = self.colorWell {
                colorWell.selectedColor = UIColor(red: CGFloat(value.x), green: CGFloat(value.y), blue: CGFloat(value.z), alpha: CGFloat(value.w))
            }
        }.store(in: &cancellables)

        if let colorWell = colorWell {
            let value = param.value
            colorWell.selectedColor = UIColor(red: CGFloat(value.x), green: CGFloat(value.y), blue: CGFloat(value.z), alpha: CGFloat(value.w))
        }

        super.setupBinding()
    }

    deinit {
        colorWell = nil
    }
}

#endif
