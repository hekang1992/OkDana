//
//  LoginView.swift
//  OkDana
//
//  Created by hekang on 2025/12/13.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class LoginView: UIView {
    
    let disposeBag = DisposeBag()
    
    var backBlock: (() -> Void)?
    
    var codeBlock: (() -> Void)?
    
    var voiceBlock: (() -> Void)?
    
    var loginBlock: (() -> Void)?
    
    var mentBlock: (() -> Void)?
    
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
        loginBtn.setTitle(LanguageManager.localizedString(for: "Log In"), for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        loginBtn.setBackgroundImage(UIImage(named: "login_btn_image"), for: .normal)
        loginBtn.adjustsImageWhenHighlighted = false
        return loginBtn
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel(frame: .zero)
        oneLabel.text = LanguageManager.localizedString(for: "+91")
        oneLabel.textAlignment = .center
        oneLabel.textColor = UIColor(hex: "#000000")
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(400))
        return oneLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.layer.cornerRadius = 2
        lineView.layer.masksToBounds = true
        lineView.backgroundColor = UIColor.init(hex: "#BDBDBD")
        return lineView
    }()
    
    lazy var phoneTextFiled: UITextField = {
        let phoneTextFiled = UITextField()
        phoneTextFiled.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: LanguageManager.localizedString(for: "Please Enter Your Phone Number"), attributes: [
            .foregroundColor: UIColor.init(hex: "#BDBDBD") as Any,
            .font: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(500))
        ])
        phoneTextFiled.attributedPlaceholder = attrString
        phoneTextFiled.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(500))
        phoneTextFiled.textColor = UIColor.init(hex: "#333333")
        return phoneTextFiled
    }()
    
    lazy var codeTextFiled: UITextField = {
        let codeTextFiled = UITextField()
        codeTextFiled.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: LanguageManager.localizedString(for: "Please Enter Verification Code"), attributes: [
            .foregroundColor: UIColor.init(hex: "#BDBDBD") as Any,
            .font: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(500))
        ])
        codeTextFiled.attributedPlaceholder = attrString
        codeTextFiled.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(500))
        codeTextFiled.textColor = UIColor.init(hex: "#333333")
        return codeTextFiled
    }()
    
    lazy var codeBtn: UIButton = {
        let codeBtn = UIButton(type: .custom)
        codeBtn.setTitle(LanguageManager.localizedString(for: "Get Code"), for: .normal)
        codeBtn.setTitleColor(UIColor.init(hex: "#00CA5D"), for: .normal)
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(400))
        codeBtn.titleLabel?.textAlignment = .right
        return codeBtn
    }()
    
    lazy var clineView: UIView = {
        let clineView = UIView()
        clineView.backgroundColor = UIColor(hex: "#00CA5D")
        return clineView
    }()
    
    lazy var dlineView: UIView = {
        let dlineView = UIView()
        dlineView.backgroundColor = UIColor(hex: "#C0C0C0")
        return dlineView
    }()
    
    lazy var mentBtn: UIButton = {
        let mentBtn = UIButton(type: .custom)
        mentBtn.isSelected = true
        mentBtn.setImage(UIImage(named: "ment_nor_image"), for: .normal)
        mentBtn.setImage(UIImage(named: "ment_sel_image"), for: .selected)
        mentBtn.addTarget(self, action: #selector(mentClick(_:)), for: .touchUpInside)
        return mentBtn
    }()
    
    lazy var mentLabel: UILabel = {
        let mentLabel = UILabel()
        mentLabel.numberOfLines = 0
        mentLabel.textAlignment = .center
        mentLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(300))
        mentLabel.textColor = UIColor.init(hex: "#D9D9D9")
        let fullText = LanguageManager.localizedString(for: "I have agreed to all the terms of the <Privacy Policy>.")
        let policyText = LanguageManager.localizedString(for: "<Privacy Policy>")
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: attributedString.length))
        if let range = fullText.range(of: policyText) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
        }
        mentLabel.attributedText = attributedString
        return mentLabel
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let code = LanguageManager.currentLanguage
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
        
        oneView.addSubview(oneLabel)
        oneView.addSubview(lineView)
        oneView.addSubview(phoneTextFiled)
        twoView.addSubview(codeTextFiled)
        twoView.addSubview(codeBtn)
        codeBtn.addSubview(clineView)
        contentView.addSubview(dlineView)
        whiteView.addSubview(stackView)
        
        stackView.addArrangedSubview(mentBtn)
        stackView.addArrangedSubview(mentLabel)
        
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
        
        oneLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 43, height: 40))
        }
        
        lineView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(oneLabel.snp.right)
            make.size.equalTo(CGSize(width: 1, height: 25))
        }
        
        phoneTextFiled.snp.makeConstraints { make in
            make.left.equalTo(lineView.snp.right).offset(13)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }
        
        codeTextFiled.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-130)
            make.height.equalTo(30)
        }
        
        codeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(15)
            if code == .id {
                make.width.equalTo(105)
            }else {
                make.width.equalTo(70)
            }
            make.right.equalToSuperview().offset(-8)
        }
        
        clineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        dlineView.snp.makeConstraints { make in
            make.left.right.equalTo(voiceLabel)
            make.bottom.equalTo(voiceLabel).offset(0.5)
            make.height.equalTo(1)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 280, height: 30))
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-15)
        }
        
        codeBtn
            .rx
            .tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.codeBlock?()
            })
            .disposed(by: disposeBag)
        
        voiceLabel
            .rx
            .tapGesture()
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.voiceBlock?()
            })
            .disposed(by: disposeBag)
        
        loginBtn
            .rx
            .tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.loginBlock?()
            })
            .disposed(by: disposeBag)
        
        mentLabel
            .rx
            .tapGesture()
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.mentBlock?()
            })
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoginView {
    
    @objc private func btnClick() {
        self.backBlock?()
    }
    
    @objc private func mentClick(_ btn: UIButton) {
        btn.isSelected.toggle()
    }
    
}
