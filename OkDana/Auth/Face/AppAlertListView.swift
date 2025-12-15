//
//  AppAlertListView.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AppAlertListView: UIView {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var clickBlock: ((String) -> Void)?
    
    // MARK: - UI Components
    private(set) lazy var nameLabel: UILabel = createNameLabel()
    private(set) lazy var bgView: UIView = createBackgroundView()
    lazy var nameTextFiled: UITextField = createNameTextField()
    lazy var iconImageView: UIImageView = createIconImageView()
    lazy var clickBtn: UIButton = createClickButton()
    
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
}

// MARK: - UI Creation Methods
extension AppAlertListView {
    
    private func createNameLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#2A2A2A")
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(400))
        return label
    }
    
    private func createBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F5F5F5")
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }
    
    private func createNameTextField() -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .default
        textField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(500))
        textField.textColor = UIColor(hex: "#3B3B3B")
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 10))
        textField.leftViewMode = .always
        return textField
    }
    
    private func createIconImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rclack_icon_image")
        return imageView
    }
    
    private func createClickButton() -> UIButton {
        let clickBtn = UIButton(type: .custom)
        return clickBtn
    }
}

// MARK: - Setup Methods
extension AppAlertListView {
    
    private func setupUI() {
        addSubviews()
    }
    
    private func addSubviews() {
        addSubview(nameLabel)
        addSubview(bgView)
        addSubview(clickBtn)
        
        bgView.addSubview(nameTextFiled)
        bgView.addSubview(iconImageView)
    }
    
    private func setupConstraints() {
        setupNameLabelConstraints()
        setupBackgroundViewConstraints()
        setupTextFieldConstraints()
        setupIconConstraints()
        setupButtonConstraints()
    }
    
    private func setupNameLabelConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(16)
        }
    }
    
    private func setupBackgroundViewConstraints() {
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(7)
            make.size.equalTo(CGSize(width: 335, height: 40))
        }
    }
    
    private func setupTextFieldConstraints() {
        nameTextFiled.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(40)
        }
    }
    
    private func setupIconConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
    }
    
    private func setupButtonConstraints() {
        clickBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Bindings
extension AppAlertListView {
    
    private func setupBindings() {
        bindButtonTap()
    }
    
    private func bindButtonTap() {
        clickBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let text = self.nameTextFiled.text ?? ""
                self.clickBlock?(text)
            })
            .disposed(by: disposeBag)
    }
}
