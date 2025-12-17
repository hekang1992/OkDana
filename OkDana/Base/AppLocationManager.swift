//
//  AppLocationManager.swift
//  OkDana
//
//  Created by hekang on 2025/12/17.
//

import UIKit
import Foundation
import CoreLocation

class AppLocationManager: NSObject {
    
    static let shared = AppLocationManager()
    
    private let locationManager = CLLocationManager()
    
    private var completion: (([String: String]?) -> Void)?
    
    private var debounceWorkItem: DispatchWorkItem?
    
    private let debounceInterval: TimeInterval = 2.0
    
    private let viewModel = StartViewModel()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getCurrentLocation(completion: @escaping ([String: String]?) -> Void) {
        self.completion = completion
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdate()
            
        case .denied, .restricted:
            completion(nil)
            
        @unknown default:
            completion(nil)
        }
    }
    
    private func startLocationUpdate() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
}

extension AppLocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        let status = manager.authorizationStatus
        
        switch status {
            
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdate()
            
        case .denied, .restricted:
            completion?(nil)
            
        case .notDetermined:
            break
            
        @unknown default:
            completion?(nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        locationManager.stopUpdatingLocation()
        debounceWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
                guard let self = self else { return }
                
                let placemark = placemarks?.first
                
                let locationJson = [
                    "local": placemark?.administrativeArea ?? "",
                    "enough": placemark?.isoCountryCode ?? "",
                    "opting": placemark?.country ?? "",
                    "mutation": placemark?.thoroughfare ?? "",
                    "perturb": String(format: "%.6f", location.coordinate.latitude),
                    "compute": String(format: "%.6f", location.coordinate.longitude),
                    "basic": placemark?.locality ?? "",
                    "evolutionary": placemark?.subLocality ?? ""
                ]
                
                self.completion?(locationJson)
            }
        }
        
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: workItem)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        completion?(nil)
    }
}

class LocationManagerModel {
    static let shared = LocationManagerModel()
    private init() {}
    var locationJson: [String: String]?
}

class LocationPermissionAlert {
    private static let lastAlertDateKey = "LocationPermissionAlert.lastAlertDate"
    static func show(on viewController: UIViewController) {
        guard shouldShowAlert() else { return }
        
        let alert = UIAlertController(
            title: LanguageManager.localizedString(for: "Permission Required"),
            message: LanguageManager.localizedString(for: "Location access is required to process your loan application. Please enable it in Settings to continue."),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: LanguageManager.localizedString(for: "Cancel"),
            style: .default
        )
        
        let settingsAction = UIAlertAction(
            title: LanguageManager.localizedString(for: "Go to Settings"),
            style: .cancel
        ) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        recordAlertShown()
        
        viewController.present(alert, animated: true)
    }
    
    private static func shouldShowAlert() -> Bool {
        guard let lastDate = UserDefaults.standard.object(forKey: lastAlertDateKey) as? Date else {
            return true
        }
        
        guard let nextAvailableDate = Calendar.current.date(
            byAdding: .hour,
            value: 24,
            to: lastDate
        ) else {
            return true
        }
        
        return Date() >= nextAvailableDate
    }
    
    private static func recordAlertShown() {
        UserDefaults.standard.set(Date(), forKey: lastAlertDateKey)
    }
    
    static func resetAlertRecord() {
        UserDefaults.standard.removeObject(forKey: lastAlertDateKey)
    }
    
    static func nextAvailableTime() -> Date? {
        guard let lastDate = UserDefaults.standard.object(forKey: lastAlertDateKey) as? Date else {
            return nil
        }
        
        return Calendar.current.date(byAdding: .hour, value: 24, to: lastDate)
    }
}
