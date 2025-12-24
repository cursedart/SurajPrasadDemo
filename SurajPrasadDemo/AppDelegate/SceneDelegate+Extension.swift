//
//  SceneDelegate+Extension.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import UIKit

extension SceneDelegate {
    
    func moveToPortfolio(windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let networkService = NetworkManager.shared
        let localDataSource = CoreDataHoldingsStore()
        let repository = PortfolioRepositoryImpl(remote: networkService, local: localDataSource)
        let viewModel = PortfolioViewModel(repository: repository)
        let portfolioVC = PortfolioViewC(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: portfolioVC!)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
