//
//  NetworkMonitor.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import Foundation
import Alamofire

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let reachability = NetworkReachabilityManager()
    
    var onStatusChanged: ((Bool) -> Void)?
    
    var isConnected: Bool {
        return reachability?.isReachable ?? false
    }
    
    func startMonitoring(onStatusChanged: ((Bool) -> Void)? = nil) {
        self.onStatusChanged = onStatusChanged
        
        reachability?.startListening(onQueue: .main) { [weak self] status in
            let isConnected: Bool
            
            switch status {
            case .reachable(.cellular):
                isConnected = true
            case .reachable(.ethernetOrWiFi):
                isConnected = true
            case .notReachable:
                isConnected = false
            case .unknown:
                isConnected = false
            }
            
            self?.onStatusChanged?(isConnected)
        }
    }
    
    func stopMonitoring() {
        reachability?.stopListening()
        onStatusChanged = nil
    }
}
