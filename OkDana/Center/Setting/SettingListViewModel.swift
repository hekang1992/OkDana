//
//  SettingListViewModel.swift
//  OkDana
//
//  Created by hekang on 2025/12/16.
//

import Foundation

class SettingListViewModel {
    
    func logoutInfo() async throws -> BaseModel {
        
        LoadingManager.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get("/considerablyreal/conversion")
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
    func deleteAccountInfo() async throws -> BaseModel {
        
        LoadingManager.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/considerablyreal/sqrt")
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
}
