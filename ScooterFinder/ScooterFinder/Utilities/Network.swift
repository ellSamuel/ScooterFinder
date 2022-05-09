//
//  Network.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 09/05/2022.
//

import Network

protocol CanDetectNetworkChanges {
    func didChanged(networkStatus online: Bool)
}

/// Keep in mind it doesn't work properly in the Simulator.
class Network {
    private static let shared = Network()
    static var isOnline: Bool { shared.isOnline }
    
    /// Delegate responsible for receiving callbacks about network changes
    static var mapDelegate: CanDetectNetworkChanges? { didSet {
        mapDelegate?.didChanged(networkStatus: isOnline)
    } }
    
    private let monitor = NWPathMonitor()
    private var isOnline: Bool = true
    
    init() {
        monitor.pathUpdateHandler = { [self] path in
            let newValue = (path.status == .satisfied)
            guard isOnline != newValue else { return }
            isOnline = newValue
            DispatchQueue.main.async { [self] in
                Network.mapDelegate?.didChanged(networkStatus: isOnline)
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
