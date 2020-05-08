//
//  ViewController.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/14/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import AppKit
import Cocoa
import Satin

open class InspectorViewController: NSViewController, PanelViewControllerDelegate, NSWindowDelegate {
    public var panels: [PanelViewController] = []
    public var controls: [ControlViewController] = []
    public var vStack: NSStackView!
    public var viewHeightConstraint: NSLayoutConstraint!
    
    open override func loadView() {
        let view = TranslucentView()
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 240).isActive = true
        viewHeightConstraint = view.heightAnchor.constraint(equalToConstant: 240)
        viewHeightConstraint.isActive = true
        
        self.view = view
    }
    
    open override func viewDidLoad() {
        let scrollView = NSScrollView()
        scrollView.wantsLayer = true
        scrollView.backgroundColor = .clear
        scrollView.drawsBackground = false
        
        scrollView.contentView.wantsLayer = true
        scrollView.contentView.backgroundColor = .clear
        
        scrollView.documentView?.wantsLayer = true
        scrollView.documentView?.layer?.backgroundColor = .clear
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        vStack = NSStackView()
        vStack.wantsLayer = true
        vStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView = vStack
        vStack.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        vStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        vStack.orientation = .vertical
        vStack.distribution = .gravityAreas
        vStack.spacing = 0
        
        let spacer = NSView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.wantsLayer = true
        spacer.layer?.backgroundColor = .clear
        vStack.addArrangedSubview(spacer)
        spacer.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
        spacer.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        let divider = Spacer()
        vStack.addArrangedSubview(divider)
        var dpr = CGFloat(1.0)
        if let window = view.window {
            dpr = CGFloat(window.backingScaleFactor)
        }
        divider.heightAnchor.constraint(equalToConstant: 1.0 / dpr).isActive = true
        divider.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
        
        for control in controls {
            vStack.addView(control.view, in: .top)
            control.view.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
        }
        
        for panel in panels {
            vStack.addView(panel.view, in: .top)
            panel.view.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
        }
        
        view.window?.delegate = self
    }
    
    public func windowDidResignKey(_ notification: Notification) {
        if let window = self.view.window {
            window.makeFirstResponder(nil)
        }
    }
    
    open override func viewWillAppear() {
        super.viewWillAppear()
        DispatchQueue.main.async { [unowned self] in
            if let window = self.view.window {
                window.makeFirstResponder(nil)
                self.resize()
            }
        }
    }
    
    open override func viewDidAppear() {
        super.viewDidAppear()
        DispatchQueue.main.async { [unowned self] in
            if let window = self.view.window {
                window.makeFirstResponder(nil)
            }
        }
    }
    
    open override func viewWillDisappear() {
        super.viewWillDisappear()
        if let window = self.view.window {
            window.makeFirstResponder(nil)
        }
    }
    
    open func onPanelOpen(panel: PanelViewController) {
        resize()
    }
    
    open func onPanelClose(panel: PanelViewController) {
        resize()
    }
    
    open func onPanelRemove(panel: PanelViewController) {
        removePanel(panel)
    }
    
    open func removePanel(_ panel: PanelViewController) {
        for (index, item) in panels.enumerated() {
            if item == panel {
                item.view.removeFromSuperview()
                panels.remove(at: index)
                resize()
                break
            }
        }
    }
    
    open func removeControl(_ control: ControlViewController) {
        for (index, item) in controls.enumerated() {
            if item == control {
                control.view.removeFromSuperview()
                controls.remove(at: index)
                resize()
                break
            }
        }
    }
    
    open func onPanelResized(panel: PanelViewController) {
        viewHeightConstraint.constant = vStack.frame.height
    }
    
    open func addControl(_ control: ControlViewController) {
        controls.append(control)
        if isViewLoaded {
            vStack.addArrangedSubview(control.view)
            control.view.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
            resize()
        }
    }
    
    open func addPanel(_ panel: PanelViewController) {
        panel.delegate = self
        panels.append(panel)
        if isViewLoaded {
            vStack.addArrangedSubview(panel.view)
            panel.view.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
            resize()
        }
    }
    
    open func removeAllPanels() {
        for panel in panels {
            panel.delegate = nil
            panel.view.removeFromSuperview()
        }
        panels = []
    }
    
    open func removeAllControls() {
        for control in controls {
            control.view.removeFromSuperview()
        }
        controls = []
    }
    
    open func removePanel(_ parameterGroup: ParameterGroup) {
        for (index, panel) in panels.enumerated() {
            if let panelParams = panel.parameters {
                if panelParams == parameterGroup {
                    panel.view.removeFromSuperview()
                    panels.remove(at: index)
                    resize()
                    break
                }
            }
        }
    }
    
    open func removeControl(_ parameterGroup: ParameterGroup) {
        for (index, control) in controls.enumerated() {
            if let panelParams = control.parameters {
                if panelParams == parameterGroup {
                    control.view.removeFromSuperview()
                    controls.remove(at: index)
                    resize()
                    break
                }
            }
        }
    }
    
    open func resize() {
        if let window = view.window, let contentView = window.contentView {
            vStack.layoutSubtreeIfNeeded()
            let windowFrame = window.frame
            let contentHeight = contentView.frame.height
            let titleHeight = windowFrame.height - contentHeight
            let calculatedHeight = vStack.frame.height + titleHeight
            viewHeightConstraint.constant = vStack.frame.height
            let originYOffset = windowFrame.height - calculatedHeight
            window.setFrame(NSRect(x: windowFrame.origin.x, y: windowFrame.origin.y + originYOffset, width: windowFrame.size.width, height: calculatedHeight), display: true)
        }
    }
    
    open func getPanels() -> [PanelViewController] {
        return panels
    }
    
    open func getControls() -> [ControlViewController] {
        return controls
    }
    
    deinit {
        removeAllPanels()
        removeAllControls()
    }
}
