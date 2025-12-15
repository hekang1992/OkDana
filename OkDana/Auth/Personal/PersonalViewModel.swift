//
//  PersonalViewModel.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import Foundation

class PersonalViewModel {

    func getPersonalDetailInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingManager.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/considerablyreal/stacker", parameters: json)
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
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/considerablyreal/motorways", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
    
}
