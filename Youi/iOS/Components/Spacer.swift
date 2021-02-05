//
//  Spacer.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/2/21.
//

import UIKit

open class Spacer: UIView {
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = UIColor(named: "Spacer")
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor(named: "Spacer")
    }
}
