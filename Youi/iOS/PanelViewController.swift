//
//  PanelViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/2/21.
//

import UIKit
import Satin

open class PanelViewController: ControlViewController, PanelHeaderViewControllerDelegate {
    var header: PanelHeaderViewController?
    var vStack: UIStackView?
    var hStack: UIStackView?
    
    override open var title: String? {
        didSet {
            header?.title = title
        }
    }
    
    open var open: Bool = false {
        didSet {
            updateState()
        }
    }
    
    public convenience init(_ title: String, parameters: ParameterGroup) {
        self.init(parameters)
        self.title = title
    }
        
    open override func loadView() {
        setupView()
        setupVerticalStackView()
        setupHeader()
        setupStackView()
        setupParameters()
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
    
    func setupHeader()
    {
        guard let title = self.title, let vStack = self.vStack else { return }
        let header = PanelHeaderViewController(title, open)
        header.delegate = self
        vStack.addArrangedSubview(header.view)
        header.view.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true
        self.header = header
    }
    
    override func setupStackView() {
        guard let vStack = self.vStack else { return }
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .center
        stack.isHidden = !open
        vStack.addArrangedSubview(stack)
        stack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: 0).isActive = true
        self.controlsStack = stack
    }
    
    func onOpen(header: PanelHeaderViewController) {
        open = true
    }
    
    func onClose(header: PanelHeaderViewController) {
        open = false
    }
    
    func updateState()
    {
        guard let stack = self.controlsStack else { return }
        stack.isHidden = !open
    }

    func isOpen() -> Bool {
        return open
    }
    
    func setState(_ open: Bool) {
        self.open = open
    }
    
    deinit {
        header = nil
        vStack = nil
    }
}
