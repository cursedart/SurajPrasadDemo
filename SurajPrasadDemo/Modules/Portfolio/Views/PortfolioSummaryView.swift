//
//  PortfolioSummaryView.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import UIKit

protocol PortfolioSummaryExpandableDelegate: AnyObject {
    func summaryViewDidChangeExpansion(isExpanded: Bool)
}

final class PortfolioSummaryDropdownView: UIView {

    // MARK: - Properties
    
    private var isExpanded = false

    private let collapsedHeight: CGFloat = 56
    private let expandedHeight: CGFloat = 180

    private var heightConstraint: NSLayoutConstraint!
    
    private let currentValueLabel = UILabel()
    private let totalInvestmentLabel = UILabel()
    private let todaysPNLLabel = UILabel()
    
    weak var delegate: PortfolioSummaryExpandableDelegate?

    // MARK: - UI Components

    private let contentStack: UIStackView = {
        @UsesAutoLayout
        var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 18
        stack.alpha = 0
        stack.isHidden = true
        return stack
    }()

    private let toggleRow: UIStackView = {
        @UsesAutoLayout
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()

    private let toggleTitleLabel: UILabel = {
        @UsesAutoLayout
        var label = UILabel()
        label.text = "Profit & Loss*"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()

    private let toggleValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        return label
    }()

    private let toggleArrow: UIImageView = {
        @UsesAutoLayout
        var imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = .darkGray
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialSetup()
        self.setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Method

    private func initialSetup() {
        self.setupAppearance()
        self.setupHierarchy()
        self.setupConstraints()
        self.buildRows()
    }

    private func setupAppearance() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 14
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupHierarchy() {
        self.toggleArrow.widthAnchor.constraint(equalToConstant: 14).isActive = true

        self.toggleRow.addArrangedSubview(self.toggleTitleLabel)
        self.toggleRow.addArrangedSubview(self.toggleArrow)
        self.toggleRow.addArrangedSubview(UIView())
        self.toggleRow.addArrangedSubview(self.toggleValueLabel)

        self.addSubview(self.contentStack)
        self.addSubview(self.toggleRow)
    }

    private func setupConstraints() {
        self.heightConstraint = self.heightAnchor.constraint(equalToConstant: self.collapsedHeight)
        self.heightConstraint.isActive = true

        NSLayoutConstraint.activate([
            self.contentStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.contentStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.contentStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            self.toggleRow.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.toggleRow.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.toggleRow.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14)
        ])
    }

    // MARK: - Build Rows

    private func buildRows() {
        self.clearStackView(self.contentStack)

        self.addRow(title: "Current value*", valueLabel: self.currentValueLabel)
        self.addRow(title: "Total investment*", valueLabel: self.totalInvestmentLabel)
        self.addRow(title: "Today’s Profit & Loss*", valueLabel: self.todaysPNLLabel, isProfit: false)

        let divider = UIView()
        divider.backgroundColor = UIColor(white: 0.9, alpha: 1)
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true

        self.contentStack.addArrangedSubview(divider)
    }

    private func clearStackView(_ stack: UIStackView) {
        stack.arrangedSubviews.forEach {
            stack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    private func addRow(title: String, valueLabel: UILabel, isProfit: Bool = true) {
        let leftLabel = UILabel()
        leftLabel.text = title
        leftLabel.font = .systemFont(ofSize: 14)
        leftLabel.textColor = .darkGray

        valueLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        valueLabel.textAlignment = .right
        valueLabel.textColor = isProfit ? .label : .systemRed

        let row = UIStackView(arrangedSubviews: [leftLabel, valueLabel])
        row.axis = .horizontal
        row.distribution = .equalSpacing

        self.contentStack.addArrangedSubview(row)
    }

    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.toggle))
        self.addGestureRecognizer(tap)
    }
    
    // MARK: Internal Method
    
    func updateSummary(with data: PortfolioSummaryViewData) {
        self.currentValueLabel.text = data.currentValueText
        self.totalInvestmentLabel.text = data.totalInvestmentText

        self.todaysPNLLabel.text = data.todaysPNLText
        self.todaysPNLLabel.textColor = data.isTodayProfit ? .systemGreen : .systemRed

        let formattedPercentage = String(format: "%.2f%%", data.profitOrLossPercentage)
        self.toggleValueLabel.text = "\(data.totalPNLText) (\(formattedPercentage))"
        self.toggleValueLabel.textColor = data.isTotalProfit ? .systemGreen : .systemRed
    }

    // MARK: - Expand / Collapse

    @objc private func toggle() {
        self.isExpanded.toggle()
        self.delegate?.summaryViewDidChangeExpansion(isExpanded: isExpanded)
        self.isUserInteractionEnabled = false

        if self.isExpanded {
            self.contentStack.isHidden = false
            self.contentStack.alpha = 0
            self.contentStack.transform = CGAffineTransform(translationX: 0, y: -8)
            self.heightConstraint.constant = self.expandedHeight

            UIView.animate(
                withDuration: 0.32,
                delay: 0,
                options: [.curveEaseOut]
            ) {
                self.contentStack.alpha = 1
                self.contentStack.transform = .identity
                self.toggleArrow.transform = CGAffineTransform(rotationAngle: .pi)
                self.superview?.layoutIfNeeded()
            } completion: { _ in
                self.isUserInteractionEnabled = true
            }

        } else {
            UIView.animate(
                withDuration: 0.22,
                delay: 0,
                options: [.curveEaseIn]
            ) {
                self.contentStack.alpha = 0
                self.contentStack.transform = CGAffineTransform(translationX: 0, y: -6)
                self.toggleArrow.transform = .identity
            } completion: { _ in
                self.contentStack.isHidden = true
                self.heightConstraint.constant = self.collapsedHeight

                UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseOut]) {
                    self.superview?.layoutIfNeeded()
                } completion: { _ in
                    self.isUserInteractionEnabled = true
                }
            }
        }
    }
}
