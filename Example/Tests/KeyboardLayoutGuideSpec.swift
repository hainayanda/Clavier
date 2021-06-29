//
//  KeyboardLayoutGuideSpec.swift
//  Clavier_Tests
//
//  Created by Nayanda Haberty on 29/06/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Clavier
#if canImport(UIKit)
import UIKit

class KeyboardLayoutGuideSpec: QuickSpec {
    override func spec() {
        var layoutGuide: KeyboardLayoutGuide!
        var window: UIWindow!
        var view: UIView!
        beforeEach {
            layoutGuide = TestableKeyboardLayoutGuide()
            view = UIView()
            window = layoutGuide.window!
            window.addSubview(view)
            view.addLayoutGuide(layoutGuide)
        }
        describe("keyboard is up") {
            beforeEach {
                layoutGuide.keyboardState = .up
                layoutGuide.keyboardRect = CGRect(x: .zero, y: 100, width: 100, height: 100)
            }
            context("without safe area") {
                beforeEach {
                    layoutGuide.usingSafeArea = false
                }
                it("should calculate use keyboard rect") {
                    view.frame = window.bounds
                    expect(layoutGuide.layoutFrame).to(equal(CGRect(x: .zero, y: 100, width: 100, height: 100)))
                }
                it("should calculate intersection rect of view and keyboard") {
                    view.frame = CGRect(x: 20, y: 20, width: 60, height: 160)
                    expect(layoutGuide.layoutFrame).to(equal(CGRect(x: .zero, y: 80, width: 60, height: 80)))
                }
                it("should use default rect") {
                    view.frame = CGRect(x: .zero, y: .zero, width: 100, height: 100)
                    expect(layoutGuide.layoutFrame).to(equal(CGRect(x: .zero, y: 100, width: 100, height: .zero)))
                }
            }
            context("with safe area") {
                beforeEach {
                    layoutGuide.usingSafeArea = true
                }
                it("should calculate use keyboard rect") {
                    view.frame = window.bounds
                    expect(layoutGuide.layoutFrame).to(equal(CGRect(x: 10, y: 100, width: 80, height: 90)))
                }
                it("should calculate intersection rect of view and keyboard") {
                    view.frame = CGRect(x: 20, y: 20, width: 60, height: 160)
                    expect(layoutGuide.layoutFrame).to(equal(CGRect(x: 10, y: 80, width: 40, height: 70)))
                }
                it("should use default rect") {
                    view.frame = CGRect(x: .zero, y: .zero, width: 100, height: 100)
                    expect(layoutGuide.layoutFrame).to(equal(CGRect(x: 10, y: 90, width: 80, height: .zero)))
                }
            }
        }
        describe("keyboard is down") {
            beforeEach {
                layoutGuide.keyboardState = .down
                layoutGuide.keyboardRect = CGRect(x: .zero, y: 200, width: 100, height: 100)
            }
            context("without safe area") {
                beforeEach {
                    layoutGuide.usingSafeArea = false
                }
                it("should use default rect") {
                    view.frame = window.bounds
                    expect(layoutGuide.layoutFrame).to(equal(CGRect(x: .zero, y: 200, width: 100, height: .zero)))
                }
                it("should use default rect") {
                    view.frame = CGRect(x: 20, y: 20, width: 60, height: 160)
                    expect(layoutGuide.layoutFrame).to(equal(CGRect(x: .zero, y: 160, width: 60, height: .zero)))
                }
                it("should use default rect") {
                    view.frame = CGRect(x: .zero, y: .zero, width: 100, height: 100)
                    expect(layoutGuide.layoutFrame).to(equal(CGRect(x: .zero, y: 100, width: 100, height: .zero)))
                }
            }
            context("with safe area") {
                beforeEach {
                    layoutGuide.usingSafeArea = true
                }
                it("should use default rect") {
                    view.frame = window.bounds
                    expect(layoutGuide.layoutFrame).to(equal(CGRect(x: 10, y: 190, width: 80, height: .zero)))
                }
                it("should use default rect") {
                    view.frame = CGRect(x: 20, y: 20, width: 60, height: 160)
                    expect(layoutGuide.layoutFrame).to(equal(CGRect(x: 10, y: 150, width: 40, height: .zero)))
                }
                it("should use default rect") {
                    view.frame = CGRect(x: .zero, y: .zero, width: 100, height: 100)
                    expect(layoutGuide.layoutFrame).to(equal(CGRect(x: 10, y: 90, width: 80, height: .zero)))
                }
            }
        }
    }
}

class TestableKeyboardLayoutGuide: KeyboardLayoutGuide {
    let dummyWindow: UIWindow = {
        let window = UIWindow()
        window.frame = CGRect(x: .zero, y: .zero, width: 100, height: 200)
        return window
    }()
    
    override var window: UIWindow? {
        dummyWindow
    }
    
    override var safeAreaInsets: UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override var defaultKeyboardRect: CGRect {
        CGRect(x: .zero, y: 200, width: 100, height: .zero)
    }
    
    override var defaultKeyboardRectInWindow: CGRect {
        CGRect(x: .zero, y: 200, width: 100, height: .zero)
    }
}

#endif
