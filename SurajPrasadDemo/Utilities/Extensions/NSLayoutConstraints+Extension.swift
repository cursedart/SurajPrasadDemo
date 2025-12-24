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
}

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

// MARK: UsesAutoLayout

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
