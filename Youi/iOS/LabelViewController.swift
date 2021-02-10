//
//  LabelViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/3/21.
//

import Satin
import UIKit

class LabelViewController: WidgetViewController {
    var valueObservation: NSKeyValueObservation?
    var valueLabel: UILabel?
    
    var font: UIFont {
        .boldSystemFont(ofSize: 14)
    }
    
    override open func loadView() {
        setupView()
        setupStackViews()
        setupLabel()
        setupValueLabel()
        setupBinding()
    }
    
    override func setupHorizontalStackView() {
        guard let vStack = self.vStack else { return }
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.distribution = .fill
        vStack.addArrangedSubview(stack)
        stack.centerXAnchor.constraint(equalTo: vStack.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: 0).isActive = true
        hStack = stack
    }
    
    func setupValueLabel() {
        guard let hStack = self.hStack else { return }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.text = "Label"
        label.textAlignment = .right
        label.isUserInteractionEnabled = true
        hStack.addArrangedSubview(label)
        valueLabel = label
    }
    
    override func setupBinding() {
        guard let parameter = self.parameter as? StringParameter else { return }
        valueObservation = parameter.observe(\StringParameter.value, options: [.old, .new]) { [unowned self] _, _ in
            if let label = self.valueLabel {
                label.text = "\(parameter.value)"
            }
        }
            
        guard let label = self.label else { return }
        label.text = "\(parameter.label):"
    }
    
    deinit {
        valueObservation = nil
    }
}
