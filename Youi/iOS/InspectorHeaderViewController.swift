//
//  InspectorHeaderViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/4/21.
//

import UIKit

class InspectorHeaderViewController: UIViewController {
    public var vStack: UIStackView?
    public var hStack: UIStackView?
    public var label: UILabel?
    public var spacer: Spacer?
    
    override open var title: String? {
        didSet {
            if let title = self.title {
                label?.text = title
            }
        }
    }
    
    public convenience init(_ title: String) {
        self.init()
        self.title = title
    }
        
    override func loadView() {
        setupView()
        setupVerticalStackView()
        setupHorizontalStackView()
        setupLabel()
        setupSpacer()
    }
    
    func setupView() {
        view = UIView()
        view.backgroundColor = UIColor(named: "InspectorHeader", in: Bundle(for: InspectorHeaderViewController.self), compatibleWith: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    func setupVerticalStackView() {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .center
        stack.distribution = .fillProportionally
        view.addSubview(stack)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        vStack = stack
    }
    
    func setupHorizontalStackView() {
        guard let vStack = self.vStack else { return }
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .center
        stack.distribution = .fillProportionally
        vStack.addArrangedSubview(stack)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        hStack = stack
    }
    
    func setupLabel() {
        guard let hStack = self.hStack else { return }
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.text = title
        hStack.addArrangedSubview(label)
        self.label = label
    }
    
    func setupSpacer()
    {
        guard let vStack = self.vStack else { return }
        let spacer = Spacer()
        vStack.addArrangedSubview(spacer)
        spacer.heightAnchor.constraint(equalToConstant: 1).isActive = true
        spacer.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
        self.spacer = spacer
    }
    
    deinit {
        spacer = nil
        hStack = nil
        vStack = nil
        label = nil
    }
}
