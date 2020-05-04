//
//  InputViewController.swift
//  Youi-macOS
//
//  Created by Reza Ali on 5/4/20.
//

import Foundation

open class InputViewController: NSViewController {
    open override func viewWillDisappear() {
        deactivate()
    }

    open func deactivate() {
        if let window = self.view.window {
            window.makeFirstResponder(nil)
        }
    }

    open func deactivateAsync() {
        if let window = self.view.window {
            DispatchQueue.main.async { // omg
                window.makeFirstResponder(nil)
            }
        }
    }
}
