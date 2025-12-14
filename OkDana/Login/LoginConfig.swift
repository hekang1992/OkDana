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
    }
    
    static func save(phone: String, token: String) {
        UserDefaults.standard.set(phone, forKey: Keys.phone)
        UserDefaults.standard.set(token, forKey: Keys.token)
    }
    
    static func clear() {
        UserDefaults.standard.removeObject(forKey: Keys.phone)
        UserDefaults.standard.removeObject(forKey: Keys.token)
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
    
    static var currentToken: String? {
        guard let token = UserDefaults.standard.string(forKey: Keys.token),
              !token.isEmpty else {
            return nil
        }
        return token
    }
}
