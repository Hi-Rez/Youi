//
//  PanelHeaderViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/2/21.
//

#if os(iOS)

import UIKit

protocol PanelHeaderViewControllerDelegate: AnyObject {
    func onOpen(header: PanelHeaderViewController)
    func onClose(header: PanelHeaderViewController)
}

class PanelHeaderViewController: UIViewController {
    public weak var delegate: PanelHeaderViewControllerDelegate?
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    public var state: Bool = false {
        didSet {
            button?.value = state
            if oldValue != state {
                if state {
                    delegate?.onOpen(header: self)
                }
                else {
                    delegate?.onClose(header: self)
                }
            }
        }
    }
    
    public var vStack: UIStackView?
    public var hStack: UIStackView?
    public var button: DisclosureButton?
    public var label: UILabel?
    public var spacer: Spacer?
    
    override open var title: String? {
        didSet {
            if let title = self.title {
                label?.text = title
            }
        }
    }
    
    public convenience init(_ title: String, _ state: Bool) {
        self.init()
        self.title = title
        self.state = state
    }
        
    override func loadView() {
        setupView()
        setupVerticalStackView()
        setupHorizontalStackView()
        setupButton()
        setupLabel()
        setupSpacer()
        setupGestures()
    }
    
    func setupView() {
        view = UIView()
        view.backgroundColor = UIColor(named: "PanelHeader", in: getBundle(), compatibleWith: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
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
        stack.spacing = 4
        stack.alignment = .center
        stack.distribution = .fillProportionally
        vStack.addArrangedSubview(stack)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        hStack = stack
    }
    
    func setupButton() {
        guard let hStack = self.hStack else { return }
        let button = DisclosureButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        hStack.addArrangedSubview(button)
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.addAction(UIAction(handler: { [unowned self] _ in
            self.state.toggle()
            if state {
                delegate?.onOpen(header: self)
            }
            else {
                delegate?.onClose(header: self)
            }
        }), for: .touchUpInside)
        button.value = state
        self.button = button
    }
    
    func setupLabel() {
        guard let hStack = self.hStack else { return }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
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
    
    func setupGestures()
    {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        view.addGestureRecognizer(tapGestureRecognizer)
        self.tapGestureRecognizer = tapGestureRecognizer
    }
    
    @objc func tapGesture(_ recognizer: UITapGestureRecognizer) {
        self.state.toggle()
    }
    
    deinit {
        spacer = nil
        button = nil
        hStack = nil
        vStack = nil
        label = nil
    }
}

#endif
