//
//  ViewController.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/14/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Foundation
import Satin

#if os(macOS)

import AppKit
import Cocoa

open class FlippedStackView: NSStackView {
    open override var isFlipped: Bool {
        return true
    }
}

open class InspectorViewController: NSViewController, PanelViewControllerDelegate, NSWindowDelegate {
    public var panels: [PanelViewController] = []
    public var controls: [ControlViewController] = []
    
    public var viewHeightConstraint: NSLayoutConstraint!
    
    public var spacer: NSView!
    public var scrollView: NSScrollView!
    public var stackView: FlippedStackView!
    
    open override func loadView() {
        setupView()
        setupSpacer()
        setupScrollView()
        setupStackView()
        setupDivider()
    }
    
    open func setupView() {
        let view = TranslucentView()
        
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 240).isActive = true
        viewHeightConstraint = view.heightAnchor.constraint(lessThanOrEqualToConstant: 240)
        viewHeightConstraint.isActive = true
        
        self.view = view
    }
    
    open func setupSpacer() {
        let spacer = NSView(frame: NSRect(x: 0, y: 0, width: 240, height: 28))
        
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.wantsLayer = true
        spacer.layer?.backgroundColor = .clear
        
        view.addSubview(spacer)
        
        spacer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        spacer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        spacer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        spacer.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        self.spacer = spacer
    }
    
    open func setupScrollView() {
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
        
        scrollView.topAnchor.constraint(equalTo: spacer.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.scrollView = scrollView
    }
    
    open func setupStackView() {
        let stackView = FlippedStackView()
        
        stackView.wantsLayer = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.documentView = stackView
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.orientation = .vertical
        stackView.contentHuggingPriority(for: .horizontal)
        stackView.distribution = .gravityAreas
        stackView.spacing = 0
        
        self.stackView = stackView
    }
    
    open func setupDivider() {
        let divider = Spacer()
        stackView.addArrangedSubview(divider)
        var dpr = CGFloat(1.0)
        if let window = view.window {
            dpr = CGFloat(window.backingScaleFactor)
        }
        divider.heightAnchor.constraint(equalToConstant: 1.0 / dpr).isActive = true
        divider.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
    
    open override func viewDidLoad() {
        for control in controls {
            addControl(control)
        }
        
        for panel in panels {
            addPanel(panel)
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
        resize()        
        DispatchQueue.main.async { [unowned self] in
            if let window = self.view.window {
                window.makeFirstResponder(nil)
            }
        }
    }
    
    open func resize() {
        let height = stackView.frame.height + spacer.frame.height
        if let window = view.window {
            let windowFrame = window.frame
            let totalHeight = height
            let originYOffset = windowFrame.height - totalHeight
            if windowFrame.size.height != totalHeight {
                DispatchQueue.main.async { [unowned self] in
                    if let window = self.view.window {
                        window.setFrame(NSRect(x: windowFrame.origin.x, y: windowFrame.origin.y + originYOffset, width: windowFrame.size.width, height: totalHeight), display: true, animate: false)
                    }
                }
            }
        }
        
        if viewHeightConstraint.constant != height {
            viewHeightConstraint.constant = height
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
    
    open func onPanelResized(panel: PanelViewController) {
        resize()
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
    
    open func addControl(_ control: ControlViewController) {
        controls.append(control)
        if isViewLoaded {
            stackView.addArrangedSubview(control.view)
            control.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
            control.view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
            resize()
        }
    }
    
    open func addPanel(_ panel: PanelViewController) {
        panel.delegate = self
        panels.append(panel)
        if isViewLoaded {
            stackView.addArrangedSubview(panel.view)
            panel.view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
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

#elseif os(iOS)

import UIKit

open class InspectorViewController: UIViewController {
    var header: InspectorHeaderViewController?
    var controls: [ControlViewController] = []
    var stack: UIStackView?
    var scrollView: UIScrollView?

    override open var title: String? {
        didSet {
            header?.title = title
        }
    }
    
    public convenience init(_ title: String) {
        self.init()
        self.title = title
    }
    
    override open func loadView() {
        setupView()
        setupBlurView()
        setupScrollView()
        setupStackView()
        setupHeader()
        setupControls()
    }

    func setupView() {
        view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 240).isActive = true
    }
    
    func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(blurView, at: 0)
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func setupScrollView() {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.showsVerticalScrollIndicator = false
        self.scrollView = scrollView
    }

    func setupStackView() {
        guard let scrollView = self.scrollView else { return }
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .leading

        scrollView.addSubview(stack)
      
        stack.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollView.contentLayoutGuide.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
        scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: stack.topAnchor).isActive = true
        scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: stack.heightAnchor).isActive = true
        
        self.stack = stack
    }
    
    func setupHeader() {
        guard let stack = self.stack, let title = self.title else { return }
        let header = InspectorHeaderViewController(title)
        stack.addArrangedSubview(header.view)
        header.view.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        header.view.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        self.header = header
    }

    func setupControls() {
        for control in controls {
            if let stack = self.stack {
                stack.addArrangedSubview(control.view)
                control.view.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
                control.view.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
            }
        }
    }

    open func addPanel(_ panel: PanelViewController) {
        controls.append(panel)
        if isViewLoaded, let stack = self.stack {
            stack.addArrangedSubview(panel.view)
            panel.view.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
            panel.view.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        }
    }
    
    open func getPanels() -> [PanelViewController] {
        var panels: [PanelViewController] = []
        for control in controls {
            if let panel = control as? PanelViewController {
                panels.append(panel)
            }
        }
        return panels
    }
    
    open func removeAllPanels() {
        for control in controls {
            if let panel = control as? PanelViewController {
                panel.view.removeFromSuperview()
            }
        }
        controls = []
    }
}

#endif
