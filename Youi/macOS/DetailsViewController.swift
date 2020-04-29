//
//  DetailsViewController.swift
//  Slate macOS
//
//  Created by Reza Ali on 3/27/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa
import Satin

open class DetailsViewController: ControlViewController, NSTextFieldDelegate {
    public var details: [StringParameter] = []
    var observations: [NSKeyValueObservation] = []

    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false

        let vStack = NSStackView()
        vStack.wantsLayer = true
        vStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vStack)
        vStack.orientation = .vertical
        vStack.distribution = .gravityAreas
        vStack.spacing = 6

        vStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true

        vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        vStack.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        for detail in details {
            let hStack = NSStackView()
            hStack.wantsLayer = true
            hStack.translatesAutoresizingMaskIntoConstraints = false
            vStack.addView(hStack, in: .center)
            hStack.orientation = .horizontal
            hStack.alignment = .centerY
            hStack.distribution = .gravityAreas
            hStack.spacing = 0

            hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -16).isActive = true

            let labelField = NSTextField()
            labelField.font = .labelFont(ofSize: 12)
            labelField.wantsLayer = true
            labelField.isEditable = false
            labelField.isBordered = false
            labelField.maximumNumberOfLines = 100
            labelField.backgroundColor = .clear
            labelField.stringValue = detail.label + ":"
            hStack.addView(labelField, in: .leading)

            let labelValue = NSTextField()
            labelValue.font = .boldSystemFont(ofSize: 12)
            labelValue.wantsLayer = true
            labelValue.isEditable = false
            labelValue.isBordered = false
            labelValue.maximumNumberOfLines = 100
            labelValue.backgroundColor = .clear
            labelValue.stringValue = detail.value
            hStack.addView(labelValue, in: .leading)

            observations.append(detail.observe(\StringParameter.value, options: .new) { [labelValue] _, change in
                if let value = change.newValue {
                    labelValue.stringValue = value
                }
            })
        }
    }

    deinit {
        details = []
        observations = []
    }
}
