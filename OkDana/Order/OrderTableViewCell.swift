//
//  OrderTableViewCell.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/16.
//

import UIKit
import SnapKit
import Kingfisher

class OrderTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var model: easierModel? {
        didSet {
            configureCell()
        }
    }
    
    // MARK: - UI Components
    private lazy var bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#3A3A3A")
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var lineView: DashedLineView = {
        return DashedLineView()
    }()
    
    private lazy var typeLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#FFFFFF")
        label.backgroundColor = UIColor(hex: "#FFAD1F")
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(500))
        return label
    }()
    
    private lazy var coverView: UIView = {
        return UIView()
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoImageView, nameLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Constants
    private enum Constants {
        static let contentInset: CGFloat = 20
        static let innerSpacing: CGFloat = 10
        static let logoSize: CGSize = CGSize(width: 20, height: 20)
        static let cellHeight: CGFloat = 160
        static let bottomSpacing: CGFloat = 20
        static let topSpacing: CGFloat = 9
        static let cornerRadius: CGFloat = 8
        static let typeLabelHeight: CGFloat = 28
        static let nameLabelHeight: CGFloat = 15
        static let lineHeight: CGFloat = 1
        static let listItemHeight: CGFloat = 28
        static let listItemSpacing: CGFloat = 10
    }
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(bgView)
        bgView.addSubview(headerStackView)
        bgView.addSubview(lineView)
        bgView.addSubview(typeLabel)
        bgView.addSubview(coverView)
    }
    
    private func setupConstraints() {
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.contentInset)
            make.trailing.equalToSuperview().offset(-Constants.contentInset)
            make.bottom.equalToSuperview().offset(-Constants.bottomSpacing)
            make.height.equalTo(Constants.cellHeight)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(Constants.logoSize)
        }
        
        headerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.topSpacing)
            make.leading.equalToSuperview().offset(Constants.topSpacing)
            make.trailing.lessThanOrEqualTo(typeLabel.snp.leading).offset(-5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(Constants.nameLabelHeight)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(Constants.innerSpacing)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.height.equalTo(Constants.lineHeight)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.height.equalTo(Constants.typeLabelHeight)
        }
        
        coverView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    // MARK: - Configuration
    private func configureCell() {
        guard let model = model else { return }
        
        if let logoUrl = model.subclass, !logoUrl.isEmpty {
            logoImageView.kf.setImage(with: URL(string: logoUrl))
        }
        
        nameLabel.text = model.pspace ?? ""
        typeLabel.text = model.hierarchy ?? ""
        
        setupCoverListView(with: model.optimizations ?? [])
    }
    
    // MARK: - Cover List Setup
    private func setupCoverListView(with modelArray: [optimizationsModel]) {
        // Clear existing views
        coverView.subviews.forEach { $0.removeFromSuperview() }
        
        guard !modelArray.isEmpty else { return }
        
        var previousView: UIView?
        
        for (index, item) in modelArray.enumerated() {
            let listView = OrderListView()
            listView.model = item
            coverView.addSubview(listView)
            
            // Configure style based on index
            configureListViewStyle(listView, at: index)
            
            // Setup constraints
            listView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(Constants.listItemHeight)
                
                if let previous = previousView {
                    make.top.equalTo(previous.snp.bottom).offset(Constants.listItemSpacing)
                } else {
                    make.top.equalToSuperview().offset(Constants.listItemSpacing)
                }
                
                // Last item
                if index == modelArray.count - 1 {
                    make.bottom.equalToSuperview().offset(-Constants.listItemSpacing)
                }
            }
            
            previousView = listView
        }
    }
    
    private func configureListViewStyle(_ listView: OrderListView, at index: Int) {
        if index == 0 {
            listView.twoLabel.textColor = UIColor(hex: "#4BCD4D")
            listView.twoLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(500))
        } else {
            listView.twoLabel.textColor = UIColor(hex: "#000000")
            listView.twoLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        }
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.kf.cancelDownloadTask()
        logoImageView.image = nil
        nameLabel.text = nil
        typeLabel.text = nil
        coverView.subviews.forEach { $0.removeFromSuperview() }
    }
}
