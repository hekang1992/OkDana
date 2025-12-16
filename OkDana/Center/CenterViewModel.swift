//
//  CenterViewModel.swift
//  OkDana
//
//  Created by hekang on 2025/12/16.
//

import Foundation

class CenterViewModel {
    
    func getCenterInfo() async throws -> BaseModel {
        
        LoadingManager.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.get("/considerablyreal/del")
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
}
