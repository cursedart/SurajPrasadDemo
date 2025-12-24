//
//  NSLayoutConstraints+Extension.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 23/12/25.
//

import Foundation
import UIKit

extension UIView {
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
          return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
      }

      var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
          return safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
      }

      var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
          return safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
      }

      var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
          return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
      }

    /// Returns a collection of constraints to anchor the bounds of the current view to the given view.
    ///
    /// - Parameter view: The view to anchor to.
    /// - Returns: The layout constraints needed for this constraint.
    func constraintsForAnchoringTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }
}

/*
 Handling priorities
Once you have to set priorities to your constraints to prevent breaking constraints you might be happy with the following extension:
 */

extension NSLayoutConstraint {
    
    /// Returns the constraint sender with the passed priority.
    ///
    /// - Parameter priority: The priority to be set.
    /// - Returns: The sended constraint adjusted with the new priority.
    func usingPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
}

extension UILayoutPriority {
    
    /// Creates a priority which is almost required, but not 100%.
    static var almostRequired: UILayoutPriority {
        return UILayoutPriority(rawValue: 999)
    }
    
    /// Creates a priority which is not required at all.
    static var notRequired: UILayoutPriority {
        return UILayoutPriority(rawValue: 0)
    }
}

/*
 An Auto Layout Property Wrapper
 Prevent yourself from constantly writing:

 translatesAutoresizingMaskIntoConstraints = false
 By making use of the following Property Wrapper:
 */

@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            configureAutoLayout(for: wrappedValue)
        }
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        configureAutoLayout(for: wrappedValue)
    }
    
    private func configureAutoLayout(for view: T) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}
