//
//  Untitled 2.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/17.
//

import UIKit
import Foundation

class DeviceDataManager: NSObject {

    struct RoughlyData {
        let falls: String
        let typically: String
        let half: String
        
        static var current: RoughlyData {
            RoughlyData(
                falls: UIDevice.current.systemVersion,
                typically: "iPhone",
                half: CommonParaConfig.getDeviceModel()
            )
        }
        
        func toJson() -> [String: [String: String]] {
            return ["roughly": ["falls": falls,
                              "typically": typically,
                              "half": half]]
        }
    }
    
    struct AchievedData {
        let quality: Int
        let midway: Int
        
        static var current: AchievedData {
            UIDevice.current.isBatteryMonitoringEnabled = true
            let batteryLevel = Int(UIDevice.current.batteryLevel * 100)
            let isCharging = (UIDevice.current.batteryState == .charging ||
                             UIDevice.current.batteryState == .full) ? 1 : 0
            
            return AchievedData(
                quality: batteryLevel,
                midway: isCharging
            )
        }
        
        func toJson() -> [String: [String: Int]] {
            return ["achieved": ["quality": quality,
                                "midway": midway]]
        }
    }
    
    struct AdjacentData {
        let labs: String
        let tabu: String
        let turn: String
        let bell: String
        let build: String
        
        static var current: AdjacentData {
            AdjacentData(
                labs: NSTimeZone.system.abbreviation() ?? "",
                tabu: DeviceIdentifierConfig.getDeviceIdentifier(),
                turn: Locale.preferredLanguages.first ?? "en_US",
                bell: SaveCellManager.getType(),
                build: DeviceIdentifierConfig.getIDFA()
            )
        }
        
        func toJson() -> [String: [String: String]] {
            return ["adjacent": ["labs": labs,
                               "tabu": tabu,
                               "turn": turn,
                               "bell": bell,
                               "build": build]]
        }
    }
    
    struct RemovedData {
        let restricting: String
        let substantial: String
        
        static var current: RemovedData {
            RemovedData(
                restricting: String(Self.isSimulator ? 1 : 0),
                substantial: String(Self.isJailbroken ? 1 : 0)
            )
        }
        
        private static var isSimulator: Bool {
            #if targetEnvironment(simulator)
            return true
            #else
            return false
            #endif
        }
        
        private static var isJailbroken: Bool {
            #if targetEnvironment(simulator)
            return false
            #endif
            
            let jailbreakPaths = [
                "/Applications/Cydia.app",
                "/Library/MobileSubstrate/MobileSubstrate.dylib",
                "/usr/sbin/sshd",
                "/bin/bash",
                "/etc/apt"
            ]
            
            for path in jailbreakPaths {
                if FileManager.default.fileExists(atPath: path) {
                    return true
                }
            }
            
            let testPath = "/private/jb_test.txt"
            do {
                try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
                try FileManager.default.removeItem(atPath: testPath)
                return true
            } catch {
                return false
            }
        }
        
        func toJson() -> [String: [String: String]] {
            return ["removed": ["restricting": restricting,
                              "substantial": substantial]]
        }
    }
    
    static func getAllDataAsJson() -> [String: Any] {
        return [
            "roughly": RoughlyData.current.toJson()["roughly"]!,
            "achieved": AchievedData.current.toJson()["achieved"]!,
            "adjacent": AdjacentData.current.toJson()["adjacent"]!,
            "removed": RemovedData.current.toJson()["removed"]!
        ]
    }
}
