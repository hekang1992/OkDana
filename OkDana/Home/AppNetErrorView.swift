//
//  AppNetErrorView.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/17.
//

import UIKit
import SnapKit

class AppNetErrorView: UIView {
    
    var againBtnBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_error_image")
        return bgImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.text = LanguageManager.localizedString(for: "Network Connection Failure")
        nameLabel.textColor = UIColor.init(hex: "#3F3F3F")
        nameLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(300))
        return nameLabel
    }()
    
    private lazy var applyBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(LanguageManager.localizedString(for: "Try Again"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setBackgroundImage(UIImage(named: "em_bt_image"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#F5F5F5")
        addSubview(bgImageView)
        addSubview(nameLabel)
        addSubview(applyBtn)
        
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(100)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 169, height: 169))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bgImageView.snp.bottom).offset(8)
            make.height.equalTo(12)
        }
        
        applyBtn.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 160, height: 40))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AppNetErrorView {
    
    @objc private func btnClick() {
        self.againBtnBlock?()
    }
}
