//
//  InspectorWindow.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/5/21.
//

import UIKit

open class InspectorWindow: UIViewController {
    public enum Edge {
        case left
        case right
    }
    
    var edge: Edge = .left
    public var inspectorViewController: InspectorViewController?
        
    var topAnchorConstraint: NSLayoutConstraint?
    var bottomAnchorConstraint: NSLayoutConstraint?
    var widthAnchorConstraint: NSLayoutConstraint?
    
    var button: HandleButton?
    var buttonAnchorConstraint: NSLayoutConstraint?
    
    var width: CGFloat = 288 {
        didSet {
            widthAnchorConstraint?.constant = CGFloat(width)
        }
    }
    
    var viewPanGestureRecognizer: UIPanGestureRecognizer?
    var buttonPanGestureRecognizer: UIPanGestureRecognizer?
    
    var open: Bool = false {
        didSet {
            updatePosition()
        }
    }
    
    override open var title: String? {
        didSet {
            inspectorViewController?.title = title
        }
    }
    
    public convenience init(_ title: String, edge: Edge = .left) {
        self.init()
        self.title = title
        self.edge = edge
        inspectorViewController = InspectorViewController(title)
    }
    
    open override func viewDidLoad() {
        setupView()
    }
    
    func setupView() {
        view = UIView(frame: CGRect(x: -width - 12.0, y: 16.0, width: width, height: UIScreen.main.bounds.height - 32.0))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 0.25
        view.layer.borderColor = UIColor(named: "Border", in: Bundle(for: InspectorWindow.self), compatibleWith: nil)?.cgColor
        view.clipsToBounds = true
        
        let widthAnchorConstraint = view.widthAnchor.constraint(equalToConstant: CGFloat(width))
        widthAnchorConstraint.isActive = true
        self.widthAnchorConstraint = widthAnchorConstraint
        
        if let inspectorViewController = self.inspectorViewController {
            view.addSubview(inspectorViewController.view)
            inspectorViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            inspectorViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        }
    }
    
    func updatePosition(_ animated: Bool = true) {
        guard let topAnchorConstraint = self.topAnchorConstraint,
              let bottomAnchorConstraint = self.bottomAnchorConstraint,
              let buttonAnchorConstraint = self.buttonAnchorConstraint,
              let superView = view.superview else { return }
        
        if superView.safeAreaInsets.top == 0 {
            topAnchorConstraint.constant = 16
        }
        else {
            topAnchorConstraint.constant = 0
        }
        
        if superView.safeAreaInsets.bottom == 0 {
            bottomAnchorConstraint.constant = -16
        }
        else {
            bottomAnchorConstraint.constant = 0
        }
        
        if open {
            if edge == .left {
                buttonAnchorConstraint.constant = 24 + width + superView.safeAreaInsets.left
            }
            else {
                buttonAnchorConstraint.constant = -24 - width - superView.safeAreaInsets.right
            }
            
            if animated {
                UIView.animate(withDuration: 0.2) {
//                    superView.layoutIfNeeded()
                }
            }
            else {
//                superView.layoutIfNeeded()
            }
        }
        else {
            if edge == .left {
                buttonAnchorConstraint.constant = 6
            }
            else {
                buttonAnchorConstraint.constant = -6
            }
            
            if animated {
                UIView.animate(withDuration: 0.2) {
//                    superView.layoutIfNeeded()
                }
            }
            else {
//                superView.layoutIfNeeded()
            }
        }
    }
    
    func setupGestures() {
        
        
            let viewPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewPanGesture))
            view.addGestureRecognizer(viewPanGestureRecognizer)
            self.viewPanGestureRecognizer = viewPanGestureRecognizer
        
        
        if let button = self.button {
            let buttonPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(buttonPanGesture))
            button.addGestureRecognizer(buttonPanGestureRecognizer)
            self.buttonPanGestureRecognizer = buttonPanGestureRecognizer
        }
    }
    
    @objc func viewPanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let button = self.button,
              let buttonAnchorConstraint = self.buttonAnchorConstraint,
              let superView = view.superview else { return }
        let state = recognizer.state
        if state == .changed {
            let delta = recognizer.translation(in: view)
            buttonAnchorConstraint.constant += delta.x
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
        }
        else if state == .ended {
            open = (edge == .left ? (button.frame.origin.x > view.frame.width * 0.5) : (button.frame.origin.x < (superView.frame.width - view.frame.width * 0.5)))
            updatePosition()
        }
    }
    
    @objc func buttonPanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let button = self.button,
              let buttonAnchorConstraint = self.buttonAnchorConstraint,
              let superView = view.superview else { return }
        let state = recognizer.state
        if state == .changed {
            let delta = recognizer.translation(in: view)
            buttonAnchorConstraint.constant += delta.x
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
        }
        else if state == .ended {
            open = (edge == .left ? (button.frame.origin.x > view.frame.width * 0.5) : (button.frame.origin.x < (superView.frame.width - view.frame.width * 0.5)))
            updatePosition()
        }
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let superView = view.superview {
            if topAnchorConstraint == nil {
                let topAnchorConstraint = view.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor)
                topAnchorConstraint.isActive = true
                self.topAnchorConstraint = topAnchorConstraint
            }

            if bottomAnchorConstraint == nil {
                let bottomAnchorConstraint = view.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor)
                bottomAnchorConstraint.isActive = true
                self.bottomAnchorConstraint = bottomAnchorConstraint
            }
            
            if button == nil {
                let button = HandleButton(frame: CGRect(x: -12, y: UIScreen.main.bounds.height * 0.5 - 96 * 0.5, width: 6, height: 96))
                superView.addSubview(button)
                button.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
                
                let buttonAnchorConstraint = (edge == .left ? button.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 6) :
                    button.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -6))
                
                buttonAnchorConstraint.isActive = true
                self.buttonAnchorConstraint = buttonAnchorConstraint
                
                button.addAction(UIAction(handler: { [unowned self] _ in
                    self.open = !self.open
                }), for: .touchUpInside)
                
                if edge == .left {
                    view.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -12).isActive = true
                }
                else {
                    view.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 12).isActive = true
                }
                
                self.button = button
                
                setupGestures()
                updatePosition(false)
            }
        }
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        view.layer.borderColor = UIColor(named: "Border", in: Bundle(for: InspectorWindow.self), compatibleWith: nil)?.cgColor
    }
    
    deinit {
        viewPanGestureRecognizer = nil
        buttonPanGestureRecognizer = nil
        
        inspectorViewController = nil
        
        topAnchorConstraint = nil
        bottomAnchorConstraint = nil
        widthAnchorConstraint = nil
        
        button = nil
        buttonAnchorConstraint = nil
    }
}
