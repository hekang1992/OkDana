//
//  LoginViewModel.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

class LoginViewModel {
    
    func getCodeInfo(json: [String: String]) async throws -> BaseModel {
        do {
            let model: BaseModel = try await HttpRequestManager.shared.uploadWithForm("/ecutiveof/famous", parameters: json)
            return model
        } catch {
            print("error===: \(error)")
            throw error
        }
    }
    
}
