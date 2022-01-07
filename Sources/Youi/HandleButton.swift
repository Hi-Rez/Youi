//
//  Button.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/2/21.
//

#if os(iOS)

import UIKit

class HandleButton: UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newArea = CGRect(
            x: self.bounds.origin.x - 20.0,
            y: self.bounds.origin.y - 20.0,
            width: self.bounds.size.width + 40.0,
            height: self.bounds.size.height + 40.0
        )
        return newArea.contains(point)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 3.0
        self.backgroundColor = UIColor(named: "Button", in: getBundle(), compatibleWith: nil)
        self.widthAnchor.constraint(equalToConstant: 6).isActive = true
        self.heightAnchor.constraint(equalToConstant: 96).isActive = true   
    }
}

#endif
