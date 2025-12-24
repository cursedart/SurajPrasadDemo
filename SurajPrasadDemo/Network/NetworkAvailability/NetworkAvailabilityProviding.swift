//
//  NetworkAvailabilityProviding.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation

protocol NetworkAvailabilityProviding: AnyObject {
    var isConnected: Bool { get }
    var onStatusChange: ((Bool) -> Void)? { get set }
    func startMonitoring()
    func stopMonitoring()
}
