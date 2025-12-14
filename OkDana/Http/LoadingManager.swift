//
//  Untitled.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import UIKit
import SnapKit
import Toast_Swift

class LoadingManager {
    static let shared = LoadingManager()
    private var loadingView: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    private var bgView: UIView?
    
    private init() {}
    
    func show(in view: UIView? = nil) {
        hide()
        
        DispatchQueue.main.async {
            let targetView = view ?? self.getKeyWindow()
            guard let targetView = targetView else { return }
            
            let bgView = UIView()
            bgView.backgroundColor = .clear
            targetView.addSubview(bgView)
            
            bgView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            let loadingView = UIView()
            loadingView.layer.cornerRadius = 12
            loadingView.layer.masksToBounds = true
            loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.startAnimating()
            
            loadingView.addSubview(activityIndicator)
            targetView.addSubview(loadingView)
            
            loadingView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 100, height: 100))
            }
            
            activityIndicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            self.loadingView = loadingView
            self.activityIndicator = activityIndicator
            self.bgView = bgView
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.bgView?.removeFromSuperview()
            self.bgView = nil
            
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


class ToastManager {
    static func showMessage(message: String) {
        guard let window = UIApplication.shared.windows.first else { return }
        window.makeToast(LanguageManager.localizedString(for: message), duration: 3.0, position: .center)
    }
}
