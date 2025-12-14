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
            let model: BaseModel = try await HttpRequestManager.shared.get("/considerablyreal/turn", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
    func uploadIDInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingManager.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/considerablyreal/right", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
    
}
