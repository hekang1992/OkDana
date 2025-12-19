//
//  WiFiManager.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/17.
//

import UIKit
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

class WiFiManager: NSObject {
    
    struct WiFiInfo: Codable {
        let introduced: Introduced
        
        struct Introduced: Codable {
            let original: String  // mac
            let concurrent: String  // name
            
            init() {
                self.original = ""
                self.concurrent = ""
            }
            
            init(original: String, concurrent: String) {
                self.original = original
                self.concurrent = concurrent
            }
        }
        
        init() {
            self.introduced = Introduced()
        }
        
        init(introduced: Introduced) {
            self.introduced = introduced
        }
    }
    
    func getCurrentWiFiInfo() async -> WiFiInfo {
        if #available(iOS 14.0, *) {
            return await withCheckedContinuation { continuation in
                NEHotspotNetwork.fetchCurrent { hotspotNetwork in
                    if let network = hotspotNetwork {
                        let wifiInfo = WiFiInfo(
                            introduced: WiFiInfo.Introduced(
                                original: network.bssid,
                                concurrent: network.ssid
                            )
                        )
                        continuation.resume(returning: wifiInfo)
                    } else {
                        continuation.resume(returning: WiFiInfo())
                    }
                }
            }
        } else {
            return getWiFiInfoFromCaptiveNetwork()
        }
    }
    
    private func getWiFiInfoFromCaptiveNetwork() -> WiFiInfo {
        guard let interfaces = CNCopySupportedInterfaces() as? [String] else {
            return WiFiInfo()
        }
        
        for interface in interfaces {
            guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: Any] else {
                continue
            }
            
            if let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String,
               let bssid = interfaceInfo[kCNNetworkInfoKeyBSSID as String] as? String {
                return WiFiInfo(
                    introduced: WiFiInfo.Introduced(
                        original: bssid,
                        concurrent: ssid
                    )
                )
            }
        }
        
        return WiFiInfo()
    }

}
