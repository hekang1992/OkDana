//
//  CommonParaConfig.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import UIKit
import AdSupport
import Security

class CommonParaConfig: NSObject {
    
    static func getCommonParameters() -> [String: String] {
        var parameters: [String: String] = [:]
        parameters[Keys.appVersion] = getAppVersion()
        parameters[Keys.deviceModel] = getDeviceModel()
        parameters[Keys.deviceIdentifier] = DeviceIdentifierConfig.getDeviceIdentifier()
        parameters[Keys.systemVersion] = UIDevice.current.systemVersion
        parameters[Keys.authToken] = LoginConfig.currentToken
        parameters[Keys.idfa] = DeviceIdentifierConfig.getIDFA()
        if UIDevice.current.model == "iPad" {
            parameters[Keys.customKey] = "1"
        }else {
            parameters[Keys.customKey] = UserDefaults.standard.string(forKey: "reflecting") ?? ""
        }
        return parameters
    }
    
    private static func getAppVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    static func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        var identifier = ""
        
        for child in machineMirror.children {
            if let value = child.value as? Int8, value != 0 {
                identifier.append(Character(UnicodeScalar(UInt8(value))))
            }
        }
        
        return identifier
    }
    
    private struct Keys {
        static let appVersion = "proven"
        static let deviceModel = "kilometres"
        static let deviceIdentifier = "approximately"
        static let systemVersion = "sweden"
        static let authToken = "alpha"
        static let idfa = "mhz"
        static let customKey = "reflecting"
    }
}

class JSONHelper {
    static func toJSONString(_ dict: [String: Any]) -> String {
        guard JSONSerialization.isValidJSONObject(dict) else {
            return ""
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: [])
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
}

