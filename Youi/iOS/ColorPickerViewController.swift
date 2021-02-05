//
//  ColorPickerViewController.swift
//  YouiTwo
//
//  Created by Reza Ali on 2/3/21.
//

import Satin
import simd
import UIKit

class ColorPickerViewController: WidgetViewController {
    var observationR: NSKeyValueObservation?
    var observationG: NSKeyValueObservation?
    var observationB: NSKeyValueObservation?
    var observationA: NSKeyValueObservation?

    var colorWell: UIColorWell?
    
    override var minHeight: CGFloat {
        56
    }

    override open func loadView() {
        setupView()
        setupStackViews()
        setupColorWell()
        setupLabel()
        setupBinding()
    }
    
    override func setupHorizontalStackView() {
        super.setupHorizontalStackView()
        if let stack = hStack {
            stack.spacing = 8
            stack.distribution = .fill
            stack.alignment = .center
        }
    }

    func setupColorWell() {
        guard let stack = hStack else { return }
        let colorWell = UIColorWell()
        colorWell.translatesAutoresizingMaskIntoConstraints = false
        colorWell.addAction(UIAction(handler: { [unowned self] _ in
            if let well = self.colorWell, let param = self.parameter as? Float4Parameter, let color = well.selectedColor {
                var red: CGFloat = 0
                var green: CGFloat = 0
                var blue: CGFloat = 0
                var alpha: CGFloat = 0
                color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                param.value = simd_make_float4(Float(red), Float(green), Float(blue), Float(alpha))
            }
        }), for: .valueChanged)
        stack.addArrangedSubview(colorWell)
        self.colorWell = colorWell
    }

  
    override func setupBinding() {
        guard let param = parameter as? Float4Parameter else { return }
        let colorCb: (Float4Parameter, NSKeyValueObservedChange<Float>) -> Void = { [unowned self] _, _ in
            if let param = parameter as? Float4Parameter, let colorWell = self.colorWell {
                colorWell.selectedColor = UIColor(displayP3Red: CGFloat(param.x), green: CGFloat(param.y), blue: CGFloat(param.z), alpha: CGFloat(param.w))
            }
        }
        observationR = param.observe(\.x, changeHandler: colorCb)
        observationG = param.observe(\.y, changeHandler: colorCb)
        observationB = param.observe(\.z, changeHandler: colorCb)
        observationA = param.observe(\.w, changeHandler: colorCb)

        if let colorWell = self.colorWell {
            colorWell.selectedColor = UIColor(displayP3Red: CGFloat(param.x), green: CGFloat(param.y), blue: CGFloat(param.z), alpha: CGFloat(param.w))
        }
        
        super.setupBinding()
    }

    deinit {
        observationR = nil
        observationG = nil
        observationB = nil
        observationA = nil
        colorWell = nil
    }
}
