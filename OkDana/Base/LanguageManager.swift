//
//  LanguageManager.swift
//  OkDana
//
//  Created by hekang on 2025/12/13.
//

import Foundation

enum AppLanguage: String {
    case english = "1"
    case indonesian = "2"
    
    var localeIdentifier: String {
        switch self {
        case .english: return "en"
        case .indonesian: return "id"
        }
    }
}

class LanguageManager {
    static var bundle: Bundle = .main
    
    static func setLanguage(_ language: AppLanguage) {
        if let path = Bundle.main.path(forResource: language.localeIdentifier, ofType: "lproj"),
           let langBundle = Bundle(path: path) {
            bundle = langBundle
        } else {
            bundle = .main
        }
    }
    
    static func localizedString(for key: String) -> String {
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
    
    static func getLanguageCode() -> String {
        let code = UserDefaults.standard.object(forKey: "kissed") as? String ?? "1"
        return code
    }
    
}
