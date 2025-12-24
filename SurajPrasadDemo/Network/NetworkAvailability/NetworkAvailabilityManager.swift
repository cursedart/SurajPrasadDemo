//
//  NetworkMontior.swift
//  SurajPrasadDemo
//
//  Created by Mobcoder Technologies Private Limited on 24/12/25.
//

import Foundation
import Network

final class NetworkAvailabilityManager: NetworkAvailabilityProviding {

    static let shared = NetworkAvailabilityManager()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkAvailabilityMonitor")

    private(set) var isConnected: Bool = true

    var onStatusChange: ((Bool) -> Void)?

    private init() {}

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            self?.isConnected = connected

            DispatchQueue.main.async {
                self?.onStatusChange?(connected)
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
