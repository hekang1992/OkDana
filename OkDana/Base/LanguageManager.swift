//
//  LanguageManager.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/13.
//

import Foundation

enum AppLanguage: String {
    case en = "1"
    case id = "2"
    
    var localeIdentifier: String {
        switch self {
        case .en: return "en"
        case .id: return "id"
        }
    }
}

final class LanguageManager {
    
    private static var currentBundle: Bundle = .main
    private static let userDefaultsKey = "app_language"
    
    static func setLanguage(_ language: AppLanguage) {
        guard let bundlePath = Bundle.main.path(forResource: language.localeIdentifier, ofType: "lproj"),
              let languageBundle = Bundle(path: bundlePath) else {
            currentBundle = .main
            UserDefaults.standard.set(language.rawValue, forKey: userDefaultsKey)
            return
        }
        
        currentBundle = languageBundle
        
        UserDefaults.standard.set(language.rawValue, forKey: userDefaultsKey)
    }
    
    static func localizedString(for key: String) -> String {
        return currentBundle.localizedString(forKey: key, value: key, table: nil)
    }
    
    static var currentLanguage: AppLanguage {
        guard let savedCode = UserDefaults.standard.string(forKey: userDefaultsKey) else {
            return .en
        }
        return AppLanguage(rawValue: savedCode) ?? .en
    }
    
    static func setup() {
        setLanguage(currentLanguage)
    }
}
