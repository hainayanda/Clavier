  
//
//  KeyboardLayoutGuide.swift
//  Draftsman
//
//  Created by Nayanda Haberty on 20/06/21.
//
import Foundation
#if canImport(UIKit)
import UIKit

public class KeyboardLayoutGuide: UILayoutGuide {
    
    var window: UIWindow? {
        UIApplication.shared.keyWindow
    }
    
    var safeAreaInsets: UIEdgeInsets {
        guard let view = owningView else { return .zero }
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets
        } else {
            return view.layoutMargins
        }
    }
    
    var defaultKeyboardRect: CGRect {
        let screenRect = UIScreen.main.bounds
        return CGRect(
            x: .zero,
            y: screenRect.height,
            width: screenRect.width,
            height: .zero
        )
    }
    
    var defaultKeyboardRectInWindow: CGRect {
        let windowRect = window?.bounds ?? .zero
        return CGRect(
            x: .zero,
            y: windowRect.height,
            width: windowRect.width,
            height: .zero
        )
    }
    
    var defaultKeyboardRectInView: CGRect {
        guard let view = owningView else { return .zero }
        let viewRect = usingSafeArea ? view.bounds: view.bounds.innerFrame(with: safeAreaInsets)
        return CGRect(
            x: viewRect.origin.x,
            y: viewRect.origin.y + viewRect.height,
            width: viewRect.width,
            height: .zero
        )
    }
    
    var defaultKeyboardInsetsInView: UIEdgeInsets {
        guard let view = owningView else { return .zero }
        let viewRect = view.bounds
        if usingSafeArea {
            return UIEdgeInsets(
                top: viewRect.height - safeAreaInsets.bottom,
                left: safeAreaInsets.left,
                bottom: safeAreaInsets.bottom,
                right: safeAreaInsets.right
            )
        } else {
            return UIEdgeInsets(
                top: viewRect.height,
                left: .zero,
                bottom: .zero,
                right: .zero
            )
        }
    }
    
    lazy var keyboardRect: CGRect = defaultKeyboardRect {
        didSet {
            guard keyboardRect != oldValue else { return }
            updateGuideConstraints()
        }
    }
    
    var keyboardRectInWindow: CGRect {
        guard let window = window else { return defaultKeyboardRectInWindow }
        let intersection = keyboardRect.intersection(window.frame)
        guard !intersection.isNull else { return defaultKeyboardRectInWindow }
        return intersection
    }
    
    var keyboardRectInView: CGRect {
        guard let window = window,
              let view = owningView else { return defaultKeyboardRectInView }
        let rectInView = window.convert(keyboardRectInWindow, to: view)
        let intersection = rectInView.intersection(view.bounds)
        guard !intersection.isNull else { return defaultKeyboardRectInView }
        return intersection
    }
    
    var keyboardEdgeInsetsInView: UIEdgeInsets {
        guard let view = owningView else { return defaultKeyboardInsetsInView }
        return view.frame.insets(of: keyboardRectInView)
    }
    
    var safeKeyboardEdgeInsetsInView: UIEdgeInsets {
        guard let view = owningView else { return defaultKeyboardInsetsInView }
        let safeRect = view.frame.innerFrame(with: safeAreaInsets)
        let intersection = keyboardRectInView.intersection(safeRect)
        guard !intersection.isNull else { return defaultKeyboardInsetsInView }
        return view.frame.insets(of: intersection)
    }
    
    var keyboardTopConstraint: NSLayoutConstraint?
    
    var edgesConstraints: [NSLayoutConstraint] = []
    
    var observeFrameToken: NSObject?
    
    var observeInsetsToken: NSObject?
    
    public override var owningView: UIView? {
        get {
            super.owningView
        } set {
            super.owningView = newValue
            guard let view = newValue else {
                observeFrameToken = nil
                observeInsetsToken = nil
                return
            }
            updateGuideConstraints()
            observeFrameToken = observeFrame(for: view)
            if #available(iOS 11.0, *) {
                observeInsetsToken = observeInsets(for: view)
            } else {
                observeInsetsToken = observeMargins(for: view)
            }
        }
    }
    
    let usingSafeArea: Bool
    
    override init() {
        self.usingSafeArea = false
        super.init()
        didInit()
    }
    
    required init?(coder: NSCoder) {
        self.usingSafeArea = false
        super.init(coder: coder)
        didInit()
    }
    
    init(usingSafeArea: Bool) {
        self.usingSafeArea = usingSafeArea
        super.init()
        didInit()
    }
    
    func didInit() {
        identifier = "clavier_keyboard_layout_guide"
        observeKeyboard()
    }
    
    func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardFrameChanged(notification:)),
            name: UIView.keyboardWillChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardFrameChanged(notification:)),
            name: UIView.keyboardDidChangeFrameNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardFrameChanged(notification:)),
            name: UIApplication.willChangeStatusBarOrientationNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardFrameChanged(notification:)),
            name: UIApplication.willChangeStatusBarOrientationNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardFrameChanged(notification:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    func observeFrame(for view: UIView) -> NSObject {
        return view.observe(\.frame, options: [.new, .old]) { [weak self] sender, changes in
            guard let self = self else { return }
            self.updateGuideConstraints()
        }
    }
    
    @available(iOS 11.0, *)
    func observeInsets(for view: UIView) -> NSObject {
        return view.observe(\.safeAreaInsets, options: [.new, .old]) { [weak self] sender, changes in
            guard let self = self else { return }
            self.updateGuideConstraints()
        }
    }
    
    func observeMargins(for view: UIView) -> NSObject {
        return view.observe(\.layoutMargins, options: [.new, .old]) { [weak self] sender, changes in
            guard let self = self else { return }
            self.updateGuideConstraints()
        }
    }
    
    func updateGuideConstraints() {
        guard let view = owningView else { return }
        let insets = usingSafeArea ? safeKeyboardEdgeInsetsInView: keyboardEdgeInsetsInView
        if edgesConstraints.count != 4 {
            createEdgeConstraints(for: view, with: insets)
        } else {
            edgesConstraints[0].constant = insets.left
            edgesConstraints[1].constant = insets.top
            edgesConstraints[2].constant = -insets.right
            edgesConstraints[3].constant = -insets.bottom
        }
        view.layoutIfNeeded()
    }
    
    func createEdgeConstraints(for view: UIView, with insets: UIEdgeInsets) {
        edgesConstraints = [
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ]
        for constraint in edgesConstraints {
            constraint.priority = .required
            constraint.isActive = true
        }
    }
    
    @objc func keyboardFrameChanged(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
                ?? userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            keyboardRect = defaultKeyboardRect
            return
        }
        guard keyboardValue.cgRectValue.intersects(UIScreen.main.bounds) else {
            keyboardRect = defaultKeyboardRect
            return
        }
        let rect = keyboardValue.cgRectValue.intersection(UIScreen.main.bounds)
        guard !rect.isNull else {
            keyboardRect = defaultKeyboardRect
            return
        }
        keyboardRect = rect
    }
}
#endif
