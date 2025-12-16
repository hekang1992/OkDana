//
//  HomeViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/13.
//

import UIKit
import SnapKit
import MJRefresh

class HomeViewController: BaseViewController {
    
    let viewModel = HomeViewModel()
    
    let startViewModel = StartViewModel()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.headerView.isHidden = true
        
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(twoView)
        twoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let code = LanguageManager.currentLanguage
        oneView.privacyLabel.isHidden = code == .id
        oneView.termsLabel.isHidden = code == .id
        
        self.oneView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.fetchAllData()
            }
        })
        
        self.twoView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.fetchAllData()
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await fetchAllData()
        }
    }
    
}

extension HomeViewController {
    
    private func fetchAllData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.fetchHomeData()
            }
            group.addTask {
                await self.uploadIdfaInfo()
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
        }
    }
    
    private func uploadIdfaInfo() async {
        do {
            let json = [
                "tabu": DeviceIdentifierManager.getDeviceIdentifier(),
                "build": DeviceIdentifierManager.getIDFA()
            ]
            _ = try await startViewModel.uploadIDInfo(json: json)
        } catch {
            
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
            //            errorView.isHidden = true
            self.oneView.model = firstEvenb.despite?.first
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
        //                errorView.isHidden = true
        
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
