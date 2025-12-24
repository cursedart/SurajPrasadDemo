//
//  HoldingTVC.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import UIKit

final class HoldingTVC: UITableViewCell {

    // MARK: - Identifier
    
    static let identifier = "HoldingTVC"

    // MARK: - UI Components

    private let symbolLabel: UILabel = {
        @UsesAutoLayout
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    private let tagLabel: UILabel = {
        @UsesAutoLayout
        var label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.textColor = .darkGray
        label.backgroundColor = UIColor(white: 0.9, alpha: 1)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private let ltpLabel: UILabel = {
        @UsesAutoLayout
        var label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()

    private let netQtyLabel: UILabel = {
        @UsesAutoLayout
        var label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()

    private let pnlLabel: UILabel = {
        @UsesAutoLayout
        var label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()

    private let separatorView: UIView = {
        @UsesAutoLayout
        var view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.symbolLabel.text = ""
        self.ltpLabel.text = ""
        self.netQtyLabel.text = ""
        self.pnlLabel.text = ""
        self.pnlLabel.textColor = .white
    }

    // MARK: - Private methods

    private func initialSetup() {
        self.selectionStyle = .none
        
        self.addSubviews()
        self.setupConstraints()
    }

    private func addSubviews() {
        self.contentView.addSubview(self.symbolLabel)
        self.contentView.addSubview(self.tagLabel)
        self.contentView.addSubview(self.ltpLabel)
        self.contentView.addSubview(self.netQtyLabel)
        self.contentView.addSubview(self.pnlLabel)
        self.contentView.addSubview(self.separatorView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            // Symbol
            self.symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            self.symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            // Tag
            self.tagLabel.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 8),
            self.tagLabel.centerYAnchor.constraint(equalTo: symbolLabel.centerYAnchor),
            self.tagLabel.widthAnchor.constraint(equalToConstant: 80),
            self.tagLabel.heightAnchor.constraint(equalToConstant: 18),

            // LTP
            self.ltpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            self.ltpLabel.centerYAnchor.constraint(equalTo: symbolLabel.centerYAnchor),
            
            // Net Qty
            self.netQtyLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),
            self.netQtyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            // P&L
            self.pnlLabel.trailingAnchor.constraint(equalTo: ltpLabel.trailingAnchor),
            self.pnlLabel.centerYAnchor.constraint(equalTo: netQtyLabel.centerYAnchor),
            
            // Separator
            self.separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            self.separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    // MARK: - Configuration

    func configure(with holding: Holding) {
        self.symbolLabel.text = holding.symbol
        
        self.ltpLabel.attributedText = .labelValue(
            title: "LTP",
            value: "\(holding.safeLTP.asCurrency())"
        )
        
        self.netQtyLabel.attributedText = .labelValue(
            title: "NET QTY",
            value: "\(holding.safeQuantity)"
        )
        
        self.pnlLabel.attributedText = .labelValue(
            title: "P&L",
            value: holding.profitOrLoss.asCurrency(),
            valueColor: holding.isProfit ? .systemGreen : .systemRed
        )
    }
}
