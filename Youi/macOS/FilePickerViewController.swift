//
//  FilePickerViewController.swift
//  Youi
//
//  Created by Sean Patrick O'Brien on 7/11/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa
import Satin

// MARK: NSView Snapshotting

private extension NSView {
    var imageRepresentation: NSImage? {
        let rect = bounds
        guard let rep = bitmapImageRepForCachingDisplay(in: rect) else { return nil }
        cacheDisplay(in: rect, to: rep)
        
        let image = NSImage(size: rect.size)
        image.addRepresentation(rep)
        return image
    }
}

// MARK: - Drop Target View

private protocol DropTargetViewDelegate: NSObjectProtocol {
    func dropTargetViewShouldAcceptDrop(_ sender: DropTargetView, from source: Any?) -> Bool
    func dropTargetViewAcceptedDrop(_ sender: DropTargetView, urls: [URL])
}

private class DropTargetView: NSView {
    var allowedTypes: [String] = []
    
    weak var delegate: DropTargetViewDelegate?
    
    private var isTargetingDrop: Bool = false {
        didSet {
            needsDisplay = true
        }
    }
    
    private func commonInit() {
        registerForDraggedTypes([ .fileURL ])
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override var wantsUpdateLayer: Bool { true }
    
    override func updateLayer() {
        let savedDisableActions = CATransaction.disableActions()
        CATransaction.setDisableActions(true)
        defer {
            CATransaction.setDisableActions(savedDisableActions)
        }
        
        layer?.borderColor = NSColor.selectedControlColor.cgColor
        layer?.borderWidth = isTargetingDrop ? 4.0 : 0.0
    }
    
    func shouldAcceptSource(_ source: Any?) -> Bool {
        guard let delegate = delegate else { return true }
        return delegate.dropTargetViewShouldAcceptDrop(self, from: source)
    }
    
    func readFileURLs(from pasteboard: NSPasteboard) -> [URL]? {
        var options = [NSPasteboard.ReadingOptionKey : Any]()
        if !allowedTypes.isEmpty {
            options[.urlReadingContentsConformToTypes] = allowedTypes
        }
        
        guard let urls = pasteboard.readObjects(forClasses: [ NSURL.self ], options: options) else { return nil }
        return urls.compactMap { $0 as? URL }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard shouldAcceptSource(sender.draggingSource) else { return [] }
        guard let urls = readFileURLs(from: sender.draggingPasteboard), !urls.isEmpty else {
            isTargetingDrop = false
            return []
        }
        
        isTargetingDrop = true
        return .generic
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isTargetingDrop = false
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo) {
        isTargetingDrop = false
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard shouldAcceptSource(sender.draggingSource) else { return false }
        guard let urls = readFileURLs(from: sender.draggingPasteboard), !urls.isEmpty else { return false }
        delegate?.dropTargetViewAcceptedDrop(self, urls: urls)
        return true
    }
}

// MARK: - Proxy Icon View

private class ProxyIconView: NSView, NSDraggingSource {
    static let fontSize: CGFloat = 13.0
    
    var path: String = "" {
        didSet {
            updateViews()
        }
    }
    
    private let pathControl = NSPathControl()
    private let imageView = NSImageView()
    private let label = NSTextField(labelWithString: "")
    
    private func commonInit() {
        let hStack = NSStackView()
        hStack.wantsLayer = true
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.orientation = .horizontal
        hStack.spacing = 4
        hStack.alignment = .centerY
        hStack.setHuggingPriority(.defaultHigh, for: .horizontal)
        addSubview(hStack)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        hStack.addArrangedSubview(imageView)
        
        label.font = .menuFont(ofSize: ProxyIconView.fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        hStack.addArrangedSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 16.0),
            imageView.heightAnchor.constraint(equalToConstant: 16.0),
            hStack.widthAnchor.constraint(equalTo: widthAnchor),
            hStack.heightAnchor.constraint(equalTo: heightAnchor),
            hStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            hStack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        pathControl.pathStyle = .popUp
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func updateViews() {
        pathControl.url = URL(fileURLWithPath: path)
        imageView.image = ProxyIconView.iconForFile(path)
        label.stringValue = ProxyIconView.displayNameForFile(path)
        
        let fileExists = FileManager.default.fileExists(atPath: path)
        imageView.isHidden = !fileExists
        label.textColor = fileExists ? .labelColor : .tertiaryLabelColor
    }
    
    private static func imageForFile(_ path: String) -> NSImage {
        let workspace = NSWorkspace.shared
        let pathExtension = NSString(string: path).pathExtension
        if FileManager.default.fileExists(atPath: path) {
            return workspace.icon(forFile: path)
        } else if !pathExtension.isEmpty {
            return workspace.icon(forFileType: pathExtension)
        } else {
            return workspace.icon(forFileType: "")
        }
    }
    
    static func iconForFile(_ path: String) -> NSImage {
        let image = imageForFile(path)
        image.size = CGSize(width: 16.0, height: 16.0)
        return image
    }
    
    static func displayNameForFile(_ path: String) -> String {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: path) {
            return fileManager.displayName(atPath: path)
        } else if !path.isEmpty {
            return NSString(string: path).lastPathComponent
        } else {
            return "(empty)"
        }
    }
    
    private var initialMouseDownLocation: CGPoint = .zero
    private var didBeginDrag: Bool = false
    private var didShowPopUp: Bool = false
    
    override func mouseDown(with event: NSEvent) {
        initialMouseDownLocation = convert(event.locationInWindow, from: nil)
        didBeginDrag = false
        didShowPopUp = false
        
        let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        if modifiers == .control || modifiers == .command {
            didShowPopUp = true
            showPopUp()
        }
    }
    
    override func rightMouseDown(with event: NSEvent) {
        initialMouseDownLocation = convert(event.locationInWindow, from: nil)
        didBeginDrag = false
        didShowPopUp = true
        showPopUp()
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard !didBeginDrag else { return }
        guard !didShowPopUp else { return }
        
        let currentMouseLocation = convert(event.locationInWindow, from: nil)
        let distance = hypot(currentMouseLocation.x - initialMouseDownLocation.x,
                             currentMouseLocation.y - initialMouseDownLocation.y)
        guard distance > 3.0 else { return }
        
        didBeginDrag = true
        beginDrag(with: event)
    }
    
    private func showPopUp() {
        guard FileManager.default.fileExists(atPath: path) else { return }
        
        let menu = NSMenu(title: "")
        menu.font = label.font!
        
        var previousURL: URL? = nil
        for pathItem in pathControl.pathItems.reversed() {
            let menuItem = menu.addItem(withTitle: pathItem.title, action: #selector(revealURL), keyEquivalent: "")
            menuItem.target = self
            menuItem.representedObject = previousURL
            
            if let image = pathItem.image {
                image.size = CGSize(width: 16.0, height: 16.0)
                menuItem.image = image
            }
            
            previousURL = pathItem.url
        }
        
        let imageRect = convert(imageView.bounds, to: self)
        menu.popUp(positioning: menu.item(at: 0), at: CGPoint(x: imageRect.minX - 21.0, y: imageRect.maxY + 2.0), in: self)
    }
    
    private func beginDrag(with event: NSEvent) {
        guard FileManager.default.fileExists(atPath: path) else { return }
        
        let url = NSURL(fileURLWithPath: path)
        let dragItem = NSDraggingItem(pasteboardWriter: url)
        
        let views: [NSDraggingItem.ImageComponentKey:NSView] = [ .icon: imageView, .label: label ]
        dragItem.imageComponentsProvider = { [unowned self] () -> [NSDraggingImageComponent] in
            views.map { (key, view) -> NSDraggingImageComponent in
                let component = NSDraggingImageComponent(key: key)
                component.frame = self.convert(view.bounds, from: view)
                component.contents = view.imageRepresentation
                return component
            }
        }
        dragItem.draggingFrame = bounds
        
        _ = beginDraggingSession(with: [ dragItem ], event: event, source: self)
    }
    
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return [ .copy, .link, .generic ]
    }
    
    @objc func revealURL(_ sender: NSMenuItem) {
        guard let url = sender.representedObject as? URL else { return }
        NSWorkspace.shared.activateFileViewerSelecting([ url ])
    }
    
    override var firstBaselineAnchor: NSLayoutYAxisAnchor { label.firstBaselineAnchor }
}

// MARK: - File Picker View Controller

open class FilePickerViewController: NSViewController, DropTargetViewDelegate {
    public weak var parameter: StringParameter?
    
    private var observation: NSKeyValueObservation?
    private let dropTargetView = DropTargetView()
    private let labelField = NSTextField(labelWithString: "")
    private let proxyIconView = ProxyIconView()
    private let disclosureButton = NSButton(title: "", target: nil, action: #selector(showPopUpMenu(_:)))

    open override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false

        guard let parameter = self.parameter else { return }
        observation = parameter.observe(\StringParameter.value, options: [ .old, .new ]) { [unowned self] (_, change) in
            if let oldPath = change.oldValue {
                self.addRecent(oldPath, moveToTop: false)
            }
            
            if let newPath = change.newValue {
                self.proxyIconView.path = newPath
                self.addRecent(newPath, moveToTop: true)
            }
        }
        
        dropTargetView.delegate = self
        dropTargetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dropTargetView)
        NSLayoutConstraint.activate([
            dropTargetView.widthAnchor.constraint(equalTo: view.widthAnchor),
            dropTargetView.heightAnchor.constraint(equalTo: view.heightAnchor),
            dropTargetView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dropTargetView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

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
        hStack.spacing = 8
        hStack.alignment = .firstBaseline
        hStack.distribution = .gravityAreas
        vStack.addView(hStack, in: .center)
        hStack.widthAnchor.constraint(equalTo: vStack.widthAnchor, constant: -14).isActive = true

        labelField.font = .labelFont(ofSize: 12)
        labelField.translatesAutoresizingMaskIntoConstraints = false
        labelField.isEditable = false
        labelField.isBordered = false
        labelField.backgroundColor = .clear
        labelField.stringValue = parameter.label
        hStack.addView(labelField, in: .leading)
        view.heightAnchor.constraint(equalTo: labelField.heightAnchor, constant: 16).isActive = true

        proxyIconView.path = parameter.value
        proxyIconView.translatesAutoresizingMaskIntoConstraints = false
        hStack.addView(proxyIconView, in: .trailing)
        
        disclosureButton.target = self
        disclosureButton.translatesAutoresizingMaskIntoConstraints = false
        disclosureButton.bezelStyle = .roundedDisclosure
        disclosureButton.setButtonType(.momentaryLight)
        disclosureButton.controlSize = .mini
        disclosureButton.sendAction(on: .leftMouseDown)
        hStack.addView(disclosureButton, in: .trailing)
    }
    
    private func addRecent(_ path: String, moveToTop: Bool = true) {
        guard let parameter = parameter else { return }
        guard FileManager.default.fileExists(atPath: path) else { return }
        var options = parameter.options
        
        if moveToTop {
            options.removeAll { $0 == path }
            options.insert(path, at: 0)
        } else if !options.contains(path) {
            options.insert(path, at: 0)
        }
        
        parameter.options = options
    }
    
    @objc func showPopUpMenu(_ sender: NSButton) {
        let menu = NSMenu(title: "")
        menu.font = .menuFont(ofSize: ProxyIconView.fontSize)
        
        let item = menu.addItem(withTitle: "Choose…", action: #selector(chooseFile(_:)), keyEquivalent: "")
        item.target = self
        
        if let parameter = parameter {
            if !parameter.value.isEmpty {
                let item = menu.addItem(withTitle: "Remove", action: #selector(clearFile(_:)), keyEquivalent: "")
                item.target = self
            }
            
            let fileManager = FileManager.default
            let recents = parameter.options.filter { fileManager.fileExists(atPath: $0) }
            
            if !recents.isEmpty {
                menu.addItem(.separator())
                let headerItem = menu.addItem(withTitle: "Recents", action: nil, keyEquivalent: "")
                headerItem.isEnabled = false
                
                for recent in parameter.options {
                    guard fileManager.fileExists(atPath: recent) else { continue }
                    let item = menu.addItem(withTitle: ProxyIconView.displayNameForFile(recent), action: #selector(selectRecent(_:)), keyEquivalent: "")
                    item.representedObject = recent
                    item.target = self
                    item.image = ProxyIconView.iconForFile(recent)
                }
                
                menu.addItem(.separator())
                let clearItem = menu.addItem(withTitle: "Clear Menu", action: #selector(clearRecents(_:)), keyEquivalent: "")
                clearItem.target = self
            }
        }
        
        let buttonRect = view.convert(sender.bounds, from: sender)
        let position = CGPoint(x: buttonRect.minX, y: buttonRect.minY - 3.0)
        menu.popUp(positioning: nil, at: position, in: self.view)
    }
    
    @objc func chooseFile(_ sender: NSMenuItem?) {
        let panel = NSOpenPanel()
        panel.begin { response in
            guard response == .OK else { return }
            guard let url = panel.url else { return }
            self.parameter?.value = url.path
        }
    }
    
    @objc func clearFile(_ sender: NSMenuItem?) {
        guard let parameter = parameter else { return }
        parameter.value = ""
    }
    
    @objc func selectRecent(_ sender: NSMenuItem) {
        guard let parameter = parameter else { return }
        guard let path = sender.representedObject as? String else { return }
        guard FileManager.default.fileExists(atPath: path) else { return }
        
        parameter.value = path
    }
    
    @objc func clearRecents(_ sender: NSMenuItem) {
        guard let parameter = parameter else { return }
        parameter.options = []
    }
    
    fileprivate func dropTargetViewShouldAcceptDrop(_ sender: DropTargetView, from source: Any?) -> Bool {
        if let view = source as? ProxyIconView, view === proxyIconView {
            // don't allow drags from ourself
            return false
        }

        return true
    }
    
    fileprivate func dropTargetViewAcceptedDrop(_ sender: DropTargetView, urls: [URL]) {
        guard let url = urls.first else { return }
        parameter?.value = url.path
    }
}
