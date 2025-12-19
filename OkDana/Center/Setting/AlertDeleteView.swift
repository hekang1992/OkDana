//
//  AlertDeleteView.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AlertDeleteView: UIView {
    
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
        titleClabel.text = LanguageManager.localizedString(for: "Delete")
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
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        clickBtn.setImage(UIImage(named: "nor_del_image"), for: .normal)
        clickBtn.setImage(UIImage(named: "sel_del_image"), for: .selected)
        return clickBtn
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor(hex: "#FF0000")
        descLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(400))
        descLabel.textAlignment = .left
        descLabel.text = LanguageManager.localizedString(for: "I am aware of the risks.")
        return descLabel
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
        bgImageView.addSubview(clickBtn)
        bgImageView.addSubview(descLabel)
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
        
        clickBtn.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(55)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        descLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clickBtn.snp.centerY)
            make.left.equalTo(clickBtn.snp.right).offset(3)
            make.height.equalTo(16)
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
        
        clickBtn
            .rx
            .tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
            guard let self = self else { return }
            clickBtn.isSelected.toggle()
        }).disposed(by: disposeBag)
    }
}
