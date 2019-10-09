//
//  ConstraintsChain.swift
//  Constraints
//
//  Created by Serhiy Vysotskiy on 12/24/17.
//  Copyright © 2017 Serhiy Vysotskiy. All rights reserved.
//

/// The very engine for constrainting
public final class ConstraintsChain {
    public var constraints: [NSLayoutConstraint] = []
    public init() {}
    
    public static func _setConstantsScale(_ newScale: CGFloat) {
        scale = newScale
    }
    
    deinit {
//        print("DEINIT CONSTRAINTCHAIN")
    }
}

var scale: CGFloat = 1

// MARK: - Basic pin method
extension ConstraintsChain {
    public func pin(on s: UIView, attribute a1: NSLayoutConstraint.Attribute, of v1: UIView, to a2: NSLayoutConstraint.Attribute, of v2: UIView?, r: NSLayoutConstraint.Relation = .equal, c: CGFloat = 0, m: CGFloat = 1) {
        check(v1, on: s)
        v2.map { check($0, on: s) }
        constraints.append(NSLayoutConstraint(item: v1, attribute: a1, relatedBy: r, toItem: v2, attribute: a2, multiplier: m, constant: c * scale))
    }
    
    private func check(_ view: UIView, on superview: UIView) {
        if !(view.superview === superview || view === superview) {
            superview.addSubview(view)
        }
        
        if view !== superview {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

// MARK: - Activate/Deactivate constraints
extension ConstraintsChain {
    public func activate() {
        NSLayoutConstraint.activate(constraints)
    }
    
    public func deactivate() {
        NSLayoutConstraint.deactivate(constraints)
    }
}

// MARK: - Constraint conversion
extension ConstraintsChain {
    public func chain(with other: Constraint) -> Constraint {
        return Constraint(view: other.view, superview: other.superview, constraintsChain: merged(other.constraintsChain), constraint: other.constraint)
    }
    
    public func chain(with view: UIView, on superview: UIView) -> Constraint {
        return Constraint(view: view, superview: superview, constraintsChain: self)
    }
    
    public func merged(_ other: ConstraintsChain) -> ConstraintsChain {
        constraints.append(contentsOf: other.constraints)
        return self
    }
}

// MARK: - Convenience constrainting methods
extension ConstraintsChain {
    public func centerX(on s: UIView, views vs: [UIView], in p: UIView? = nil, c: CGFloat = 0, m: CGFloat = 1) -> ConstraintsChain {
        vs.forEach { view in
            pin(on: s, attribute: .centerX, of: view, to: .centerX, of: p ?? s, r: .equal, c: c, m: m)
        }
        
        return self
    }
    
    public func centerY(on s: UIView, views vs: [UIView], in p: UIView? = nil, c: CGFloat = 0, m: CGFloat = 1) -> ConstraintsChain {
        vs.forEach { view in
            pin(on: s, attribute: .centerY, of: view, to: .centerY, of: p ?? s, r: .equal, c: c, m: m)
        }
        
        return self
    }
    
    public func center(on s: UIView, views vs: [UIView], in p: UIView? = nil, c: CGFloat = 0, m: CGFloat = 1) -> ConstraintsChain {
        return centerX(on: s, views: vs, in: p, c: c, m: m)
            .centerY(on: s, views: vs, in: p, c: c, m: m)
    }
}
