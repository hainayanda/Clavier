//
//  ExtensionsSpec.swift
//  Clavier_Tests
//
//  Created by Nayanda Haberty on 22/06/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Clavier
#if canImport(UIKit)
import UIKit

class ExtensionsSpec: QuickSpec {
    override func spec() {
        describe("UIView Extensions") {
            var view: UIView!
            beforeEach {
                view = UIView()
            }
            it("should not use safe area") {
                guard let layoutGuide = view.clavierLayoutGuide as? ClavierLayoutGuide else {
                    return
                }
                expect(layoutGuide.usingSafeArea).to(beFalse())
            }
            it("should use safe area") {
                guard let layoutGuide = view.clavierLayoutGuide as? ClavierLayoutGuide else {
                    fatalError("should be using ClavierLayoutGuide")
                }
                expect(layoutGuide.usingSafeArea).to(beTrue())
            }
        }
        describe("CGRect Extensions") {
            let rect: CGRect = .init(
                origin: .init(x: 12, y: 34),
                size: .init(width: 56, height: 78)
            )
            it("should return zero insets") {
                let testRect: CGRect = CGRect(origin: .zero, size: rect.size)
                expect(rect.insets(of: testRect)).to(equal(.zero))
            }
            it("should calculate right insets") {
                let testRect: CGRect = CGRect(
                    origin: .init(x: 9, y: 10),
                    size: .init(width: 40, height: 60)
                )
                let expected: UIEdgeInsets = .init(
                    top: 10,
                    left: 9,
                    bottom: 8,
                    right: 7
                )
                expect(rect.insets(of: testRect)).to(equal(expected))
            }
            it("should return zero frame") {
                let testInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 78, right: 56)
                expect(rect.innerFrame(with: testInsets)).to(equal(.zero))
            }
            it("should calculate right inner frame") {
                let testInsets: UIEdgeInsets = .init(
                    top: 10,
                    left: 9,
                    bottom: 8,
                    right: 7
                )
                let expected: CGRect = CGRect(
                    origin: .init(x: 9, y: 10),
                    size: .init(width: 40, height: 60)
                )
                expect(rect.innerFrame(with: testInsets)).to(equal(expected))
            }
        }
    }
}
#endif
