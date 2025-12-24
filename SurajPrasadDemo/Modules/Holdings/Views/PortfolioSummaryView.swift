//
//  PortfolioSummaryView.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import UIKit

final class PortfolioSummaryDropdownView: UIView {

    // MARK: - State
    private var isExpanded = false

    private let collapsedHeight: CGFloat = 56
    private let expandedHeight: CGFloat = 180

    private var heightConstraint: NSLayoutConstraint!

    // MARK: - Expandable Content Stack
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 18
        stack.alpha = 0
        stack.isHidden = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Toggle Row (Always Visible)
    private let toggleRow: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let toggleTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Profit & Loss*"
        l.font = .systemFont(ofSize: 14)
        l.textColor = .darkGray
        return l
    }()

    private let toggleValueLabel: UILabel = {
        let l = UILabel()
        l.text = "-₹697.06 (2.44%)"
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.textAlignment = .right
        return l
    }()

    private let toggleArrow: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.down"))
        iv.tintColor = .darkGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 14
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        buildRows()
        
        toggleArrow.widthAnchor.constraint(equalToConstant: 14).isActive = true

        toggleRow.addArrangedSubview(toggleTitleLabel)
        toggleRow.addArrangedSubview(toggleArrow)
        toggleRow.addArrangedSubview(UIView())
        toggleRow.addArrangedSubview(toggleValueLabel)

        addSubview(contentStack)
        addSubview(toggleRow)

        heightConstraint = heightAnchor.constraint(equalToConstant: collapsedHeight)
        heightConstraint.isActive = true

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            toggleRow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            toggleRow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            toggleRow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        ])
    }

    // MARK: - Build Rows
    private func buildRows() {
        clearStackView(contentStack)

        addRow(title: "Current value*", value: "₹ 27,893.65")
        addRow(title: "Total investment*", value: "₹ 28,590.71")
        addRow(title: "Today’s Profit & Loss*", value: "-₹235.65", isProfit: false)

        let divider = UIView()
        divider.backgroundColor = UIColor(white: 0.9, alpha: 1)
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        contentStack.addArrangedSubview(divider)
    }

    // MARK: - Stack Cleanup (CRITICAL FIX)
    private func clearStackView(_ stack: UIStackView) {
        stack.arrangedSubviews.forEach {
            stack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    // MARK: - Row Builder
    
    private func addRow(title: String, value: String, isProfit: Bool = true) {
        let left = UILabel()
        left.text = title
        left.font = .systemFont(ofSize: 14)
        left.textColor = .darkGray

        let right = UILabel()
        right.text = value
        right.font = .systemFont(ofSize: 14, weight: .semibold)
        right.textAlignment = .right
        right.textColor = isProfit ? .label : .systemRed

        let row = UIStackView(arrangedSubviews: [left, right])
        row.axis = .horizontal
        row.distribution = .equalSpacing

        contentStack.addArrangedSubview(row)
    }

    // MARK: - Gesture
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggle))
        addGestureRecognizer(tap)
    }

    // MARK: - Expand / Collapse
    
    @objc private func toggle() {
        isExpanded.toggle()
        isUserInteractionEnabled = false

        if isExpanded {
            // EXPAND
            contentStack.isHidden = false
            contentStack.alpha = 0
            contentStack.transform = CGAffineTransform(translationX: 0, y: -8)

            heightConstraint.constant = expandedHeight

            UIView.animate(withDuration: 0.32,
                           delay: 0,
                           options: [.curveEaseOut]) {
                self.contentStack.alpha = 1
                self.contentStack.transform = .identity
                self.toggleArrow.transform = CGAffineTransform(rotationAngle: .pi)
                self.superview?.layoutIfNeeded()
            } completion: { _ in
                self.isUserInteractionEnabled = true
            }

        } else {
            // COLLAPSE
            UIView.animate(withDuration: 0.22,
                           delay: 0,
                           options: [.curveEaseIn]) {
                self.contentStack.alpha = 0
                self.contentStack.transform = CGAffineTransform(translationX: 0, y: -6)
                self.toggleArrow.transform = .identity
            } completion: { _ in
                self.contentStack.isHidden = true
                self.heightConstraint.constant = self.collapsedHeight

                UIView.animate(withDuration: 0.22,
                               delay: 0,
                               options: [.curveEaseOut]) {
                    self.superview?.layoutIfNeeded()
                } completion: { _ in
                    self.isUserInteractionEnabled = true
                }
            }
        }
    }
}
