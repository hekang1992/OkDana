//
//  HomeViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/13.
//

import UIKit
import SnapKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.setTitleColor(.systemPink, for: .normal)
        loginBtn.backgroundColor = .white
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 150, height: 150))
        }
        
        loginBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
    }
    

}

extension HomeViewController {
    
    @objc func btnClick() {
        let navVc = BaseNavigationController(rootViewController: LoginViewController())
        navVc.modalPresentationStyle = .overFullScreen
        self.present(navVc, animated: true)
    }
    
}
