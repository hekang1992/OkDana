//
//  AppSchemeUrlConfig.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/14.
//

import UIKit

// MARK: - URL Schemes
enum AppScheme {
    static let base = "ios://ok.da.na"
    
    enum Path: String {
        case adding = "/adding"
        case setting = "/and"
        case home = "/julia"
        case login = "/text"
        case order = "/th"
        
        var fullURL: String {
            return "\(AppScheme.base)\(rawValue)"
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let changeRootVc = Notification.Name("changeRootVc")
    static let toLoginVc = Notification.Name("toLoginVc")
    static let toOrderVc = Notification.Name("toOrderVc")
}

// MARK: - Route Handler
class AppSchemeUrlConfig {
    
    enum RouteDestination {
        case setting
        case home
        case login
        case order
        case productDetail(productID: String?)
        case unknown
    }
    
    static func handleRoute(pageUrl: String, from viewController: BaseViewController, modelArray: [other_urlModel]? = []) {
        let destination = parseRoute(from: pageUrl)
        
        switch destination {
        case .setting:
            navigateToSetting(from: viewController, modelArray: modelArray)
            
        case .home:
            navigateToHome()
            
        case .login:
            navigateToLogin()
            
        case .order:
            navigateToOrder()
            
        case .productDetail(let productID):
            navigateToProductDetail(productID: productID, from: viewController)
            
        case .unknown:
            print("Unknown route: \(pageUrl)")
        }
    }
    
    // MARK: - Private Methods
    
    private static func parseRoute(from urlString: String) -> RouteDestination {
        guard let url = URL(string: urlString) else { return .unknown }
        
        let path = url.path
        
        switch path {
        case AppScheme.Path.setting.rawValue:
            return .setting
            
        case AppScheme.Path.home.rawValue:
            return .home
            
        case AppScheme.Path.login.rawValue:
            return .login
            
        case AppScheme.Path.order.rawValue:
            return .order
            
        case AppScheme.Path.adding.rawValue:
            let parameters = URLQueryParameterExtractor.extractAllParameters(from: urlString)
            let productID = parameters["cannot"]
            return .productDetail(productID: productID)
            
        default:
            return .unknown
        }
    }
    
    private static func navigateToSetting(from viewController: BaseViewController, modelArray: [other_urlModel]? = []) {
        let settingVC = SettingViewController()
        settingVC.modelArray = modelArray
        viewController.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    private static func navigateToHome() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            NotificationCenter.default.post(name: .changeRootVc, object: nil)
        }
    }
    
    private static func navigateToLogin() {
        LoginConfig.clear()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            NotificationCenter.default.post(name: .toLoginVc, object: nil)
        }
    }
    
    private static func navigateToOrder() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            NotificationCenter.default.post(name: .toOrderVc, object: nil)
        }
    }
    
    private static func navigateToProductDetail(productID: String?, from viewController: BaseViewController) {
        let detailVC = ProductDetailViewController()
        detailVC.productID = productID ?? ""
        viewController.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - URL Parameter Extractor
class URLQueryParameterExtractor {
    
    static func extractAllParameters(from urlString: String) -> [String: String] {
        guard let urlComponents = URLComponents(string: urlString),
              let queryItems = urlComponents.queryItems else {
            return [:]
        }
        
        return queryItems.reduce(into: [:]) { result, item in
            result[item.name] = item.value ?? ""
        }
    }
    
    static func extractParameter(named name: String, from urlString: String) -> String? {
        return extractAllParameters(from: urlString)[name]
    }
}
