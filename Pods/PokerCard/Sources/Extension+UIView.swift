//
//  Extension+UIView.swift
//  PokerCard
//
//  Created by Weslie on 2019/10/1.
//  Copyright © 2019 Weslie (https://www.iweslie.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

extension UIView {
    /// Set leading and trailing anchor
    internal func constraint(withLeadingTrailing inset: CGFloat) {
        guard let superView = superview else { return }
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: inset).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -inset).isActive = true
    }

    /// Set leading and trailing anchor
    internal func constraint(withTopBottom inset: CGFloat) {
        guard let superView = superview else { return }
        topAnchor.constraint(equalTo: superView.topAnchor, constant: inset).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -inset).isActive = true
    }

    /// Set width and height anchor
    internal func constraint(withWidthHeight constant: CGFloat) {
        widthAnchor.constraint(equalToConstant: constant).isActive = true
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }

    /// Set width and height anchor equal
    internal func constraint(equalWidthHeight toView: UIView) {
        heightAnchor.constraint(equalTo: toView.heightAnchor).isActive = true
        widthAnchor.constraint(equalTo: toView.widthAnchor).isActive = true
    }

    /// Set width and height constant
    internal func constraint(widthHeightEqualToConstant constant: CGFloat) {
        heightAnchor.constraint(equalToConstant: constant).isActive = true
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }

    /// Set equal width and height with center baseline
    internal func constraint(horizontalStack toView: UIView) {
        constraint(equalWidthHeight: toView)
        centerYAnchor.constraint(equalTo: toView.centerYAnchor).isActive = true
    }

    /// Set equal width and height with center vertical
    internal func constraint(verticalStack toView: UIView) {
        constraint(equalWidthHeight: toView)
        centerXAnchor.constraint(equalTo: toView.centerXAnchor).isActive = true
    }

    /// Set equal width and height with center vertical
    internal func constraint(alignCenter toView: UIView) {
        centerXAnchor.constraint(equalTo: toView.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: toView.centerYAnchor).isActive = true
    }
}
