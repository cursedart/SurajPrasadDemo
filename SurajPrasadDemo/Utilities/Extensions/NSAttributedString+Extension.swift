//
//  NSAttributedString+Extension.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import UIKit

extension NSAttributedString {

    static func labelValue(
        title: String,
        value: String,
        titleFont: UIFont = .systemFont(ofSize: 11, weight: .regular),
        valueFont: UIFont = .systemFont(ofSize: 13, weight: .medium),
        titleColor: UIColor = .systemGray,
        valueColor: UIColor = .black,
        separator: String = ": ") -> NSAttributedString {

        let result = NSMutableAttributedString()

        let titleText = NSAttributedString(
            string: "\(title)\(separator)",
            attributes: [
                .font: titleFont,
                .foregroundColor: titleColor
            ]
        )

        let valueText = NSAttributedString(
            string: value,
            attributes: [
                .font: valueFont,
                .foregroundColor: valueColor
            ]
        )

        result.append(titleText)
        result.append(valueText)

        return result
    }
}
