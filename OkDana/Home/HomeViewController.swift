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
        
        let json = CommonParaConfig.getCommonParameters()
        
        self.oneView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                await self.oneView.scrollView.mj_header?.endRefreshing()
            }
        })
        
    }
    

}

extension HomeViewController {
    
    @objc func btnClick() {
        let navVc = BaseNavigationController(rootViewController: LoginViewController())
        navVc.modalPresentationStyle = .overFullScreen
        self.present(navVc, animated: true)
    }
    
}
