//
//  LoginViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/13.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController {
    
    var timer: Timer?
    var count = 60
    
    lazy var loginView: LoginView = {
        let loginView = LoginView()
        return loginView
    }()
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tapClick()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginView.phoneTextFiled.becomeFirstResponder()
    }
    
    @MainActor
    deinit {
        timer?.invalidate()
    }
    
}


extension LoginViewController {
    
    private func tapClick() {
        
        loginView.backBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        loginView.codeBlock = { [weak self] in
            guard let self = self else { return }
            let phone = self.loginView.phoneTextFiled.text ?? ""
            if phone.isEmpty {
                ToastManager.showMessage(message: "Please enter your phone number")
                return
            }
            self.getCodeInfo()
        }
        
        loginView.voiceBlock = { [weak self] in
            guard let self = self else { return }
            self.getVoiceCodeInfo()
        }
        
        loginView.loginBlock = { [weak self] in
            guard let self = self else { return }
            self.loginView.phoneTextFiled.resignFirstResponder()
            self.loginView.codeTextFiled.resignFirstResponder()
            let grand = self.loginView.mentBtn.isSelected
            if grand {
                self.loginInfo()
            }else {
                ToastManager.showMessage(message: "Please read and confirm the app's privacy agreement.")
            }
            
        }
        
    }
    
    private func getCodeInfo() {
        Task { @MainActor in
            do {
                let json = ["motorways": self.loginView.phoneTextFiled.text ?? ""]
                let model: BaseModel = try await self.viewModel.getCodeInfo(json: json)
                if model.somewhat == 0 {
                    self.loginView.codeTextFiled.becomeFirstResponder()
                    count = 60
                    timer = Timer.scheduledTimer(
                        timeInterval: 1.0,
                        target: self,
                        selector: #selector(updateCount),
                        userInfo: nil,
                        repeats: true
                    )
                }
                ToastManager.showMessage(message: model.conversion ?? "")
            } catch {
                
            }
        }
    }
    
    private func getVoiceCodeInfo() {
        Task { @MainActor in
            do {
                let json = ["motorways": self.loginView.phoneTextFiled.text ?? ""]
                let model: BaseModel = try await self.viewModel.getVoiceCodeInfo(json: json)
                if model.somewhat == 0 {
                    self.loginView.codeTextFiled.becomeFirstResponder()
                }
                ToastManager.showMessage(message: model.conversion ?? "")
            } catch {
                
            }
        }
    }
    
    private func loginInfo() {
        Task { @MainActor in
            do {
                let json = ["slip": self.loginView.phoneTextFiled.text ?? "",
                            "street": self.loginView.codeTextFiled.text ?? ""]
                let model: BaseModel = try await self.viewModel.loginInfo(json: json)
                if model.somewhat == 0 {
                    let phone = model.combined?.slip ?? ""
                    let token = model.combined?.alpha ?? ""
                    LoginConfig.save(phone: phone, token: token)
                    await self.chageRootVc()
                }
                ToastManager.showMessage(message: model.conversion ?? "")
            } catch {
                
            }
        }
    }
    
    private func chageRootVc() async {
        try? await Task.sleep(nanoseconds: 200_000_000)
        NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil)
    }
    
}

extension LoginViewController {
    
    @objc func updateCount() {
        count -= 1
        if count > 0 {
            self.loginView.codeBtn.setTitle("\(count)s", for: .normal)
            self.loginView.clineView.isHidden = true
            self.loginView.codeBtn.isEnabled = false
        } else {
            timer?.invalidate()
            timer = nil
            self.loginView.codeBtn.isEnabled = true
            self.loginView.codeBtn.setTitle(LanguageManager.localizedString(for: "Get Code"), for: .normal)
            self.loginView.clineView.isHidden = false
        }
    }
    
}
