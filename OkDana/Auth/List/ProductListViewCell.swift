//
//  ProductListViewCell.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/14.
//

import UIKit
import SnapKit

class ProductListViewCell: UITableViewCell {
    
    var model: combiningModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.geometric ?? ""
            descLabel.text = model.probabilistically ?? ""
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 37
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hex: "#FFFFFF")
        return bgView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "list_nor_01_image")
        return iconImageView
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        return rightImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor(hex: "#696969")
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(500))
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor(hex: "#9E9E9E")
        descLabel.numberOfLines = 0
        descLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(300))
        descLabel.textAlignment = .left
        return descLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.layer.cornerRadius = 5
        lineView.layer.masksToBounds = true
        lineView.backgroundColor = UIColor.init(hex: "#696969")
        return lineView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgView)
        bgView.addSubview(iconImageView)
        bgView.addSubview(rightImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(lineView)
        bgView.addSubview(descLabel)
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(74)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 74, height: 74))
        }
        
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-27)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(16)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(9)
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.height.equalTo(1)
            make.width.equalTo(150)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.top.equalTo(lineView.snp.bottom).offset(7)
            make.right.equalToSuperview().offset(-70)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
