//
//  CenterView.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class CenterView: UIView {
    
    // MARK: - Properties
    
    var cellBlock: ((easierModel) -> Void)?
    
    var mentBlock: (() -> Void)?
    
    var modelArray: [easierModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    private let horizontalMargin: CGFloat = 20
    
    private let contentWidth: CGFloat = 335.pix()
    
    // MARK: - UI Components
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cen_ic_lo_image")
        imageView.layer.cornerRadius = 29
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#3D3D3D")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = LanguageManager.localizedString(for: "Welcome to OK Dana!")
        label.textColor = UIColor(hex: "#AEAEAE")
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        let code = LanguageManager.currentLanguage
        let imageName = code == .id ? "id_cen_li_image" : "en_cen_li_image"
        imageView.image = UIImage(named: imageName)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CenterTableViewCell.self, forCellReuseIdentifier: "CenterTableViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        return tableView
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
        // Add user info views
        [iconImageView, phoneLabel, descLabel].forEach { addSubview($0) }
        
        // Add scroll view with content
        addSubview(scrollView)
        [bannerImageView, tableView].forEach { scrollView.addSubview($0) }
    }
    
    private func setupConstraints() {
        setupUserInfoConstraints()
        setupScrollViewConstraints()
        setupContentConstraints()
    }
    
    private func setupUserInfoConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(66)
            make.leading.equalToSuperview().offset(horizontalMargin)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.top.equalTo(iconImageView.snp.top).offset(6)
            make.height.equalTo(22)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(phoneLabel)
            make.top.equalTo(phoneLabel.snp.bottom).offset(5)
            make.height.equalTo(18)
        }
    }
    
    private func setupScrollViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupContentConstraints() {
        let bannerHeight: CGFloat = 114.pix()
        
        bannerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(contentWidth)
            make.height.equalTo(bannerHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(contentWidth)
            make.height.equalTo(444.pix())
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        bannerImageView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.mentBlock?()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public Methods
    
    func updatePhoneNumber(_ phone: String) {
        phoneLabel.text = phone
    }
}

// MARK: - UITableView DataSource & Delegate
extension CenterView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CenterTableViewCell",
            for: indexPath
        ) as! CenterTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.model = modelArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        cellBlock?(modelArray[indexPath.row])
    }
}

// MARK: - Constants
extension CenterView {
    private enum Constants {
        static let iconSize: CGFloat = 66
        static let bannerHeight: CGFloat = 114
        static let tableHeight: CGFloat = 444
        static let spacing: CGFloat = 30
        static let smallSpacing: CGFloat = 5
    }
}
