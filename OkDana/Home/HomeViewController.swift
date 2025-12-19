//
//  HomeViewController.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/13.
//

import UIKit
import SnapKit
import MJRefresh
import CoreLocation

class HomeViewController: BaseViewController {
    
    let viewModel = HomeViewModel()
    
    let startViewModel = StartViewModel()
    
    let locationManager = AppLocationManager()
    
    let wifiManager = WiFiManager()
    
    lazy var oneView: OneHomeView = {
        let oneView = OneHomeView(frame: .zero)
        oneView.isHidden = true
        return oneView
    }()
    
    lazy var twoView: TwoHomeView = {
        let twoView = TwoHomeView(frame: .zero)
        twoView.isHidden = true
        return twoView
    }()
    
    lazy var errorView: AppNetErrorView = {
        let errorView = AppNetErrorView(frame: .zero)
        errorView.isHidden = true
        return errorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.headerView.isHidden = true
        view.addSubview(oneView)
        view.addSubview(twoView)
        view.addSubview(errorView)
        
        [oneView, twoView, errorView].forEach { view in
            view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        errorView.againBtnBlock = { [weak self] in
            guard let self = self else { return }
            Task {
                await self.fetchAllData()
            }
        }
        
        let code = LanguageManager.currentLanguage
        oneView.privacyLabel.isHidden = code == .id
        oneView.termsLabel.isHidden = code == .id
        
        self.oneView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.fetchAllData()
                await self.locationMessage()
            }
        })
        
        self.twoView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.fetchAllData()
                await self.locationMessage()
            }
            
        })
        
        self.oneView.clickBlock = { [weak self] productID in
            guard let self = self else { return }
            if LoginConfig.isLoggedIn {
                tapClickProduct(with: productID)
            }else {
                let nav = BaseNavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .overFullScreen
                self.present(nav, animated: true)
            }
        }
        
        self.twoView.cellTapClickBlock = { [weak self] productID in
            guard let self = self else { return }
            if LoginConfig.isLoggedIn {
                tapClickProduct(with: productID)
            }else {
                let nav = BaseNavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .overFullScreen
                self.present(nav, animated: true)
            }
        }
        
        locationManager.getCurrentLocation { json in
            LocationManagerModel.shared.locationJson = json
            if LoginConfig.isLoggedIn == true {
                let code = LanguageManager.currentLanguage
                if code == .id {
                    LocationPermissionAlert.show(on: self)
                }
            }
        }
        
        oneView.agreementBlock = { [weak self] pageUrl in
            guard let self = self else { return }
            self.goWebVc(with: pageUrl)
        }
        
        oneView.termsBlock = { [weak self] pageUrl in
            guard let self = self else { return }
            self.goWebVc(with: pageUrl)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await fetchAllData()
            await locationMessage()
        }
        
    }
    
}

extension HomeViewController {
    
    private func locationMessage() async {
        var allJson = AppDeviceManager.allJson
        locationManager.getCurrentLocation { [weak self] json in
            guard let self = self else { return }
            LocationManagerModel.shared.locationJson = json
            if let json = json {
                Task {
                    await self.uploadLocation(with: json)
                }
            }
            
            Task {
                let wifiInfo = await self.wifiManager.getCurrentWiFiInfo()
                let original = wifiInfo.introduced.original
                let concurrent = wifiInfo.introduced.concurrent
                let wifiJson = ["shen":
                                    ["introduced":
                                        ["original": original,
                                         "concurrent": concurrent]]]
                allJson.merge(wifiJson) { _, new in new }
                
                await self.uploadDeviceInfo(with: allJson)
                
            }
            
        }
    }
    
    private func fetchAllData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.fetchHomeData()
            }
            group.addTask {
                await self.uploadIdfaInfo()
            }
            group.addTask {
                await self.pointMessage()
            }
        }
    }
    
    private func fetchHomeData() async {
        do {
            let json = ["combined": "1"]
            let model: BaseModel = try await viewModel.getHomeInfo(json: json)
            await MainActor.run {
                if model.somewhat == 0 {
                    self.headerView.isHidden = false
                    self.fixHomeModel(with: model)
                }
                self.oneView.scrollView.mj_header?.endRefreshing()
                self.twoView.tableView.mj_header?.endRefreshing()
            }
        } catch {
            await MainActor.run {
                self.oneView.scrollView.mj_header?.endRefreshing()
                self.twoView.tableView.mj_header?.endRefreshing()
            }
            self.oneView.isHidden = true
            self.oneView.isHidden = true
            self.errorView.isHidden = false
        }
    }
    
    private func uploadIdfaInfo() async {
        do {
            let json = [
                "tabu": DeviceIdentifierConfig.getDeviceIdentifier(),
                "build": DeviceIdentifierConfig.getIDFA()
            ]
            _ = try await startViewModel.uploadIDInfo(json: json)
        } catch {
            
        }
    }
    
    private func uploadLocation(with json: [String: String]) async {
        do {
            let _ = try await startViewModel.uploadLocationInfo(json: json)
        } catch  {
            
        }
    }
    
    private func uploadDeviceInfo(with json: [String: Any]) async {
        do {
            guard let data = try? JSONSerialization.data(withJSONObject: json,
                                                         options: [.prettyPrinted]),
                  let jsonStr = String(data: data, encoding: .utf8) else {
                print("JSON Error===")
                return
            }
            let _ = try await startViewModel.uploadDeviceInfo(json: ["combined": jsonStr])
        } catch  {
            
        }
    }
    
    private func pointMessage() async {
        do {
            let start_time = LoginPointTimeManager.getStartTime()
            let end_time = LoginPointTimeManager.getEndTime()
            let locationJson = LocationManagerModel.shared.locationJson
            let apiJson = ["advanced": "1",
                           "compute": locationJson?["compute"] ?? "",
                           "perturb": locationJson?["perturb"] ?? "",
                           "mentioned": start_time,
                           "family": end_time
            ]
            if !start_time.isEmpty && !end_time.isEmpty {
                let model = try await startViewModel.uploadPointInfo(json: apiJson)
                if model.somewhat == 0 {
                    LoginPointTimeManager.removeTime()
                }
            }
        } catch  {
            
        }
    }
    
    private func fixHomeModel(with model: BaseModel) {
        guard let modelArray = model.combined?.easier else { return }
        
        let evenbModels = modelArray
            .compactMap { $0 }
            .filter { $0.complications == "evenb" }
        
        let evencModels = modelArray
            .compactMap { $0 }
            .filter { $0.complications == "evenc" }
        
        let evendModels = modelArray
            .compactMap { $0 }
            .filter { $0.complications == "evend" }
        
        if let firstEvenb = evenbModels.first {
            oneView.isHidden = false
            twoView.isHidden = true
            errorView.isHidden = true
            self.oneView.model = firstEvenb.despite?.first
            self.oneView.baseModel = model
        }
        
        if let firstEvenc = evencModels.first {
            configureTwoView(heads: "evenc", model: firstEvenc)
        }
        
        if let firstEvend = evendModels.first {
            configureTwoView(heads: "evend", model: firstEvend)
        }
    }
    
    private func configureTwoView(heads: String, model: easierModel) {
        oneView.isHidden = true
        twoView.isHidden = false
        errorView.isHidden = true
        
        if heads == "evenc" {
            self.twoView.bigModel = model.despite?.first
        } else if heads == "evend" {
            self.twoView.modelArray = model.despite
        }
        
        self.twoView.tableView.reloadData()
    }
    
}

extension HomeViewController {
    
    private func tapClickProduct(with productID: String) {
        Task {
            do {
                let json = ["cannot": productID]
                let model: BaseModel = try await viewModel.tapClickProductInfo(json: json)
                if model.somewhat == 0 {
                    ocPageUrl(with: model.combined?.inputs ?? "")
                }else {
                    ToastManager.showMessage(message: model.conversion ?? "")
                }
            } catch {
                
            }
        }
    }
    
    private func ocPageUrl(with pageUrl: String) {
        if pageUrl.contains(AppScheme.base) {
            AppSchemeUrlConfig.handleRoute(pageUrl: pageUrl, from: self)
        } else if pageUrl.contains("http://") || pageUrl.contains("https://") {
            self.goWebVc(with: pageUrl)
        }else {
            
        }
    }
    
}
