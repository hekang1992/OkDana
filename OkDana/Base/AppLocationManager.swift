//
//  AppLocationManager.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/17.
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

