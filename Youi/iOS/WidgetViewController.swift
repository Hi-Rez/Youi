//
//  WidgetViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/3/21.
//

import Satin
import UIKit

class WidgetViewController: UIViewController {
    public weak var parameter: Parameter?
    
    var minHeight: CGFloat {
        48
    }
    
    var labelFont: UIFont {
        .systemFont(ofSize: 14)
    }
    
    var vStack: UIStackView?
    var hStack: UIStackView?
    var label: UILabel?

    override open func loadView() {
        setupView()
        setupStackViews()
        setupLabel()
        setupBinding()
    }
    
    func setupStackViews()
    {
        setupVerticalStackView()
        setupHorizontalStackView()
    }

    func setupView() {
        view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: minHeight).isActive = true
    }

    func setupVerticalStackView() {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .leading
        stack.distribution = .fill
        view.addSubview(stack)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -16).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        vStack = stack
    }

    func setupHorizontalStackView() {
        guard let vStack = self.vStack else { return }
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.distribution = .fillProportionally
        vStack.addArrangedSubview(stack)
        stack.centerXAnchor.constraint(equalTo: vStack.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: 0).isActive = true
        hStack = stack
    }

    func setupLabel() {
        guard let hStack = self.hStack else { return }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = labelFont
        label.text = "Label"
        hStack.addArrangedSubview(label)
        self.label = label
    }
    
    func setupBinding() {
        guard let label = self.label, let parameter = self.parameter else { return }
        label.text = "\(parameter.label)"
    }
    
    deinit {
        vStack = nil
        hStack = nil
        label = nil
    }
}
