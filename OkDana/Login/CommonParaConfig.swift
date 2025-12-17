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
        parameters[Keys.deviceIdentifier] = DeviceIdentifierManager.getDeviceIdentifier()
        parameters[Keys.systemVersion] = UIDevice.current.systemVersion
        parameters[Keys.authToken] = LoginConfig.currentToken ?? ""
        parameters[Keys.idfa] = DeviceIdentifierManager.getIDFA()
        parameters[Keys.customKey] = UserDefaults.standard.string(forKey: "reflecting") ?? ""
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

class DeviceIdentifierManager {
    
    static func getIDFA() -> String {
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        if idfa == "00000000-0000-0000-0000-000000000000" {
            return ""
        }
        return idfa
    }
    
    // MARK: - Keychain Keys
    private struct KeychainKeys {
        static let service = Bundle.main.bundleIdentifier ?? "com.app.okApp"
        static let account = "device_idfv"
    }
    
    // MARK: - IDFV Storage & Retrieval
    static func getOrCreateIDFV() -> String? {
        if let savedIDFV = retrieveIDFVFromKeychain() {
            return savedIDFV
        }
        
        guard let newIDFV = generateIDFV() else {
            return nil
        }
        
        if saveIDFVToKeychain(newIDFV) {
            return newIDFV
        }
        
        return newIDFV
    }
    
    static func retrieveIDFVFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainKeys.service,
            kSecAttrAccount as String: KeychainKeys.account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess,
              let data = dataTypeRef as? Data,
              let idfv = String(data: data, encoding: .utf8),
              !idfv.isEmpty else {
            return nil
        }
        
        return idfv
    }
    
    @discardableResult
    static func saveIDFVToKeychain(_ idfv: String) -> Bool {
        guard !idfv.isEmpty,
              let data = idfv.data(using: .utf8) else {
            return false
        }
        
        deleteIDFVFromKeychain()
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainKeys.service,
            kSecAttrAccount as String: KeychainKeys.account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("IDFV saved to keychain successfully")
            return true
        } else {
            print("Failed to save IDFV to keychain: \(status)")
            return false
        }
    }
    
    @discardableResult
    static func deleteIDFVFromKeychain() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: KeychainKeys.service,
            kSecAttrAccount as String: KeychainKeys.account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess || status == errSecItemNotFound {
            print("IDFV removed from keychain successfully")
            return true
        } else {
            print("Failed to remove IDFV from keychain: \(status)")
            return false
        }
    }
    
    // MARK: - Helper Methods
    private static func generateIDFV() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    static func resetIDFV() {
        deleteIDFVFromKeychain()
    }
}

extension DeviceIdentifierManager {
    
    static func getDeviceIdentifier() -> String {
        return getOrCreateIDFV() ?? ""
    }
    
    static var hasSavedIDFV: Bool {
        return retrieveIDFVFromKeychain() != nil
    }
    
    static var currentIDFV: String? {
        return retrieveIDFVFromKeychain() ?? generateIDFV()
    }
}
