//
//  HttpRequestManager.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import Foundation
import Alamofire

class HttpRequestManager: NSObject {
    
    let base_url = "http://8.215.47.12/actualcomplete"
    
    static let shared = HttpRequestManager()
    
    func get<T: Codable>(_ url: String, parameters: [String: Any]? = nil) async throws -> T {
        return try await request(url, method: .get, parameters: parameters, timeout: 10)
    }
    
    func uploadWithForm<T: Codable>(
        _ url: String,
        parameters: [String: Any]? = nil,
        imageData: Data? = nil,
        imageKey: String = "file"
    ) async throws -> T {
        
        return try await withCheckedThrowingContinuation { continuation in
            let apiUrl = URLQueryHelper.buildURL(from: base_url + url, queryParameters: CommonParaConfig.getCommonParameters()) ?? ""
            AF.upload(
                multipartFormData: { multipartFormData in
                    if let parameters = parameters {
                        for (key, value) in parameters {
                            if let stringValue = value as? String,
                               let data = stringValue.data(using: .utf8) {
                                multipartFormData.append(data, withName: key)
                            } else if let intValue = value as? Int,
                                      let data = "\(intValue)".data(using: .utf8) {
                                multipartFormData.append(data, withName: key)
                            }
                        }
                    }
                    
                    if let imageData = imageData {
                        multipartFormData.append(
                            imageData,
                            withName: imageKey,
                            fileName: "image.jpg",
                            mimeType: "image/jpeg"
                        )
                    }
                },
                to: apiUrl,
                method: .post,
                requestModifier: { $0.timeoutInterval = 30 }
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func request<T: Codable>(
        _ url: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        timeout: TimeInterval
    ) async throws -> T {
        
        return try await withCheckedThrowingContinuation { continuation in
            let apiUrl = URLQueryHelper.buildURL(from: base_url + url, queryParameters: CommonParaConfig.getCommonParameters()) ?? ""
            AF.request(
                apiUrl,
                method: method,
                parameters: parameters,
                encoding: URLEncoding.default,
                requestModifier: { $0.timeoutInterval = timeout }
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

struct URLQueryHelper {
    
    static func buildURL(from baseURL: String,
                        queryParameters: [String: String?]) -> String? {
        guard var components = URLComponents(string: baseURL) else {
            return nil
        }
   
        let validQueryItems = createValidQueryItems(from: queryParameters)
        
        components.queryItems = mergeQueryItems(
            existing: components.queryItems,
            new: validQueryItems
        )
        
        return components.url?.absoluteString
    }
    
    static func appendQueries(to url: String,
                            parameters: [String: String?]) -> String? {
        return buildURL(from: url, queryParameters: parameters)
    }
    
    // MARK: - Private Helpers
    private static func createValidQueryItems(from parameters: [String: String?]) -> [URLQueryItem] {
        return parameters.compactMap { key, value -> URLQueryItem? in
            guard let validValue = value, !validValue.isEmpty else {
                return nil
            }
            return URLQueryItem(name: key, value: validValue)
        }
    }
    
    private static func mergeQueryItems(existing: [URLQueryItem]?, new: [URLQueryItem]) -> [URLQueryItem]? {
        guard !new.isEmpty else {
            return existing?.isEmpty == true ? nil : existing
        }
        
        var queryItemsMap = [String: URLQueryItem]()
        
        existing?.forEach { queryItemsMap[$0.name] = $0 }
        
        new.forEach { queryItemsMap[$0.name] = $0 }
        
        return Array(queryItemsMap.values)
    }
}

