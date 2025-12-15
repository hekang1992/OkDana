//
//  WorkViewModel.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import Foundation

class WorkViewModel {

    func getPersonalDetailInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingManager.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/considerablyreal/slip", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
    func savePersonalDetailInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingManager.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/considerablyreal/level", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
    
}
