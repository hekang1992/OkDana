//
//  HomeViewModel.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import Foundation

class HomeViewModel {
    
    func getHomeInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingManager.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get("/considerablyreal/combined", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
    func tapClickProductInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingManager.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/considerablyreal/reflecting", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
}
