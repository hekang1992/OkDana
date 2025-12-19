//
//  BaseViewController.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/13.
//

import UIKit
import SnapKit
import TYAlertController

class BaseViewController: UIViewController {
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#48CC4D")
        return view
    }()
    
    lazy var headView: AppNavView = {
        let headView = AppNavView()
        return headView
    }()
    
    lazy var normalHeadView: AppNormalNavView = {
        let normalHeadView = AppNormalNavView()
        return normalHeadView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(hex: "#F5F5F5")
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    func backToListPageVc() {
        guard let navigationController = self.navigationController else { return }
        if let targetVC = navigationController.viewControllers.first(where: { $0 is ProductDetailViewController }) {
            navigationController.popToViewController(targetVC, animated: true)
        } else {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func backToPopPageVc() {
        guard let navigationController = self.navigationController else { return }
        if let targetVC = navigationController.viewControllers.first(where: { $0 is SettingViewController }) {
            navigationController.popToViewController(targetVC, animated: true)
        } else {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func goWebVc(with pageUrl: String) {
        let webVc = APPWebViewController()
        webVc.pageUrl = pageUrl
        self.navigationController?.pushViewController(webVc, animated: true)
    }
    
}
