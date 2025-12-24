//
//  PortfolioViewC.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import UIKit
import Combine

final class PortfolioViewC: UIViewController {
    
    // MARK: UI Components

    private let tableView: UITableView = {
        @UsesAutoLayout
        var tv = UITableView(frame: .zero, style: .plain)
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.register(HoldingTVC.self, forCellReuseIdentifier: HoldingTVC.identifier)
        return tv
    }()
    
    private var stateView: PortfolioStateView = {
        @UsesAutoLayout
        var view = PortfolioStateView()
        view.isHidden = true
        return view
    }()
    
    // MARK: - Properties
    
    private var viewModel: PortfolioViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    private let summaryView = PortfolioSummaryDropdownView()
    private let refreshControl = UIRefreshControl()

    private let collapsedInset: CGFloat = 80
    private let expandedInset: CGFloat = 210
    private var isSummaryExpanded: Bool = false

    // MARK: - View Life Cycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
    }
    
    // MARK: - Init Function

    init?(viewModel: PortfolioViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Notifications Methods

    // MARK: - Private Methods
    
    private func initialSetup() {
        self.view.backgroundColor = .white
        self.title = "Portfolio"

        self.setupTableView()
        self.setupBottomView()
        self.setupPortfolioState()
        
        self.summaryView.isHidden = true

        self.updateTableInsets(isExpanded: false)

        self.viewModel.fetchHoldings(isRefreshing: false)
        self.bindingsSetup()
    }
    
    private func setupBottomView() {
        self.view.addSubview(self.summaryView)
        
        self.summaryView.delegate = self

        NSLayoutConstraint.activate([
            self.summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            self.summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            self.summaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupPortfolioState() {
        view.addSubview(self.stateView)

        NSLayoutConstraint.activate([
            self.stateView.topAnchor.constraint(equalTo: view.topAnchor),
            self.stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func showLoadingState() {
        self.tableView.isHidden = true
        self.stateView.update(state: .loading)
    }

    private func hideLoadingState() {
        self.stateView.update(state: .hidden)
        self.tableView.isHidden = false
    }
    
    private func showOfflineState() {
        self.tableView.isHidden = true
        self.stateView.update(state: .offline { [weak self] in
            guard let self else { return }
            
            self.hideLoadingState()
            self.viewModel.fetchHoldings(isRefreshing: false)
        })
    }

    private func setupTableView() {
        self.view.addSubview(self.tableView)

        self.tableView.dataSource = self
        self.tableView.delegate = self

        // Add Pull to Refresh
        self.refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func handleRefresh() {
        self.viewModel.fetchHoldings(isRefreshing: false)
    }
    
    private func bindingsSetup() {
        self.bindViewToViewModel()
        self.bindViewModelToView()
    }

    private func bindViewToViewModel() {
    }

    private func bindViewModelToView() {

        self.viewModel.loadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }

                if isLoading {
                    self.summaryView.isHidden = true
                    self.showLoadingState()
                } else {
                    self.summaryView.isHidden = self.viewModel.holdings.isEmpty
                    self.hideLoadingState()
                    
                    if self.viewModel.holdings.isEmpty {
                        self.showOfflineState()
                    }
                }
            }
            .store(in: &self.cancellables)

        Publishers.CombineLatest(self.viewModel.holdingsPublisher,
                                 self.viewModel.portfolioSummaryPublisher)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] holdings, summary in
            guard let self else { return }
            guard let summary else { return }

            self.updateSummaryView(with: summary)
            self.summaryView.isHidden = self.viewModel.holdings.isEmpty
            self.tableView.reloadData()

            // Stop refresh animation
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
        .store(in: &self.cancellables)
    }
    
    private func updateSummaryView(with summary: PortfolioSummary) {
        self.summaryView.updateSummary(
            currentValue: summary.totalCurrentValue.asCurrency(),
            totalInvestment: summary.totalInvestment.asCurrency(),
            todaysPNL: summary.todaysProfitOrLoss.asCurrency(),
            isTodayProfit: summary.todaysProfitOrLoss >= 0,
            totalPNL: summary.overallProfitOrLoss.asCurrency(),
            isTotalProfit: summary.overallProfitOrLoss >= 0
        )
    }
    
    private func updateTableInsets(isExpanded: Bool, animated: Bool = true) {
        let bottomInset = isExpanded ? expandedInset : collapsedInset

        let updates = {
            self.tableView.contentInset.bottom = bottomInset
            self.tableView.verticalScrollIndicatorInsets.bottom = bottomInset
        }

        if animated {
            UIView.animate(withDuration: 0.25, animations: updates)
        } else {
            updates()
        }
    }

    func setSummaryExpanded(_ expanded: Bool) {
        guard expanded != isSummaryExpanded else { return }
        isSummaryExpanded = expanded
        updateTableInsets(isExpanded: expanded)
    }
}

// MARK: UITableViewDataSource

extension PortfolioViewC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.holdings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HoldingTVC.identifier, for: indexPath) as? HoldingTVC {
            cell.configure(with: self.viewModel.holdings[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: UITableViewDelegate

extension PortfolioViewC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92.0
    }
}

// MARK: - PortfolioSummaryExpandableDelegate

extension PortfolioViewC: PortfolioSummaryExpandableDelegate {
    func summaryViewDidChangeExpansion(isExpanded: Bool) {
        self.updateTableInsets(isExpanded: isExpanded)
    }
}
