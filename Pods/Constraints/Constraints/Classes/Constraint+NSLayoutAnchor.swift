//
//  Constraint+NSLayoutAnchor.swift
//  Constraints
//
//  Created by Serhiy Vysotskiy on 12/26/17.
//  Copyright © 2017 vysotskiyserhiy. All rights reserved.
//

import UIKit

extension Constraint {
    public func xAnchor(_ anchor: NSLayoutXAxisAnchor, to anotherAnchor: NSLayoutXAxisAnchor, c: CGFloat = 0) -> Constraint {
        constraintsChain.constraints.append(anchor.constraint(equalTo: anotherAnchor, constant: c * scale))
        return Constraint(view: view, superview: superview, constraintsChain: constraintsChain, constraint: constraintsChain.constraints.last)
    }
    
    public func yAnchor(_ anchor: NSLayoutYAxisAnchor, to anotherAnchor: NSLayoutYAxisAnchor, c: CGFloat = 0) -> Constraint {
        constraintsChain.constraints.append(anchor.constraint(equalTo: anotherAnchor, constant: c * scale))
        return Constraint(view: view, superview: superview, constraintsChain: constraintsChain, constraint: constraintsChain.constraints.last)
    }
    
    public func dAnchor(_ anchor: NSLayoutDimension, c: CGFloat) -> Constraint {
        constraintsChain.constraints.append(anchor.constraint(equalToConstant: c * scale))
        return Constraint(view: view, superview: superview, constraintsChain: constraintsChain, constraint: constraintsChain.constraints.last)
    }
}

//@available(iOS 11.0, *)
//extension Constraint {
//    public func safePin(_ edges: Edge..., c: CGFloat = 0) -> Constraint {
//        var newEdges = edges
//
//        if edges.isEmpty {
//            newEdges = [.left, .top, .right, .bottom]
//        }
//
//        return newEdges.set.reduce(self) {
//            switch $1 {
//            case .left:
//                return $0.xAnchor(view.leftAnchor, to: superview.safeAreaLayoutGuide.leftAnchor, c: c * scale)
//            case .top:
//                return $0.yAnchor(view.topAnchor, to: superview.safeAreaLayoutGuide.topAnchor, c: c * scale)
//            case .right:
//                return $0.xAnchor(view.rightAnchor, to: superview.safeAreaLayoutGuide.rightAnchor, c: -c * scale)
//            case .bottom:
//                return $0.yAnchor(view.bottomAnchor, to: superview.safeAreaLayoutGuide.bottomAnchor, c: -c * scale)
//            }
//        }
//    }
//}

public var safeMargins: UIEdgeInsets = .zero

extension Constraint {
    public func safePin(_ edges: Edge..., c: CGFloat = 0) -> Constraint {
        if #available(iOS 11.0, *) {
            var newEdges = edges
            
            if edges.isEmpty {
                newEdges = [.left, .top, .right, .bottom]
            }
            
            return newEdges.set.reduce(self) {
                switch $1 {
                case .left:
                    return $0.xAnchor(view.leftAnchor, to: superview.safeAreaLayoutGuide.leftAnchor, c: c * scale)
                case .top:
                    return $0.yAnchor(view.topAnchor, to: superview.safeAreaLayoutGuide.topAnchor, c: c * scale)
                case .right:
                    return $0.xAnchor(view.rightAnchor, to: superview.safeAreaLayoutGuide.rightAnchor, c: -c * scale)
                case .bottom:
                    return $0.yAnchor(view.bottomAnchor, to: superview.safeAreaLayoutGuide.bottomAnchor, c: -c * scale)
                }
            }
        } else {
            guard !edges.isEmpty else {
                return pin(.left, to: .left, of: superview, c: c + safeMargins.left)
                    .pin(.top, to: .top, of: superview, c: c + safeMargins.top)
                    .pin(.right, to: .right, of: superview, c: -c - safeMargins.right)
                    .pin(.bottom, to: .bottom, of: superview, c: -c - safeMargins.bottom)
            }
            
            return edges.set.reduce(self) { constraint, edge in
                switch edge {
                case .left:
                    return constraint.pin(.left, to: .left, of: superview, c: c + safeMargins.left)
                case .top:
                    return constraint.pin(.top, to: .top, of: superview, c: c + safeMargins.top)
                case .right:
                    return constraint.pin(.right, to: .right, of: superview, c: -c - safeMargins.right)
                case .bottom:
                    return constraint.pin(.bottom, to: .bottom, of: superview, c: -c - safeMargins.bottom)
                }
            }
        }
    }
}
