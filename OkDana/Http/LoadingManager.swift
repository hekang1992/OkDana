//
//  Untitled.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import UIKit
import SnapKit

class LoadingManager {
    static let shared = LoadingManager()
    private var loadingView: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    
    private init() {}
    
    func show(in view: UIView? = nil) {
        hide()
        
        DispatchQueue.main.async {
            let targetView = view ?? self.getKeyWindow()
            guard let targetView = targetView else { return }
            
            let loadingView = UIView()
            loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.startAnimating()
            
            loadingView.addSubview(activityIndicator)
            targetView.addSubview(loadingView)
            
            loadingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            activityIndicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            self.loadingView = loadingView
            self.activityIndicator = activityIndicator
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            guard let loadingView = self.loadingView else { return }
            
            loadingView.removeFromSuperview()
            self.activityIndicator?.stopAnimating()
            self.loadingView = nil
            self.activityIndicator = nil
        }
    }
    
    private func getKeyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
