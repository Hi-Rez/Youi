//
//  MultiDropdownViewController.swift
//  Youi-macOS
//
//  Created by Reza Ali on 4/26/20.
//

import Combine
import Satin

#if os(macOS)

import Cocoa

open class MultiDropdownViewController: NSViewController {
    public var parameters: [StringParameter] = []
    var cancellables = Set<AnyCancellable>()
    
    public var options: [[String]] = []
    var labelFields: [NSTextField] = []
    var dropDownMenus: [String: NSPopUpButton] = [:]
    var spacers: [Spacer] = []
    
    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false

        let vStack = NSStackView()
        vStack.wantsLayer = true
        vStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vStack)
        vStack.orientation = .vertical
        vStack.distribution = .gravityAreas
        vStack.spacing = 4

        vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        vStack.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        vStack.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        let hStack = NSStackView()
        hStack.wantsLayer = true
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.orientation = .horizontal
        hStack.spacing = 4
        hStack.alignment = .centerY
        hStack.distribution = .fillProportionally
        vStack.addView(hStack, in: .center)
        hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -14).isActive = true

        for (index, parameter) in parameters.enumerated() {
            parameter.$value.sink { [weak self] newValue in
                if let self = self, let dd = self.dropDownMenus[parameter.label] {
                    DispatchQueue.main.async {
                        dd.selectItem(withTitle: parameter.value)
                    }
                }
            }.store(in: &cancellables)
            
            let labelField = NSTextField()
            labelField.font = .labelFont(ofSize: 12)
            labelField.translatesAutoresizingMaskIntoConstraints = false
            labelField.isEditable = false
            labelField.isBordered = false
            labelField.backgroundColor = .clear
            labelField.stringValue = parameter.label

//            hStack.addView(labelField, in: .trailing)
            hStack.addArrangedSubview(labelField)
            view.heightAnchor.constraint(equalTo: labelField.heightAnchor, constant: 16).isActive = true

            let dropDownMenu = NSPopUpButton()
            dropDownMenu.wantsLayer = true
            dropDownMenu.translatesAutoresizingMaskIntoConstraints = false

            if options.count == parameters.count {
                dropDownMenu.addItems(withTitles: options[index])
            }
            else {
                dropDownMenu.addItems(withTitles: parameter.options)
            }
            dropDownMenu.selectItem(withTitle: parameter.value)
            dropDownMenu.target = self
            dropDownMenu.action = #selector(onSelected)
            dropDownMenu.bezelStyle = .texturedRounded
            dropDownMenu.tag = index
            hStack.addArrangedSubview(dropDownMenu)
            labelFields.append(labelField)
            dropDownMenus[parameter.label] = dropDownMenu

//            if (index + 1) != parameters.count {
//                let spacer = Spacer()
//                spacer.widthAnchor.constraint(equalToConstant: 1).isActive = true
//                hStack.addView(spacer, in: .trailing)
//                spacer.heightAnchor.constraint(equalTo: hStack.heightAnchor).isActive = true
//                spacers.append(spacer)
//            }
        }
    }

    @objc func onSelected(_ sender: NSPopUpButton) {
        parameters[sender.tag].value = sender.title
    }

    deinit {
        labelFields = []
        dropDownMenus = [:]
        parameters = []
        options = []
        spacers = []
    }
}

#endif
