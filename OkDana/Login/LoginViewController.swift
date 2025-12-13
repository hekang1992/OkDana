//
//  LoginViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/13.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController {
    
    lazy var loginView: LoginView = {
        let loginView = LoginView()
        return loginView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tapClick()
        
    }

}


extension LoginViewController {
    
    private func tapClick() {
        
        loginView.backBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
    }
    
}
