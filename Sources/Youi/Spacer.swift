//
//  Spacer.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/20/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

#if os(macOS)
import Cocoa

open class Spacer: NSView {
    public init() {
        super.init(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
        self.setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    func setup() {
        wantsLayer = true
    }

    open override func updateLayer() {
        super.updateLayer()
        layer?.backgroundColor = NSColor(named: "Spacer", bundle: getBundle())?.cgColor
    }
}

#elseif os(iOS)

import UIKit

open class Spacer: UIView {
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = UIColor(named: "Spacer", in: getBundle(), compatibleWith: nil)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor(named: "Spacer", in: getBundle(), compatibleWith: nil)
    }
}

#endif
