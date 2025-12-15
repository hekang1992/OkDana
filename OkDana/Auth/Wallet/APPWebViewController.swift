//
//  APPWebViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import SnapKit
import WebKit
import TYAlertController

class APPWebViewController: BaseViewController {
    
    var productID: String = ""
    
    var pageUrl: String = ""
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "#F5F5F5").cgColor,
            UIColor(hex: "#DDFFDD").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect.zero
        bgView.layer.insertSublayer(gradientLayer, at: 0)
        return bgView
    }()
    
    private var gradientLayer: CAGradientLayer? {
        return bgView.layer.sublayers?.first as? CAGradientLayer
    }
    
     lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let scriptNames = [
            "HistoryAnd", "TravelingThe", "FirstAnd",
            "WasThe", "MeasureConstructing"]
        scriptNames.forEach {
            configuration.userContentController.add(self, name: $0)
        }
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.isHidden = true
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        bgView.addSubview(normalHeadView)
        normalHeadView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        normalHeadView.backAction = { [weak self] in
            guard let self = self else { return }
            if self.webView.canGoBack {
                self.webView.goBack()
            }else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(normalHeadView.snp.bottom)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        guard let encodedUrlString = pageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let apiUrl = URLQueryHelper.buildURL(from: encodedUrlString, queryParameters: CommonParaConfig.getCommonParameters()),
              let finalUrl = URL(string: apiUrl) else {
            print("Failed to construct valid URL from: \(pageUrl)")
            return
        }
        
        webView.load(URLRequest(url: finalUrl))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = bgView.bounds
    }
}

extension APPWebViewController: WKNavigationDelegate, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let name = message.name
        let body = message.body
        print("name===🔥===\(name)=====\(body)")
    }
    
}
