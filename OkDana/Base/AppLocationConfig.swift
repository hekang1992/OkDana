//
//  AppLocationConfig.swift
//  OkDana
//
//  Created by hekang on 2025/12/17.
//

import Foundation
import CoreLocation

class AppLocationConfig: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var onLocationResult: (([String: String]) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func startLocation(completion: @escaping ([String: String]) -> Void) {
        self.onLocationResult = completion
        locationManager.requestLocation()
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard
                let self = self,
                let placemark = placemarks?.first,
                error == nil
            else { return }

            let result: [String: String] = [
                "local": placemark.administrativeArea ?? "",
                "enough": placemark.isoCountryCode ?? "",
                "opting": placemark.country ?? "",
                "mutation": placemark.name ?? "",
                "perturb": String(format: "%.6f", latitude),
                "compute": String(format: "%.6f", longitude),
                "basic": placemark.locality ?? "",
                "evolutionary": placemark.subLocality ?? "",
            ]

            self.onLocationResult?(result)
            self.onLocationResult = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        onLocationResult = nil
    }
}
