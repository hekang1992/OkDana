//
//  APPWebViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import SnapKit
import WebKit
import StoreKit

class APPWebViewController: BaseViewController {
    
    var productID: String = ""
    
    var pageUrl: String = ""
    
    let startViewModel = StartViewModel()
    
    let locationManager = AppLocationManager()
    
    // MARK: - UI Components
    
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
            "WasThe", "MeasureConstructing"
        ]
        scriptNames.forEach {
            configuration.userContentController.add(self, name: $0)
        }
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor.systemBlue
        progressView.trackTintColor = UIColor.clear
        progressView.isHidden = true
        return progressView
    }()
    
    private var estimatedProgressObserver: NSKeyValueObservation?
    private var titleObserver: NSKeyValueObservation?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.isHidden = true
        setupUI()
        setupObservers()
        loadWebPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        estimatedProgressObserver?.invalidate()
        titleObserver?.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = bgView.bounds
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {

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
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(normalHeadView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        // WebView
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        normalHeadView.backAction = { [weak self] in
            guard let self = self else { return }
            if self.webView.canGoBack {
                self.webView.goBack()
            } else {
                self.backToPopPageVc()
            }
        }
    }
    
    private func setupObservers() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, change in
            guard let self = self else { return }
            self.updateProgressView(progress: webView.estimatedProgress)
        }
        
        titleObserver = webView.observe(\.title, options: [.new]) { [weak self] webView, change in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateTitle(webView.title)
            }
        }
    }
    
    private func loadWebPage() {
        guard let encodedUrlString = pageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let apiUrl = URLQueryHelper.buildURL(from: encodedUrlString, queryParameters: CommonParaConfig.getCommonParameters()),
              let finalUrl = URL(string: apiUrl) else {
            print("Failed to construct valid URL from: \(pageUrl)")
            return
        }
        
        let request = URLRequest(url: finalUrl)
        webView.load(request)
    }
    
    // MARK: - Update Methods
    
    private func updateProgressView(progress: Double) {
        DispatchQueue.main.async {
            if progress >= 1.0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.progressView.alpha = 0
                }) { _ in
                    self.progressView.isHidden = true
                    self.progressView.progress = 0
                    self.progressView.alpha = 1
                }
            } else {
                if self.progressView.isHidden {
                    self.progressView.isHidden = false
                    self.progressView.alpha = 0
                    UIView.animate(withDuration: 0.3) {
                        self.progressView.alpha = 1
                    }
                }
                self.progressView.setProgress(Float(progress), animated: true)
            }
        }
    }
    
    private func updateTitle(_ title: String?) {
        self.normalHeadView.nameLabel.text = title
    }
    
}

// MARK: - WKNavigationDelegate, WKScriptMessageHandler
extension APPWebViewController: WKNavigationDelegate, WKScriptMessageHandler {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
        progressView.setProgress(0.1, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.progressView.setProgress(1.0, animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let name = message.name
        let body = message.body
        
        if name == "HistoryAnd" {
            self.navigationController?.popViewController(animated: true)
        } else if name == "TravelingThe" {
            let array = body as? [String]
            let pageUrl = array?.first ?? ""
            AppSchemeUrlConfig.handleRoute(pageUrl: pageUrl, from: self)
        } else if name == "FirstAnd" {
            NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil)
        } else if name == "WasThe" {
            requestAppReview()
        } else if name == "MeasureConstructing" {
            locationManager.getCurrentLocation { json in
                if let json = json {
                    Task {
                       await self.pointMessage(with: json)
                    }
                }else {
                    if let locationJson = LocationManagerModel.shared.locationJson {
                        Task {
                            await self.pointMessage(with: locationJson)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - StoreKit
extension APPWebViewController {
    
    private func requestAppReview() {
        guard #available(iOS 14.0, *) else { return }
        
        guard let windowScene = UIApplication.shared
            .connectedScenes
            .first(where: { $0 is UIWindowScene }) as? UIWindowScene else {
            return
        }
        
        SKStoreReviewController.requestReview(in: windowScene)
    }
    
    private func pointMessage(with locationJson: [String: String]) async {
        do {
            let end_time = String(Int(Date().timeIntervalSince1970))
            let apiJson = ["advanced": "9",
                           "compute": locationJson["compute"] ?? "",
                           "perturb": locationJson["perturb"] ?? "",
                           "mentioned": end_time,
                           "family": end_time
            ]
            
            let _ = try await startViewModel.uploadPointInfo(json: apiJson)
            
        } catch  {
            
        }
    }
    
}
