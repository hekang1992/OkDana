//
//  ProductViewModel.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import Foundation

class ProductViewModel {
    
    func getProductDetailInfo(json: [String: String]) async throws -> BaseModel {
        
        LoadingManager.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
            }
        }
        
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/considerablyreal/consecutively", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
}
