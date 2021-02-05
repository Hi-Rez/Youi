//
//  InspectorViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/4/21.
//

import UIKit

open class InspectorViewController: UIViewController {
    var header: InspectorHeaderViewController?
    var controls: [ControlViewController] = []
    var stack: UIStackView?
    var scrollView: UIScrollView?

    override open var title: String? {
        didSet {
            header?.title = title
        }
    }
    
    public convenience init(_ title: String) {
        self.init()
        self.title = title
    }
    
    open override func loadView() {
        setupView()
        setupBlurView()
        setupScrollView()
        setupStackView()
        setupHeader()
        setupControls()
    }

    func setupView() {
        view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 240).isActive = true
    }
    
    func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(blurView, at: 0)
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        blurView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func setupScrollView() {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.showsVerticalScrollIndicator = false
        self.scrollView = scrollView
    }

    func setupStackView() {
        guard let scrollView = self.scrollView else { return }
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .leading

        scrollView.addSubview(stack)
      
        stack.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollView.contentLayoutGuide.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
        scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: stack.topAnchor).isActive = true
        scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        scrollView.contentLayoutGuide.heightAnchor.constraint(equalTo: stack.heightAnchor).isActive = true
        
        self.stack = stack
    }
    
    func setupHeader() {
        guard let stack = self.stack, let title = self.title else { return }
        let header = InspectorHeaderViewController(title)
        stack.addArrangedSubview(header.view)
        header.view.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        header.view.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        self.header = header
    }

    func setupControls() {
        for control in controls {
            if let stack = self.stack {
                stack.addArrangedSubview(control.view)
                control.view.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
                control.view.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
            }
        }
    }

    open func addPanel(_ panel: PanelViewController) {
        controls.append(panel)
        if isViewLoaded, let stack = self.stack {
            stack.addArrangedSubview(panel.view)
            panel.view.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
            panel.view.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        }
    }
    
    open func getPanels() -> [PanelViewController] {
        var panels: [PanelViewController] = []
        for control in controls {
            if let panel = control as? PanelViewController {
                panels.append(panel)
            }
        }
        return panels
    }
    
    open func removeAllPanels()
    {
        for (index, control) in controls.enumerated() {
            if let panel = control as? PanelViewController {
                controls.remove(at: index)
                panel.removeFromParent()
            }
        }
    }
}
