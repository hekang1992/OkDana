//
//  OneHomeView.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OneHomeView: UIView {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var clickBlock: ((String) -> Void)?
    
    var model: despiteModel? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - UI Components
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#48CC4D")
        return view
    }()
    
    // MARK: - Header Images
    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "head_one_image")
        return imageView
    }()
    
    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "head_two_image")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var decorativeImageView: UIImageView = {
        let imageView = UIImageView()
        let code = LanguageManager.currentLanguage
        imageView.image = code == .id ? UIImage(named: "id_head_three_image") : UIImage(named: "head_three_image")
        return imageView
    }()
    
    private lazy var footerImageView: UIImageView = {
        let imageView = UIImageView()
        let code = LanguageManager.currentLanguage
        imageView.image = code == .id ? UIImage(named: "id_foot_image") : UIImage(named: "en_foot_image")
        return imageView
    }()
    
    // MARK: - Labels
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageManager.localizedString(for: "Welcome !")
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(500))
        return label
    }()
    
    lazy var privacyLabel: UILabel = {
        createLinkLabel(text: LanguageManager.localizedString(for: "Privacy Policy"))
    }()
    
    lazy var termsLabel: UILabel = {
        createLinkLabel(text: LanguageManager.localizedString(for: "Loan Terms"))
    }()
    
    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#808080")
        return view
    }()
    
    // MARK: - Card Content
    private lazy var actualLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#B1B0B0")
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#6DD54C")
        label.font = UIFont.systemFont(ofSize: 56, weight: UIFont.Weight(600))
        label.textAlignment = .center
        return label
    }()
    
    private lazy var limitLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#B1B0B0")
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(300))
        label.textAlignment = .left
        return label
    }()
    
    private lazy var loanLimitLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#3B3B3B")
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(300))
        label.textAlignment = .left
        return label
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "app_apply_btn_image"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return button
    }()
    
    private lazy var oneLineImageView: UIImageView = {
        let oneLineImageView = UIImageView()
        oneLineImageView.image = UIImage(named: "head_line_bg_image")
        return oneLineImageView
    }()
    
    private lazy var twoLineImageView: UIImageView = {
        let twoLineImageView = UIImageView()
        twoLineImageView.image = UIImage(named: "head_line_bg_image")
        return twoLineImageView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        bindEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        addSubview(headerView)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerImageView)
        headerImageView.addSubview(decorativeImageView)
        headerImageView.addSubview(welcomeLabel)
        
        contentView.addSubview(cardImageView)
        contentView.addSubview(footerImageView)
        
        setupCardContent()
        setupFooterLinks()
    }
    
    private func setupCardContent() {
        cardImageView.addSubview(actualLabel)
        cardImageView.addSubview(amountLabel)
        cardImageView.addSubview(oneLineImageView)
        cardImageView.addSubview(twoLineImageView)
        cardImageView.addSubview(limitLabel)
        cardImageView.addSubview(loanLimitLabel)
        cardImageView.addSubview(applyButton)
        
        // 添加点击区域
        let tapButton = UIButton()
        cardImageView.addSubview(tapButton)
        tapButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleCardTap()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupFooterLinks() {
        contentView.addSubview(privacyLabel)
        contentView.addSubview(termsLabel)
        
        // 添加下划线
        privacyLabel.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        let termsLineView = UIView()
        termsLineView.backgroundColor = UIColor(hex: "#808080")
        termsLabel.addSubview(termsLineView)
        termsLineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func setupConstraints() {
        // Header View
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        // Scroll View
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        // Header Image
        headerImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(253)
        }
        
        decorativeImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.size.equalTo(CGSize(width: 353, height: 161))
            make.bottom.equalToSuperview().offset(-45)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(24)
        }
        
        // Card
        cardImageView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(-45)
            make.left.right.equalToSuperview()
            make.height.equalTo(241)
        }
        
        // Footer Image
        footerImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cardImageView.snp.bottom).offset(21)
            make.width.equalTo(335)
        }
        
        // Footer Links
        privacyLabel.snp.makeConstraints { make in
            make.top.equalTo(footerImageView.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(90)
            make.height.equalTo(16)
        }
        
        termsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(privacyLabel)
            make.right.equalToSuperview().offset(-90)
            make.height.equalTo(16)
        }
        
        // Card Content Constraints
        actualLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(35)
        }
        
        oneLineImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(actualLabel.snp.bottom).offset(8)
            make.width.equalTo(230)
            make.height.equalTo(1)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneLineImageView.snp.bottom).offset(5)
            make.height.equalTo(60)
        }
        
        cardImageView.addSubview(twoLineImageView)
        twoLineImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(amountLabel.snp.bottom).offset(5)
            make.width.equalTo(230)
            make.height.equalTo(1)
        }
        
        limitLabel.snp.makeConstraints { make in
            make.top.equalTo(twoLineImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview().offset(-40)
        }
        
        loanLimitLabel.snp.makeConstraints { make in
            make.centerY.equalTo(limitLabel)
            make.left.equalTo(limitLabel.snp.right).offset(5)
        }
        
        applyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
            make.size.equalTo(CGSize(width: 286, height: 52))
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(privacyLabel.snp.bottom).offset(20)
        }
    }
    
    private func bindEvents() {
        applyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.handleApplyTap()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper Methods
    private func createLinkLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#808080")
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.isUserInteractionEnabled = true
        return label
    }
    
    private func createCardSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(hex: "#B1B0B0")
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        return label
    }
    
    private func updateUI() {
        guard let model = model else { return }
        
        actualLabel.text = model.actual ?? ""
        amountLabel.text = model.rational ?? ""
        limitLabel.text = "\(model.discretized ?? ""):"
        loanLimitLabel.text = model.obstacle ?? ""
        applyButton.setTitle(model.hierarchy ?? "", for: .normal)
    }
    
    private func handleCardTap() {
        guard let productID = model?.arbitrary else { return }
        clickBlock?(String(productID))
    }
    
    private func handleApplyTap() {
        handleCardTap()
    }
}
