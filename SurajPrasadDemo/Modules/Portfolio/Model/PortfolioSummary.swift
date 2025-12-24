//
//  PortfolioSummary.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation

struct PortfolioSummary {
    let totalCurrentValue: Double
    let totalInvestment: Double
    let overallProfitOrLoss: Double
    let todaysProfitOrLoss: Double
    let profitOrLossPercentage: Double
}

struct PortfolioSummaryViewData {
    let currentValueText: String
    let totalInvestmentText: String

    let todaysPNLText: String
    let isTodayProfit: Bool

    let totalPNLText: String
    let isTotalProfit: Bool

    let profitOrLossPercentage: Double
}
