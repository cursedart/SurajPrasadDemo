//
//  HoldingTVC.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import UIKit

final class HoldingTVC: UITableViewCell {

    static let identifier = "HoldingTVC"

    private let symbolLabel = UILabel()
    private let tagLabel = UILabel()
    private let ltpLabel = UILabel()
    private let netQtyLabel = UILabel()
    private let pnlLabel = UILabel()
    private let separator = UIView()

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        selectionStyle = .none

        symbolLabel.font = .boldSystemFont(ofSize: 16)
        symbolLabel.textColor = .black

        tagLabel.font = .systemFont(ofSize: 11)
        tagLabel.textColor = .darkGray
        tagLabel.backgroundColor = UIColor(white: 0.9, alpha: 1)
        tagLabel.layer.cornerRadius = 4
        tagLabel.clipsToBounds = true
        tagLabel.textAlignment = .center

        ltpLabel.font = .systemFont(ofSize: 14)
        ltpLabel.textAlignment = .right

        netQtyLabel.font = .systemFont(ofSize: 13)
        netQtyLabel.textColor = .gray

        pnlLabel.font = .boldSystemFont(ofSize: 14)
        pnlLabel.textAlignment = .right

        separator.backgroundColor = UIColor(white: 0.9, alpha: 1)

        [symbolLabel, tagLabel, ltpLabel, netQtyLabel, pnlLabel, separator]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview($0)
            }

        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            tagLabel.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 8),
            tagLabel.centerYAnchor.constraint(equalTo: symbolLabel.centerYAnchor),
            tagLabel.widthAnchor.constraint(equalToConstant: 80),
            tagLabel.heightAnchor.constraint(equalToConstant: 18),

            ltpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ltpLabel.centerYAnchor.constraint(equalTo: symbolLabel.centerYAnchor),

            netQtyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            netQtyLabel.leadingAnchor.constraint(equalTo: symbolLabel.leadingAnchor),

            pnlLabel.trailingAnchor.constraint(equalTo: ltpLabel.trailingAnchor),
            pnlLabel.centerYAnchor.constraint(equalTo: netQtyLabel.centerYAnchor),

            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    func configure(with holding: Holding) {
        symbolLabel.text = holding.symbol
        ltpLabel.text = "LTP: \(holding.safeLTP.asCurrency())"
        netQtyLabel.text = "NET QTY: \(holding.safeQuantity)"
        pnlLabel.text = "P&L: \(holding.profitOrLoss.asCurrency())"
        pnlLabel.textColor = holding.isProfit ? .systemGreen : .systemRed

//        if let tag = holding.tag {
//            tagLabel.isHidden = false
//            tagLabel.text = " \(tag) "
//        } else {
//            tagLabel.isHidden = true
//        }
    }
}
