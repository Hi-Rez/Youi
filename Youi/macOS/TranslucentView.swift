//
//  TranslucentView.swift
//  Progress
//
//  Created by Reza Ali on 3/21/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa

open class TranslucentView: NSVisualEffectView {
    public init() {
        super.init(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        updateStyle()
        state = .active
        blendingMode = .behindWindow
        autoresizingMask = [.width, .height]

        DistributedNotificationCenter.default.addObserver(
            self,
            selector: #selector(interfaceModeChanged),
            name: Notification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil
        )
    }

    func updateStyle() {
        if let _ = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") {
//            material = .dark
            material = .appearanceBased
        }
        else {
            material = .appearanceBased
//            material = .light
        }
    }

    open override func updateLayer() {
        super.updateLayer()
        updateStyle()
    }

    @objc func interfaceModeChanged() {
        updateStyle()
    }
    
    deinit {
        print("Removing TranslucentView")
    }
}
