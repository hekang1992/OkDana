//
//  CenterViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MJRefresh

class CenterViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel = CenterViewModel()
    
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
    
    lazy var centerView: CenterView = {
        let centerView = CenterView()
        return centerView
    }()
    
    private var gradientLayer: CAGradientLayer? {
        return bgView.layer.sublayers?.first as? CAGradientLayer
    }
    
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
        normalHeadView.backButton.isHidden = true
        
        view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(5)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        self.centerView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [weak self] in
            guard let self = self else { return }
            Task {
                await self.getCentetInfo()
            }
        })
        
        self.centerView.cellBlock = { [weak self] model in
            guard let self = self else { return }
            let pageUrl = model.inputs ?? ""
            if pageUrl.contains(AppScheme.base) {
                AppSchemeUrlConfig.handleRoute(pageUrl: pageUrl, from: self)
            } else if pageUrl.contains("http://") || pageUrl.contains("https://") {
                self.goWebVc(with: pageUrl)
            }else {
                
            }
        }
        
        let phone = LoginConfig.currentPhone
        print("phone==☎️===\(phone)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = bgView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.getCentetInfo()
        }
    }
}

extension CenterViewController {
    
    private func getCentetInfo() async {
        do {
            let model = try await viewModel.getCenterInfo()
            if model.somewhat == 0 {
                self.centerView.phoneLabel.text = model.combined?.userInfo?.motorways ?? ""
                self.centerView.modelArray = model.combined?.easier ?? []
            }
            self.centerView.tableView.reloadData()
            await self.centerView.scrollView.mj_header?.endRefreshing()
        } catch  {
            await self.centerView.scrollView.mj_header?.endRefreshing()
        }
    }
    
}
