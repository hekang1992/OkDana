//
//  AppNavView.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AppNavView: UIView {
    
    // MARK: - Public
    var backAction: (() -> Void)?
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - Views
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back_left_image"), for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight(500))
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        setupGradient()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }
    
    // MARK: - Public
    func setTitle(_ title: String?) {
        nameLabel.text = title
    }
}

// MARK: - Private
private extension AppNavView {
    
    func setupUI() {
        addSubview(contentView)
        contentView.addSubview(backButton)
        contentView.addSubview(nameLabel)
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(60)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 220, height: 30))
        }
    }
    
    func setupGradient() {
        gradientLayer.colors = [
            UIColor(hex: "#48CC4D").cgColor,
            UIColor(hex: "#48CC4D").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5) // 0°
        gradientLayer.endPoint   = CGPoint(x: 1, y: 0.5)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func bindActions() {
        backButton.rx.tap
            .bind { [weak self] in
                self?.backAction?()
            }
            .disposed(by: disposeBag)
    }
}
