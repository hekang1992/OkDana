//
//  ProductTableViewCell.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/15.
//

import UIKit
import SnapKit
import Kingfisher

class ProductTableViewCell: UITableViewCell {

    var model: despiteModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.subclass ?? ""
            bgImageView.kf.setImage(with: URL(string: logoUrl))
            
            nameLabel.text = model.pspace ?? ""
            moneyLabel.text = model.rational ?? ""
            descLabel.text = model.actual ?? ""
            applyLabel.text = model.hierarchy ?? ""
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.layer.cornerRadius = 5
        bgImageView.layer.masksToBounds = true
        return bgImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#3A3A3A")
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .left
        moneyLabel.textColor = UIColor.init(hex: "#4BCD4D")
        moneyLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(700))
        return moneyLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .left
        descLabel.textColor = UIColor.init(hex: "#B4B4B4")
        descLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(400))
        return descLabel
    }()
    
    lazy var applyLabel: UILabel = {
        let applyLabel = UILabel()
        applyLabel.textAlignment = .center
        applyLabel.textColor = UIColor.init(hex: "#4BCD4D")
        applyLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(400))
        return applyLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(hex: "#4BCD4D")
        lineView.layer.cornerRadius = 2
        lineView.layer.masksToBounds = true
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgView)
        bgView.addSubview(bgImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(moneyLabel)
        bgView.addSubview(descLabel)
        bgView.addSubview(applyLabel)
        applyLabel.addSubview(lineView)
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(85)
            make.bottom.equalToSuperview().offset(-12)
        }
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(10)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bgImageView)
            make.left.equalTo(bgImageView.snp.right).offset(2)
            make.height.equalTo(16)
        }
        moneyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(bgImageView.snp.bottom).offset(8)
            make.height.equalTo(27)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(moneyLabel.snp.bottom).offset(2)
            make.height.equalTo(12)
        }
        applyLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-18)
            make.height.equalTo(17)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
