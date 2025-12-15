//
//  TwoTableViewCell.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TwoTableViewCell: UITableViewCell {
    
    var model: systemModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.geometric ?? ""
            phoneTextField.placeholder = model.probabilistically ?? ""
            
            let never = model.never ?? ""
            phoneTextField.text = never
            
        }
    }
    
    // MARK: - Type Aliases
    typealias ClickHandler = () -> Void
    
    // MARK: - Constants
    private enum Constants {
        static let horizontalMargin: CGFloat = 20
        static let verticalSpacing: CGFloat = 8
        static let bottomInset: CGFloat = 20
        static let nameLabelHeight: CGFloat = 16
        static let bgViewHeight: CGFloat = 40
        static let bgViewCornerRadius: CGFloat = 4
        static let textFieldLeftPadding: CGFloat = 15
        static let textFieldRightInset: CGFloat = 40
        static let textFieldLeftViewWidth: CGFloat = 10
        static let iconSize: CGFloat = 24
        static let iconRightMargin: CGFloat = 5
        
        enum Colors {
            static let nameText = "#2A2A2A"
            static let placeholder = "#939393"
            static let textFieldText = "#2A2A2A"
            static let bgViewBackground = "#FFFFFF"
        }
        
        enum Fonts {
            static let nameLabel = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(400))
            static let placeholder = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(400))
            static let textField = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(400))
        }
        
        enum Images {
            static let icon = "rclack_icon_image"
        }
    }
    
    // MARK: - Properties
    var clickBlock: ClickHandler?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex: Constants.Colors.nameText)
        label.font = Constants.Fonts.nameLabel
        return label
    }()
    
    private lazy var backgroundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: Constants.Colors.bgViewBackground)
        view.layer.cornerRadius = Constants.bgViewCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        configureTextFieldAppearance(textField)
        setupTextFieldLeftView(textField)
        textField.keyboardType = .numberPad
        textField.isEnabled = false
        return textField
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Images.icon)
        return imageView
    }()
    
    private lazy var clickButton: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        bindButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Methods
private extension TwoTableViewCell {
    
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.addSubview(phoneTextField)
        backgroundContainerView.addSubview(iconImageView)
        contentView.addSubview(clickButton)
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.horizontalMargin)
            make.height.equalTo(Constants.nameLabelHeight)
        }
        
        backgroundContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(Constants.verticalSpacing)
            make.leading.equalToSuperview().offset(Constants.horizontalMargin)
            make.height.equalTo(Constants.bgViewHeight)
            make.bottom.equalToSuperview().offset(-Constants.bottomInset)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constants.textFieldRightInset)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Constants.iconRightMargin)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.iconSize)
        }
        
        clickButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureTextFieldAppearance(_ textField: UITextField) {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hex: Constants.Colors.placeholder) as Any,
            .font: Constants.Fonts.placeholder
        ]
        
        let placeholderString = LanguageManager.localizedString(for: "")
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderString,
            attributes: placeholderAttributes
        )
        
        textField.font = Constants.Fonts.textField
        textField.textColor = UIColor(hex: Constants.Colors.textFieldText)
    }
    
    func setupTextFieldLeftView(_ textField: UITextField) {
        let leftView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: Constants.textFieldLeftPadding,
                height: Constants.textFieldLeftViewWidth
            )
        )
        textField.leftView = leftView
        textField.leftViewMode = .always
    }
    
    func bindButton() {
        clickButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.clickBlock?()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Public Interface
extension TwoTableViewCell {
    func configure(with name: String, placeholder: String? = nil, text: String? = nil) {
        nameLabel.text = name
        phoneTextField.text = text
        
        if let placeholder = placeholder {
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(hex: Constants.Colors.placeholder) as Any,
                .font: Constants.Fonts.placeholder
            ]
            phoneTextField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: placeholderAttributes
            )
        }
    }
    
    var text: String? {
        get { phoneTextField.text }
        set { phoneTextField.text = newValue }
    }
    
    var isTextFieldEnabled: Bool {
        get { phoneTextField.isEnabled }
        set { phoneTextField.isEnabled = newValue }
    }
    
    func setIconImage(_ image: UIImage?) {
        iconImageView.image = image
    }
    
    func setIconImage(named imageName: String) {
        iconImageView.image = UIImage(named: imageName)
    }
}
