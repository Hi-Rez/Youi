//
//  ColorPaletteViewController.swift
//  Youi-macOS
//
//  Created by Reza Ali on 11/30/21.
//

import Combine
import simd

import Satin

#if os(macOS)

import Cocoa

open class ColorPaletteViewController: NSViewController, NSWindowDelegate {
    public var parameters: [Parameter] = []
    var parametersMap: [Int: NSButton] = [:]
    var cancellables = Set<AnyCancellable>()
    var activeIndex: Int = -1
    let hStack = NSStackView()
    
    override open func viewWillAppear() {
        super.viewWillAppear()
        for (index, parameter) in parameters.enumerated() {
            guard parametersMap[index] == nil else { continue }
            var value: simd_float4 = .one
            
            if let param = parameter as? Float4Parameter {
                value = param.value
            }
            else if let param = parameter as? Float3Parameter {
                value = simd_make_float4(param.value, 1.0)
            }
            
            let button = NSButton()
            button.isBordered = false
            button.bezelStyle = .smallSquare
            
            button.title = ""
            button.tag = index
            button.wantsLayer = true
            button.layer?.backgroundColor = NSColor(deviceRed: CGFloat(value.x), green: CGFloat(value.y), blue: CGFloat(value.z), alpha: CGFloat(value.w)).cgColor
            
            button.target = self
            button.action = #selector(ColorPaletteViewController.onColorPicked)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true

            hStack.addView(button, in: .leading)
            parametersMap[index] = button

            if let param = parameter as? Float4Parameter {
                param.$value.sink { [weak self] newValue in
                    if let _ = self {
                        button.layer?.backgroundColor = NSColor(deviceRed: CGFloat(newValue.x), green: CGFloat(newValue.y), blue: CGFloat(newValue.z), alpha: CGFloat(newValue.w)).cgColor
                    }
                }.store(in: &cancellables)
            }
            else if let param = parameter as? Float3Parameter {
                param.$value.sink { [weak self] newValue in
                    if let _ = self {
                        button.layer?.backgroundColor = NSColor(deviceRed: CGFloat(newValue.x), green: CGFloat(newValue.y), blue: CGFloat(newValue.z), alpha: 1.0).cgColor
                    }
                }.store(in: &cancellables)
            }
        }
    }
    
    override open func loadView() {
        NSColorPanel.shared.showsAlpha = true

        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true

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

        hStack.wantsLayer = true
        hStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.addView(hStack, in: .center)
        hStack.orientation = .horizontal
        hStack.alignment = .centerY
        hStack.distribution = .fillEqually
        hStack.spacing = 0

        hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -12).isActive = true
    }
    
    @objc func onColorPicked(_ sender: NSButton) {
        activeIndex = sender.tag
        
        let cp = NSColorPanel.shared
        let param = parameters[activeIndex]
        var value: simd_float4 = .one
        
        if let param = param as? Float4Parameter {
            value = param.value
        }
        else if let param = param as? Float3Parameter {
            value = simd_make_float4(param.value, 1.0)
        }
                
        cp.color = NSColor(deviceRed: CGFloat(value.x), green: CGFloat(value.y), blue: CGFloat(value.z), alpha: CGFloat(value.w))
        cp.setTarget(self)
        cp.setAction(#selector(ColorPaletteViewController.colorDidChange))
        cp.makeKeyAndOrderFront(self)
        cp.isContinuous = true
        cp.delegate = self
    }
    
    @objc func colorDidChange(_ sender: NSColorPanel) {
        guard activeIndex > -1, let color = sender.color.usingColorSpace(.deviceRGB) else { return }
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        if let param = parameters[activeIndex] as? Float4Parameter {
            param.value = simd_make_float4(Float(red), Float(green), Float(blue), Float(alpha))
        }
        else if let param = parameters[activeIndex] as? Float3Parameter {
            param.value = simd_make_float3(Float(red), Float(green), Float(blue))
        }
    }

    public func windowDidResignKey(_ notification: Notification) {
        let cp = NSColorPanel.shared
        cp.delegate = nil
        activeIndex = -1
    }
    
    deinit {
        parameters = []
        parametersMap = [:]
    }
}

#elseif os(iOS)

#endif
