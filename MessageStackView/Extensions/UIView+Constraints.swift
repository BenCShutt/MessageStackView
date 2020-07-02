//
//  UIView+Constraints.swift
//  MessageStackView
//
//  Created by Ben Shutt on 22/11/2019.
//  Copyright © 2019 Ben Shutt. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Constrain edges of `subview` to `self` inset by `insets`
    ///
    /// - Parameters:
    ///   - subview: Subview to constrain to `self`
    ///   - insets: `UIEdgeInsets` on each respective anchor
    func constrainToEdges(for subview: UIView, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return [
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ]
    }
    
    
    /// Constrain width and height equal to `size`

    /// - Parameter size: `CGFloat` for both width and height constant
    func constrainSize(size: CGFloat) -> SizeConstraints {
        return constrainSize(size: CGSize(width: size, height: size))
    }
    
    
    /// Constrain width and height by corresponding `size` property
    ///
    /// - Parameter size: `CGSize` to constrain `widthAnchor` and `heightAnchor` constants equal to
    func constrainSize(size: CGSize) -> SizeConstraints {
        return SizeConstraints(
            width: widthAnchor.constraint(equalToConstant: size.width),
            height: heightAnchor.constraint(equalToConstant: size.height)
        )
    }
}