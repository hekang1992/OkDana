//
//  CenterTableViewCell.swift
//  OkDana
//
//  Created by hekang on 2025/12/16.
//

import UIKit
import SnapKit
import Kingfisher

class CenterTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var model: easierModel? {
        didSet {
            updateUI(with: model)
        }
    }
    
    var otherModel: other_urlModel? {
        didSet {
            updateUI(with: otherModel)
        }
    }
    
    // MARK: - UI Components
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex: "#2F2F2F")
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rclack_icon_image")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(bgView)
        bgView.addSubview(iconImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(rightImageView)
    }
    
    private func setupConstraints() {
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(18)
            make.size.equalTo(25)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(6)
            make.right.lessThanOrEqualTo(rightImageView.snp.left).offset(-8)
            make.height.equalTo(25)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-11)
            make.size.equalTo(24)
        }
    }
    
    // MARK: - Private Methods
    
    private func updateUI(with model: easierModel?) {
        guard let model = model else { return }
        configure(with: model.sanjeev, title: model.geometric)
    }
    
    private func updateUI(with model: other_urlModel?) {
        guard let model = model else { return }
        configure(with: model.sanjeev, title: model.geometric)
    }
    
    private func configure(with imageUrl: String?, title: String?) {
        if let urlString = imageUrl, let url = URL(string: urlString) {
            iconImageView.kf.setImage(with: url)
        } else {
            iconImageView.image = nil
        }
        
        nameLabel.text = title
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.kf.cancelDownloadTask()
        iconImageView.image = nil
        nameLabel.text = nil
    }
}
