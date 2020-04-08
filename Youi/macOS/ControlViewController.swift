//
//  ControlViewController.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/14/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa

open class ControlViewController: NSViewController {
    open override func viewWillDisappear() {
        deactivate()
    }

    open override func mouseDown(with event: NSEvent) {
        deactivate()
    }

    open override func mouseExited(with event: NSEvent) {
        deactivate()
    }

    open func deactivate() {
        view.window?.makeFirstResponder(nil)
    }
}
