//
//  ToggleViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/3/21.
//

import UIKit
import Satin

class ToggleViewController: WidgetViewController {
    var valueObservation: NSKeyValueObservation?
    var toggle: UISwitch?

    open override func loadView() {
        setupView()
        setupStackViews()
        setupSwitch()
        setupLabel()
        setupBinding()
    }
    
    override func setupHorizontalStackView() {
        super.setupHorizontalStackView()
        if let stack = hStack {
            stack.spacing = 8
            stack.distribution = .fill
        }
    }
    
    func setupSwitch() {
        guard let stack = self.hStack else { return }
        let toggle = UISwitch()
        toggle.addAction(UIAction(handler: { [unowned self] _ in
            if let parameter = self.parameter as? BoolParameter {
                parameter.value = toggle.isOn
            }
        }), for: .primaryActionTriggered)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(toggle)
        self.toggle = toggle
    }

    override func setupBinding()
    {
        if let parameter = self.parameter as? BoolParameter {
            valueObservation = parameter.observe(\BoolParameter.value, options: [.old, .new]) { [unowned self] _, change in
                if let value = change.newValue, let toggle = self.toggle {
                    toggle.isOn = value
                }
            }
        }
        super.setupBinding()
    }
    
    deinit {
        valueObservation = nil
        toggle = nil
    }
}
