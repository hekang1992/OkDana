//
//  ProductView.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ProductView: UIView {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    var model: yvesModel? {
        didSet {
            updateHeaderView()
        }
    }
    
    var modelArray: [combiningModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var cellTapClickBlock: ((combiningModel) -> Void)?
    var nextClickBlock: (() -> Void)?
    
    // MARK: - UI Components
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "product_head_bg_image")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var actualLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#B1B0B0")
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#6DD54C")
        label.font = .systemFont(ofSize: 56, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 0.3)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductListViewCell.self, forCellReuseIdentifier: ProductListViewCell.identifier)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        return tableView
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight(500))
        button.setBackgroundImage(UIImage(named: "netx_bg_image"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        addSubview(backgroundImageView)
        addSubview(headerView)
        headerView.addSubview(actualLabel)
        headerView.addSubview(amountLabel)
        headerView.addSubview(separatorLine)
        addSubview(tableView)
        addSubview(nextButton)
    }
    
    private func setupConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(127)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(127)
        }
        
        actualLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(22)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(actualLabel.snp.bottom).offset(12)
        }
        
        separatorLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(230)
            make.height.equalTo(1)
            make.top.equalTo(amountLabel.snp.bottom).offset(12)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.width.equalTo(313)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-10)
        }
    }
    
    private func bindActions() {
        nextButton
            .rx
            .tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.nextClickBlock?()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Update Methods
    private func updateHeaderView() {
        guard let model = model else { return }
        actualLabel.text = model.disappear
        amountLabel.text = model.evaporation
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ProductView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .clear
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProductListViewCell.identifier,
            for: indexPath
        ) as? ProductListViewCell else {
            return UITableViewCell()
        }
        
        let model = modelArray[indexPath.row]
        cell.model = model
        cell.configure(with: model, at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < modelArray.count else { return }
        cellTapClickBlock?(modelArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension ProductListViewCell {
    func configure(with model: combiningModel, at index: Int) {
        self.model = model
        
        let isSelected = model.discovery == 1
        
        iconImageView.image = UIImage(
            named: isSelected ? "list_sel_0\(index + 1)_image" : "list_nor_0\(index + 1)_image"
        )
        
        rightImageView.image = UIImage(
            named: isSelected ? "list_sel_right_image" : "list_nor_right_image"
        )
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
