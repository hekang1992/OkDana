//
//  StartViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/13.
//

import UIKit
import SnapKit
import AdSupport
import Alamofire
import FBSDKCoreKit
import AppTrackingTransparency
import RxSwift
import RxCocoa

class StartViewController: BaseViewController {
    
    var index: Int = 0
    
    var apiArray: [[String: String]] = []
    
    let viewModel = StartViewModel()
    
    let disposeBag = DisposeBag()
    
    lazy var againBtn: UIButton = {
        let againBtn = UIButton(type: .custom)
        againBtn.setTitle(LanguageManager.localizedString(for: "Try Again"), for: .normal)
        againBtn.setTitleColor(.white, for: .normal)
        againBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(500))
        againBtn.isHidden = true
        return againBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNetworkMonitoring()
    }
    
    private func setupUI() {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(hex: "#57CF4C")
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "login_logo_image")
        bgView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 72, height: 72))
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(100)
        }
        
        bgView.addSubview(againBtn)
        againBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 20))
            make.bottom.equalToSuperview().offset(-60)
        }
        
        againBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            setupNetworkMonitoring()
        }).disposed(by: disposeBag)
    }
    
    private func setupNetworkMonitoring() {
        LanguageManager.setup()
        
        NetworkMonitor.shared.startMonitoring { [weak self] hasConnection in
            guard let self = self else { return }
            
            if hasConnection {
                Task {
                    await self.getApiJsonInfo()
                }
                NetworkMonitor.shared.stopMonitoring()
            } else {
                self.handleNoConnection()
            }
        }
    }
    
    private func handleNoConnection() {
        guard UIDevice.current.model == "iPad" else { return }
        if let lang = AppLanguage(rawValue: "1") {
            LanguageManager.setLanguage(lang)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil)
        }
    }
}

// MARK: - App Initialization
extension StartViewController {
    
    private func getApiJsonInfo() async {
        
        LoadingManager.shared.show()
        
        defer {
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
            }
        }
        
        let pageUrl = "https://id08-dc.oss-ap-southeast-5.aliyuncs.com/ok-dana/69437b570c3f2.json"
        guard let url = URL(string: pageUrl) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: String]] {
                self.apiArray = jsonArray
                await self.performAppInitialization()
            } else {
                
            }
        } catch {
            
        }
    }
    
    private func performAppInitialization() async {
        do {
            let model: BaseModel = try await fetchAppInitInfo()
            
            guard model.somewhat == 0 else {
                againBtn.isHidden = false
                return
            }
            againBtn.isHidden = true
            if let facebookModel = model.combined?.consecutively {
                configureFacebook(with: facebookModel)
            }
            
            if let reflecting = model.combined?.reflecting,
               let lang = AppLanguage(rawValue: reflecting) {
                UserDefaults.standard.set(reflecting, forKey: "reflecting")
                UserDefaults.standard.synchronize()
                if UIDevice.current.model == "iPad" {
                    if let podlang = AppLanguage(rawValue: "1") {
                        LanguageManager.setLanguage(podlang)
                    }
                }else {
                    LanguageManager.setLanguage(lang)
                }
            }
            
            await requestIDFAAuthorization()
            
        } catch {
            againBtn.isHidden = false
            handleInitializationError(error)
            
            if self.index > self.apiArray.count - 1 {
                return
            }
            
            let apiUrl = self.apiArray[self.index]["od"] ?? ""
            UserDefaults.standard.set(apiUrl, forKey: "baseUrl")
            UserDefaults.standard.synchronize()
            
            self.index += 1
            Task {
                await self.performAppInitialization()
            }
            
            
        }
    }
    
    private func fetchAppInitInfo() async throws -> BaseModel {
        let turn = Locale.preferredLanguages.first ?? ""
        let json = [
            "turn": turn,
            "option": String(HTTPProxyInfo.proxyStatus.rawValue),
            "complex": String(HTTPProxyInfo.vpnStatus.rawValue)
        ]
        
        return try await viewModel.getAppInitInfo(json: json)
    }
    
    private func configureFacebook(with model: consecutivelyModel) {
        Settings.shared.appID = model.consists ?? ""
        Settings.shared.clientToken = model.stacker ?? ""
        Settings.shared.displayName = model.crane ?? ""
        Settings.shared.appURLSchemeSuffix = model.pairs ?? ""
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            didFinishLaunchingWithOptions: nil
        )
    }
    
    private func handleInitializationError(_ error: Error) {
        print("App initialization failed: \(error)")
    }
}

// MARK: - IDFA Handling
extension StartViewController {
    
    private func requestIDFAAuthorization() async {
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        if #available(iOS 14.0, *) {
            let status = await ATTrackingManager.requestTrackingAuthorization()
            switch status {
            case .authorized, .notDetermined, .denied:
                await uploadDeviceInfo()
            case .restricted:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func uploadDeviceInfo() async {
        do {
            let json = [
                "tabu": DeviceIdentifierManager.getDeviceIdentifier(),
                "build": DeviceIdentifierManager.getIDFA()
            ]
            
            let model: BaseModel = try await viewModel.uploadIDInfo(json: json)
            
            if model.somewhat == 0 {
                try? await Task.sleep(nanoseconds: 250_000_000)
                completeInitialization()
            }else {
                againBtn.isHidden = false
            }
        } catch {
            againBtn.isHidden = false
            handleIDFAUploadError(error)
        }
    }
    
    private func completeInitialization() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: NSNotification.Name("changeRootVc"),
                object: nil
            )
        }
    }
    
    private func handleIDFAUploadError(_ error: Error) {
        completeInitialization()
    }
}

