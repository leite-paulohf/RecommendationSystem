//
//  Constraint.swift
//  Constraints
//
//  Created by Serhiy Vysotskiy on 12/24/17.
//  Copyright © 2017 Serhiy Vysotskiy. All rights reserved.
//

import UIKit.UIView

public extension UIView {
    public func constraint(on superview: UIView) -> Constraint {
        return Constraint(view: self, superview: superview, constraintsChain: ConstraintsChain())
    }
}

public final class Constraint {
    public let view: UIView
    public let superview: UIView
    public let constraintsChain: ConstraintsChain
    public var constraint: NSLayoutConstraint?
    
    init(view: UIView, superview: UIView, constraintsChain: ConstraintsChain, constraint: NSLayoutConstraint? = nil) {
        if superview !== view.superview, superview !== view {
            superview.addSubview(view)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view = view
        self.superview = superview
        self.constraintsChain = constraintsChain
        self.constraint = constraint
    }
    
    deinit {
//        print("DEINIT CONSTRAINT")
    }
}

// MARK: - Activate/Deactivate constraints
extension Constraint {
    @discardableResult
    public func activate() -> ConstraintsChain {
        constraintsChain.activate()
        return constraintsChain
    }
    
    public func deactivate() {
        constraintsChain.deactivate()
    }
    
    public func activateConstraint() {
        constraint?.isActive = true
    }
    
    public func deactivateConstraint() {
        constraint?.isActive = false
    }
}

// MARK: - Chaining
extension Constraint {
    public func chain(with other: Constraint) -> Constraint {
        return Constraint(view: other.view, superview: other.superview, constraintsChain: other.constraintsChain.merged(constraintsChain))
    }
    
    public func chain(with view: UIView, on superview: UIView) -> Constraint {
        return Constraint(view: view, superview: superview, constraintsChain: constraintsChain)
    }
}

// MARK: - Constraint methods
extension Constraint {
    public func pin(_ a1: NSLayoutConstraint.Attribute, to a2: NSLayoutConstraint.Attribute, of v2: UIView?, r: NSLayoutConstraint.Relation = .equal, c: CGFloat = 0, m: CGFloat = 1) -> Constraint {
        constraintsChain.pin(on: superview, attribute: a1, of: view, to: a2, of: v2, r: r, c: c, m: m)
        return Constraint(view: view, superview: superview, constraintsChain: constraintsChain, constraint: constraintsChain.constraints.last)
    }
    
    public func width(c: CGFloat, r: NSLayoutConstraint.Relation = .equal, m: CGFloat = 1) -> Constraint {
        return self
            .pin(.width, to: .width, of: nil, r: r, c: c, m: m)
    }
    
    public func height(c: CGFloat, r: NSLayoutConstraint.Relation = .equal, m: CGFloat = 1) -> Constraint {
        return self
            .pin(.height, to: .height, of: nil, r: r, c: c, m: m)
    }
    
    public func size(to size: CGSize, r: NSLayoutConstraint.Relation = .equal, m: CGFloat = 1) -> Constraint {
        return self
            .width(c: size.width, r: r, m: m)
            .height(c: size.height, r: r, m: m)
    }
    
    public func size(to size: (width: CGFloat, height: CGFloat), r: NSLayoutConstraint.Relation = .equal, m: CGFloat = 1) -> Constraint {
        return self
            .width(c: size.width, r: r, m: m)
            .height(c: size.height, r: r, m: m)
    }
    
    public func size(width: CGFloat, height: CGFloat, r: NSLayoutConstraint.Relation = .equal, m: CGFloat = 1) -> Constraint {
        return self
            .width(c: width, r: r, m: m)
            .height(c: height, r: r, m: m)
    }
    
    public func makeSquare() -> Constraint {
        return self.pin(.width, to: .height, of: view)
    }
    
    public func square(to side: CGFloat, r: NSLayoutConstraint.Relation = .equal, m: CGFloat = 1) -> Constraint {
        return size(to: CGSize(width: side, height: side), r: r, m: m)
    }
    
    public func centerX(in p: UIView? = nil, c: CGFloat = 0, m: CGFloat = 1) -> Constraint {
        return self
            .pin(.centerX, to: .centerX, of: p ?? superview, r: .equal, c: c, m: m)
    }
    
    public func centerY(in p: UIView? = nil, c: CGFloat = 0, m: CGFloat = 1) -> Constraint {
        return self
            .pin(.centerY, to: .centerY, of: p ?? superview, r: .equal, c: c, m: m)
    }
    
    public func center(in p: UIView? = nil, c: (x: CGFloat, y: CGFloat) = (0, 0)) -> Constraint {
        return self
            .centerX(in: p, c: c.x)
            .centerY(in: p, c: c.y)
    }
    
    public func inset(insets: UIEdgeInsets, r: NSLayoutConstraint.Relation = .equal) -> Constraint {
        var rightBottomR = r
        
        if r == .greaterThanOrEqual {
            rightBottomR = .lessThanOrEqual
        } else if r == .lessThanOrEqual {
            rightBottomR = .greaterThanOrEqual
        }
        
        return self
            .pin(.left, to: .left, of: superview, r: r, c: insets.left)
            .pin(.right, to: .right, of: superview, r: rightBottomR, c: -insets.right)
            .pin(.top, to: .top, of: superview, r: r, c: insets.top)
            .pin(.bottom, to: .bottom, of: superview, r: rightBottomR, c: -insets.bottom)
    }
    
    public func pin(_ edges: Edge..., r: NSLayoutConstraint.Relation = .equal, c: CGFloat = 0) -> Constraint {
        guard !edges.isEmpty else {
            return inset(insets: UIEdgeInsets(top: c, left: c, bottom: c, right: c), r: r)
        }
        
        var rightBottomR = r
        
        if r == .greaterThanOrEqual {
            rightBottomR = .lessThanOrEqual
        } else if r == .lessThanOrEqual {
            rightBottomR = .greaterThanOrEqual
        }
        
        return edges.set.reduce(self) {
            switch $1 {
            case .left:
                return $0.pin(.left, to: .left, of: superview, r: r, c: c)
            case .top:
                return $0.pin(.top, to: .top, of: superview, r: r, c: c)
            case .right:
                return $0.pin(.right, to: .right, of: superview, r: rightBottomR, c: -c)
            case .bottom:
                return $0.pin(.bottom, to: .bottom, of: superview, r: rightBottomR, c: -c)
            }
        }
    }
    
    public enum Edge {
        case left, top, right, bottom
    }
    
    public func frame(_ frame: CGRect) -> Constraint {
        return self
            .size(to: frame.size)
            .pin(.left, to: .left, of: superview, c: frame.origin.x)
            .pin(.top, to: .top, of: superview, c: frame.origin.y)
    }
}

extension Array where Element: Hashable {
    var set: Set<Element> {
        return Set(self)
    }
}
