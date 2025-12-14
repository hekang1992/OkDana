//
//  LanguageManager.swift
//  OkDana
//
//  Created by hekang on 2025/12/13.
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

class LanguageManager {
    private static var currentBundle: Bundle = .main
    
    static func setLanguage(_ language: AppLanguage) {
        guard let path = Bundle.main.path(forResource: language.localeIdentifier, ofType: "lproj"),
              let langBundle = Bundle(path: path) else {
            currentBundle = .main
            return
        }
        currentBundle = langBundle
        
        UserDefaults.standard.set(language.rawValue, forKey: "app_language")
    }
    
    static func localizedString(for key: String) -> String {
        return currentBundle.localizedString(forKey: key, value: key, table: nil)
    }
    
    static var currentLanguage: AppLanguage {
        let savedCode = UserDefaults.standard.string(forKey: "app_language")
        return AppLanguage(rawValue: savedCode ?? "2") ?? .en
    }
    
    static func setup() {
        let language = currentLanguage
        setLanguage(language)
    }
}
