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

    public init(_ title: String = "") {
        super.init(contentRect: NSMakeRect(500, 500, 240, 240), styleMask: [.closable, .miniaturizable, .resizable, .fullSizeContentView, .titled], backing: .buffered, defer: false)
        setup(title)
    }

    open func setup(_ title: String) {
        titlebarAppearsTransparent = true
        self.title = title.isEmpty ? "Inspector" : title
        setFrameAutosaveName(self.title)
        backgroundColor = .clear
        isReleasedWhenClosed = false
        level = .statusBar
        hidesOnDeactivate = true
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
