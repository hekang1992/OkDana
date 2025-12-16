//
//  AlertLogoutView.swift
//  OkDana
//
//  Created by hekang on 2025/12/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AlertLogoutView: UIView {
    
    let disposeBag = DisposeBag()
    
    var oneBlock: (() -> Void)?
    
    var twoBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "lot_out_bg_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle(LanguageManager.localizedString(for: "Cancel"), for: .normal)
        oneBtn.backgroundColor = UIColor.init(hex: "#00CA5D")
        oneBtn.setTitleColor(.white, for: .normal)
        oneBtn.layer.cornerRadius = 25
        oneBtn.layer.masksToBounds = true
        oneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setTitle(LanguageManager.localizedString(for: "Delete"), for: .normal)
        twoBtn.setTitleColor(UIColor.init(hex: "#00CA5D"), for: .normal)
        oneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        return twoBtn
    }()
    
    lazy var titleClabel: UILabel = {
        let titleClabel = UILabel()
        titleClabel.textColor = UIColor(hex: "#FFFFFF")
        titleClabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(500))
        titleClabel.textAlignment = .center
        titleClabel.text = LanguageManager.localizedString(for: "Log Out")
        return titleClabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor(hex: "#525252")
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(400))
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.text = LanguageManager.localizedString(for: "After cancellation, the account will become permanently invalid, and personal information will all be cleared.")
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(bgImageView)
        
        bgImageView.addSubview(titleClabel)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(oneBtn)
        bgImageView.addSubview(twoBtn)
    }
    
    private func setupConstraints() {
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 335, height: 316))
        }
        
        titleClabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(40)
            make.height.equalTo(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(95)
        }
        
        oneBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 256, height: 50))
            make.top.equalTo(nameLabel.snp.bottom).offset(44)
        }
        
        twoBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 256, height: 20))
            make.top.equalTo(oneBtn.snp.bottom).offset(13)
        }
        
    }
    
    private func setupBindings() {
        oneBtn
            .rx
            .tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.oneBlock?()
            })
            .disposed(by: disposeBag)
        
        twoBtn
            .rx
            .tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.twoBlock?()
            })
            .disposed(by: disposeBag)
        
    }
}
