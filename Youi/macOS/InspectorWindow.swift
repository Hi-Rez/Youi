//
//  InspectorWindow.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/20/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa

open class InspectorWindow: NSWindow {
    public var inspectorViewController: InspectorViewController?

    public init() {
        super.init(contentRect: NSMakeRect(500, 500, 240, 240), styleMask: [.closable, .miniaturizable, .resizable, .fullSizeContentView, .titled], backing: .buffered, defer: false)
        setup()
    }

    func setup() {
        titlebarAppearsTransparent = true
        title = "Inspector"
        setFrameAutosaveName("Inspector")
        backgroundColor = .clear
        isReleasedWhenClosed = false
        level = .statusBar
        setupInspector()
        contentView = inspectorViewController?.view
    }

    open func setupInspector() {
        inspectorViewController = InspectorViewController()
    }

    deinit {
        inspectorViewController = nil
    }
}
