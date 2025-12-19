//
//  NetworkMonitor.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/14.
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
                SaveCellManager.saveType(with: "5G")
            case .reachable(.ethernetOrWiFi):
                isConnected = true
                SaveCellManager.saveType(with: "WIFI")
            case .notReachable:
                isConnected = false
                SaveCellManager.saveType(with: "OTHER")
            case .unknown:
                isConnected = false
                SaveCellManager.saveType(with: "unknown")
            }
            self?.onStatusChanged?(isConnected)
        }
    }
    
    func stopMonitoring() {
        reachability?.stopListening()
        onStatusChanged = nil
    }
}

class SaveCellManager: NSObject {
    
    static func saveType(with type: String) {
        UserDefaults.standard.set(type, forKey: "network")
        UserDefaults.standard.synchronize()
    }
    
    static func getType() -> String {
        let type = UserDefaults.standard.object(forKey: "network") as? String ?? ""
        return type
    }
    
}

struct HTTPProxyInfo {
    
    enum ConnectionStatus: Int {
        case inactive = 0
        case active = 1
    }
    
    static var proxyStatus: ConnectionStatus {
        guard let settings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() as? [String: Any] else {
            return .inactive
        }
        
        let hasHTTPProxy = !(settings["HTTPProxy"] as? String ?? "").isEmpty
        let hasHTTPSProxy = !(settings["HTTPSProxy"] as? String ?? "").isEmpty
        
        return (hasHTTPProxy || hasHTTPSProxy) ? .active : .inactive
    }
    
    static var vpnStatus: ConnectionStatus {
        guard let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
              let scopes = settings["__SCOPED__"] as? [String: Any] else {
            return .inactive
        }
        
        let vpnKeywords = ["tap", "tun", "ppp", "ipsec", "utun"]
        
        return scopes.keys.contains { key in
            vpnKeywords.contains { keyword in
                key.contains(keyword)
            }
        } ? .active : .inactive
    }
}
