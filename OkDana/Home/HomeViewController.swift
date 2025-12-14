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
        return oneView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let code = LanguageManager.currentLanguage
        oneView.leftLabel.isHidden = code == .en
        oneView.rightLabel.isHidden = code == .en
        
        self.oneView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.fetchAllData()
            }
        })
        
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
            let model = try await viewModel.getHomeInfo(json: json)
            await MainActor.run {
                if model.somewhat == 0 {
                    
                }
                self.oneView.scrollView.mj_header?.endRefreshing()
            }
        } catch {
            await MainActor.run {
                self.oneView.scrollView.mj_header?.endRefreshing()
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
    
}
