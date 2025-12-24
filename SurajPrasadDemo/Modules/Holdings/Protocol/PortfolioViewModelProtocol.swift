//
//  PortfolioSummaryViewModelProtocol.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import Combine

protocol PortfolioViewModelProtocol {
    
    init(repository: PortfolioRepository)
    
    var holdings: [Holding] { get }
    var fetchedholdings: PassthroughSubject<Result<Bool, Error>, Never> { get }
    
    func getHoldings()
}
