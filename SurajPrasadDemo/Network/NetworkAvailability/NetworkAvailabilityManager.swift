//
//  NetworkMontior.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import Network

final class NetworkAvailabilityManager: NetworkAvailabilityProviding {

    static let shared = NetworkAvailabilityManager()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkAvailabilityMonitor")

    private(set) var isConnected: Bool = false

    var onStatusChange: ((Bool) -> Void)?

    private init() {}

    func startMonitoring() {
        self.monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }

            let connected = path.status == .satisfied

            guard self.isConnected != connected else { return }

            self.isConnected = connected

            DispatchQueue.main.async {
                self.onStatusChange?(connected)
            }
        }

        self.monitor.start(queue: queue)
    }

    func stopMonitoring() {
        self.monitor.cancel()
    }
}
