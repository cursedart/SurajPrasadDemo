//
//  Endpoint.swift
//  SurajPrasadDemo
//
//  Created by Mobcoder Technologies Private Limited on 24/12/25.
//

import Foundation

enum Endpoint {

    case portfolio

    /// API Path
    var path: String {
        switch self {
        case .portfolio:
            return "35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
        }
    }

    /// HTTP Method
    var method: HTTPMethod {
        switch self {
        case .portfolio:
            return .get
        }
    }
}
