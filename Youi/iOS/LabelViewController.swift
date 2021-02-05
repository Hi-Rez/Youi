//
//  LabelViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/3/21.
//

import UIKit
import Satin

class LabelViewController: WidgetViewController {
    var valueObservation: NSKeyValueObservation?
    
    override func setupBinding() {
        guard let parameter = self.parameter as? StringParameter else { return }
        valueObservation = parameter.observe(\StringParameter.value, options: [.old, .new]) { [unowned self] _, change in
            if let label = self.label {
                label.text = "\(parameter.label): \(parameter.value)"
            }
        }
            
        guard let label = self.label else { return }
        label.text = "\(parameter.label): \(parameter.value)"
    }
    
    deinit {
        valueObservation = nil
    }
}

