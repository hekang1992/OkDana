//
//  LoginView.swift
//  OkDana
//
//  Created by hekang on 2025/12/13.
//

import UIKit
import SnapKit

class LoginView: UIView {
    
    var backBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "login_bg_image")
        return bgImageView
    }()

    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "back_left_image"), for: .normal)
        backBtn.adjustsImageWhenHighlighted = false
        backBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return backBtn
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "login_logo_image")
        return logoImageView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        whiteView.layer.masksToBounds = true
        whiteView.layer.cornerRadius = 24
        return whiteView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textAlignment = .left
        phoneLabel.text = LanguageManager.localizedString(for: "Phone number")
        phoneLabel.textColor = UIColor.init(hex: "#373737")
        phoneLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return phoneLabel
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.backgroundColor = UIColor.init(hex: "#F5F5F5")
        oneView.layer.cornerRadius = 5
        oneView.layer.masksToBounds = true
        return oneView
    }()
    
    lazy var codeLabel: UILabel = {
        let codeLabel = UILabel()
        codeLabel.textAlignment = .left
        codeLabel.text = LanguageManager.localizedString(for: "Verification code")
        codeLabel.textColor = UIColor.init(hex: "#373737")
        codeLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return codeLabel
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.backgroundColor = UIColor.init(hex: "#F5F5F5")
        twoView.layer.cornerRadius = 5
        twoView.layer.masksToBounds = true
        return twoView
    }()
    
    lazy var voiceLabel: UILabel = {
        let voiceLabel = UILabel()
        voiceLabel.textAlignment = .right
        voiceLabel.text = LanguageManager.localizedString(for: "Get the voice verification code")
        voiceLabel.textColor = UIColor.init(hex: "#C0C0C0")
        voiceLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(400))
        return voiceLabel
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle(LanguageManager.localizedString(for: "Log in"), for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        loginBtn.setBackgroundImage(UIImage(named: "login_btn_image"), for: .normal)
        loginBtn.adjustsImageWhenHighlighted = false
        return loginBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(backBtn)
        addSubview(logoImageView)
        addSubview(whiteView)
        whiteView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(oneView)
        contentView.addSubview(codeLabel)
        contentView.addSubview(twoView)
        contentView.addSubview(voiceLabel)
        contentView.addSubview(loginBtn)
        
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
            make.left.equalToSuperview().offset(20)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(backBtn.snp.bottom).offset(-12)
            make.size.equalTo(CGSize(width: 72, height: 72))
            make.centerX.equalToSuperview()
        }
        
        whiteView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(13)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.greaterThanOrEqualTo(scrollView.snp.height).priority(.low)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(18)
        }
        
        oneView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(phoneLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(18)
        }
        
        twoView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(codeLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        voiceLabel.snp.makeConstraints { make in
            make.top.equalTo(twoView.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(14)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(voiceLabel.snp.bottom).offset(38)
            make.size.equalTo(CGSize(width: 327, height: 50))
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoginView {
    
    @objc private func btnClick() {
        self.backBlock?()
    }
    
}
