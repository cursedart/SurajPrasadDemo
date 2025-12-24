//
//  Double+Extension.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation

extension Double {

    func asCurrency(locale: Locale = .current, minimumFractionDigits: Int = 2, maximumFractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits

        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
