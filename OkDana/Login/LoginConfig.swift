//
//  LoginConfig.swift
//  OkDana
//
//  Created by hekang on 2025/12/13.
//

import Foundation

class LoginConfig {
    
    private enum Keys {
        static let phone = "login_phone"
        static let token = "login_token"
        
        static let name = "login_name"
        static let idNumber = "login_idnumber"
        static let dateStr = "login_time"
        
    }
    
    static func save(phone: String, token: String) {
        UserDefaults.standard.set(phone, forKey: Keys.phone)
        UserDefaults.standard.set(token, forKey: Keys.token)
    }
    
    static func saveCardInfo(name: String, idNum: String, time: String) {
        UserDefaults.standard.set(name, forKey: Keys.name)
        UserDefaults.standard.set(idNum, forKey: Keys.idNumber)
        UserDefaults.standard.set(time, forKey: Keys.dateStr)
    }
    
    static func clear() {
        UserDefaults.standard.removeObject(forKey: Keys.phone)
        UserDefaults.standard.removeObject(forKey: Keys.token)
        
        UserDefaults.standard.removeObject(forKey: Keys.name)
        UserDefaults.standard.removeObject(forKey: Keys.idNumber)
        UserDefaults.standard.removeObject(forKey: Keys.dateStr)
    }
    
    static var isLoggedIn: Bool {
        guard let token = UserDefaults.standard.string(forKey: Keys.token) else {
            return false
        }
        return !token.isEmpty
    }
    
    static var currentPhone: String {
        return UserDefaults.standard.string(forKey: Keys.phone) ?? ""
    }
    
    static var currentToken: String {
        guard let token = UserDefaults.standard.string(forKey: Keys.token),
              !token.isEmpty else {
            return ""
        }
        return token
    }
    
    static var currentName: String {
        return UserDefaults.standard.string(forKey: Keys.name) ?? ""
    }
    
    static var currentNumber: String {
        return UserDefaults.standard.string(forKey: Keys.idNumber) ?? ""
    }
    
    static var currentTime: String {
        return UserDefaults.standard.string(forKey: Keys.dateStr) ?? ""
    }
}
