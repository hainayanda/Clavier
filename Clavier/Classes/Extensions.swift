//
//  Extensions.swift
//  Clavier
//
//  Created by Nayanda Haberty on 20/06/21.
//

import Foundation
#if canImport(UIKit)
import UIKit

public extension UIView {
    var keyboardLayoutGuide: KeyboardLayoutGuide {
        for guide in layoutGuides {
            if let keyboardGuide = guide as? KeyboardLayoutGuide {
                return keyboardGuide
            }
        }
        let keyboardGuide = KeyboardLayoutGuide()
        addLayoutGuide(keyboardGuide)
        keyboardGuide.updateGuideConstraints()
        return keyboardGuide
    }
}

extension CGRect {
    func insets(of innerFrame: CGRect) -> UIEdgeInsets {
        let topInset = innerFrame.origin.y
        let leftInset = innerFrame.origin.x
        let maxX = topInset + innerFrame.size.height
        let bottomInset = size.height - maxX
        let maxY = leftInset + innerFrame.size.width
        let rightInset = size.width - maxY
        return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
}
#endif
