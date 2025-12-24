//
//  PortfolioStateView.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import UIKit

final class PortfolioStateView: UIView {

    enum State {
        case loading
        case offline(onRetry: () -> Void)
        case hidden
    }

    // MARK: - UI Components

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let retryButton = UIButton(type: .system)

    private var retryAction: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialSetup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func initialSetup() {
        backgroundColor = .systemBackground

        self.imageView.contentMode = .scaleAspectFit
        self.imageView.tintColor = .systemGray
        
        self.titleLabel.font = .boldSystemFont(ofSize: 18)
        self.titleLabel.textAlignment = .center
        
        self.subtitleLabel.font = .systemFont(ofSize: 14)
        self.subtitleLabel.textColor = .secondaryLabel
        self.subtitleLabel.textAlignment = .center
        self.subtitleLabel.numberOfLines = 0
        
        self.retryButton.setTitle("Retry", for: .normal)
        self.retryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        self.retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            self.imageView,
            self.activityIndicator,
            self.titleLabel,
            self.subtitleLabel,
            self.retryButton
        ])

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.imageView.heightAnchor.constraint(equalToConstant: 60),
            self.imageView.widthAnchor.constraint(equalToConstant: 60),

            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
        ])
    }

    func update(state: State) {
        switch state {

        case .loading:
            self.isHidden = false
            self.imageView.isHidden = true
            self.retryButton.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.titleLabel.text = "Loading Portfolio..."
            self.subtitleLabel.text = nil

        case .offline(let onRetry):
            self.isHidden = false
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.imageView.isHidden = false
            self.retryButton.isHidden = false
            self.imageView.image = UIImage(systemName: "wifi.slash")
            self.titleLabel.text = "No Internet Connection"
            self.subtitleLabel.text = "Please check your internet and retry"
            self.retryAction = onRetry

        case .hidden:
            self.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: Selector Actions

    @objc private func retryTapped() {
        self.retryAction?()
    }
}
