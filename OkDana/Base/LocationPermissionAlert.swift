//
//  LocationPermissionAlert.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/19.
//

import UIKit
import Foundation

class LocationPermissionAlert {
    
    private enum Constants {
        static let lastAlertDateKey = "LocationPermissionAlert.lastAlertDate"
        static let alertCooldownHours = 24
        static let settingsURLString = UIApplication.openSettingsURLString
    }
    
    static func show(on viewController: UIViewController) {
        guard shouldShowAlert() else { return }
        
        let alertController = createAlertController()
        recordAlertShown()
        
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true)
        }
    }
    
    static func resetAlertRecord() {
        UserDefaults.standard.removeObject(forKey: Constants.lastAlertDateKey)
    }
    
    static var nextAvailableTime: Date? {
        guard let lastDate = UserDefaults.standard.object(forKey: Constants.lastAlertDateKey) as? Date else {
            return nil
        }
        
        return Calendar.current.date(
            byAdding: .hour,
            value: Constants.alertCooldownHours,
            to: lastDate
        )
    }
    
    private static func createAlertController() -> UIAlertController {
        let alert = UIAlertController(
            title: localizedString(for: "Permission Required"),
            message: localizedString(for: "Location access is required to process your loan application. Please enable it in Settings to continue."),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: localizedString(for: "Cancel"),
            style: .default,
            handler: nil
        )
        
        let settingsAction = UIAlertAction(
            title: localizedString(for: "Go to Settings"),
            style: .cancel,
            handler: { _ in openSettings() }
        )
        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        return alert
    }
    
    private static func shouldShowAlert() -> Bool {
        guard let lastAlertDate = lastAlertDate else {
            return true
        }
        
        guard let nextAvailableDate = Calendar.current.date(
            byAdding: .hour,
            value: Constants.alertCooldownHours,
            to: lastAlertDate
        ) else {
            return true
        }
        
        return Date() >= nextAvailableDate
    }
    
    private static func recordAlertShown() {
        UserDefaults.standard.set(Date(), forKey: Constants.lastAlertDateKey)
    }
    
    private static func openSettings() {
        guard let settingsURL = URL(string: Constants.settingsURLString),
              UIApplication.shared.canOpenURL(settingsURL) else {
            return
        }
        
        UIApplication.shared.open(settingsURL)
    }
    
    private static func localizedString(for key: String) -> String {
        return LanguageManager.localizedString(for: key)
    }
    
    private static var lastAlertDate: Date? {
        return UserDefaults.standard.object(forKey: Constants.lastAlertDateKey) as? Date
    }
}

class LocationManagerModel {
    static let shared = LocationManagerModel()
    private init() {}
    var locationJson: [String: String]?
}
