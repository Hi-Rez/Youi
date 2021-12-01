//
//  ColorPaletteViewController.swift
//  Youi-macOS
//
//  Created by Reza Ali on 11/30/21.
//

import Cocoa
import Satin
import simd

open class ColorPaletteViewController: NSViewController, NSWindowDelegate {
    public var parameters: [Float4Parameter] = []
    var parametersMap: [Float4Parameter: NSButton] = [:]
    var activeIndex: Int = -1
    let hStack = NSStackView()
    
    override open func viewWillAppear() {
        super.viewWillAppear()
        for (index, parameter) in parameters.enumerated() {
            guard parametersMap[parameter] == nil else { continue }
            let value = parameter.value
            
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
            parametersMap[parameter] = button

            parameter.actions.append { value in
                DispatchQueue.main.async {
                    button.layer?.backgroundColor = NSColor(deviceRed: CGFloat(value.x), green: CGFloat(value.y), blue: CGFloat(value.z), alpha: CGFloat(value.w)).cgColor
                }
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
        parameters[activeIndex].value = simd_make_float4(Float(red), Float(green), Float(blue), Float(alpha))
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
