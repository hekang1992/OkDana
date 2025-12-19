//
//  AppDeviceManager.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/17.
//

import UIKit
import Foundation

class AppDeviceManager: NSObject {
    
    static let oneJson = GrowManager.toJson()
    
    static let twoJson = DeviceDataManager.getAllDataAsJson()

    static var allJson: [String: Any] = {
        var dict: [String: Any] = [:]
        dict.merge(oneJson) { _, new in new }
        dict.merge(twoJson) { _, new in new }
        return dict
    }()
    
    
}
