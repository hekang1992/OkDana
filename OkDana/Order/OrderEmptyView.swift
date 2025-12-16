//
//  OrderEmptyView.swift
//  OkDana
//
//  Created by hekang on 2025/12/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OrderEmptyView: UIView {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    var applyBlock: (() -> Void)?
    
    // MARK: - UI Components
    
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty_bg_image")
        return imageView
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = LanguageManager.localizedString(for: "There are no orders at this time.")
        label.textColor = UIColor(hex: "#B2AEAE")
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    private lazy var applyBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(LanguageManager.localizedString(for: "Apply"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setBackgroundImage(UIImage(named: "em_bt_image"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        addSubview(bgImageView)
        addSubview(descLabel)
        addSubview(applyBtn)
    }
    
    private func setupConstraints() {
        bgImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(50)
            make.size.equalTo(CGSize(width: 117, height: 117))
        }
        
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(1)
            make.centerX.equalToSuperview()
            make.height.equalTo(12)
        }
        
        applyBtn.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 142, height: 38))
        }
    }
    
    private func setupBindings() {
        applyBtn.rx.tap
            .bind(onNext: { [weak self] in
                self?.applyBlock?()
            })
            .disposed(by: disposeBag)
    }
}
