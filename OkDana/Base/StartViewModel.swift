//
//  StartViewModel.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import Foundation

class StartViewModel {
    
    func getAppInitInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingManager.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.getInitApi("/considerablyreal/turn", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
    func uploadIDInfo(json: [String: String]) async throws -> BaseModel {
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/considerablyreal/right", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
    func uploadLocationInfo(json: [String: String]) async throws -> BaseModel {
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/considerablyreal/ptas", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
    func uploadDeviceInfo(json: [String: Any]) async throws -> BaseModel {
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/considerablyreal/scheme", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
    func uploadPointInfo(json: [String: String]) async throws -> BaseModel {
        var requestJson = ["reliable": DeviceIdentifierConfig.getDeviceIdentifier(),
                           "brian": DeviceIdentifierConfig.getIDFA(),
                           "nearly": "2"
        ]
        
        requestJson.merge(json) { _, new in new }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/considerablyreal/awarded", parameters: requestJson)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
}
