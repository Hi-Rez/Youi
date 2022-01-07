//
//  TranslucentView.swift
//  Progress
//
//  Created by Reza Ali on 3/21/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

#if os(macOS)

import AppKit

open class TranslucentView: NSVisualEffectView {
    public init() {
        super.init(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        material = .popover
        state = .active
        blendingMode = .behindWindow
        autoresizingMask = [.width, .height]
    }
}

#endif 
