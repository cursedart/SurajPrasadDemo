//
//  HoldingsLocalDataSource.swift
//  SurajPrasadDemo
//
//  Created by Mobcoder Technologies Private Limited on 24/12/25.
//

import Foundation

protocol HoldingsLocalDataSource {
    func saveHoldings(_ holdings: [Holding])
    func fetchHoldings() -> [Holding]
    func clearHoldings()
}
