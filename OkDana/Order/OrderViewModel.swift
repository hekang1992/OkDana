//
//  OrderViewModel.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/16.
//

import Foundation

class OrderViewModel {
    
    func getOrderListInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingManager.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/considerablyreal/concurrent", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
}
