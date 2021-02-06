//
//  DisclosureButton.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/2/21.
//

import Foundation


import UIKit

class DisclosureButton: UIButton {
    var value: Bool = true {
        didSet {
            updateState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init() {
        super.init(frame: CGRect())
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup()
    {
        addAction(UIAction(handler: { [unowned self]  _ in 
            value = !value
            updateState()
        }), for: .touchUpInside)
        updateState()
        tintColor = UIColor(named: "Disclosure", in: Bundle(for: DisclosureButton.self), compatibleWith: nil)
    }

    func updateState()
    {
        if value {
            layer.transform = CATransform3DMakeRotation(.pi * 0.5, 0, 0, 1)
        }
        else {
            layer.transform = CATransform3DMakeRotation(0.0, 0, 0, 1)
        }
    }
}
