//
//  OrderTableViewCell.swift
//  OkDana
//
//  Created by hekang on 2025/12/16.
//

import UIKit
import SnapKit
import Kingfisher

class OrderTableViewCell: UITableViewCell {
    
    var model: easierModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.subclass ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.pspace ?? ""
            typeLabel.text = model.hierarchy ?? ""
            
            coverListView(with: model.optimizations ?? [])
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#3A3A3A")
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var lineView: DashedLineView = {
        let lineView = DashedLineView()
        return lineView
    }()
    
    lazy var typeLabel: PaddedLabel = {
        let typeLabel = PaddedLabel()
        typeLabel.textAlignment = .center
        typeLabel.textColor = UIColor.init(hex: "#FFFFFF")
        typeLabel.backgroundColor = UIColor(hex: "#FFAD1F")
        typeLabel.layer.cornerRadius = 6
        typeLabel.layer.masksToBounds = true
        typeLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(500))
        return typeLabel
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        return coverView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        bgView.addSubview(logoImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(lineView)
        bgView.addSubview(typeLabel)
        bgView.addSubview(coverView)
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview()
            make.height.equalTo(160)
            make.bottom.equalToSuperview().offset(-20)
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.left.equalToSuperview().offset(9)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(5)
            make.height.equalTo(15)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(10)
        }
        typeLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.height.equalTo(28)
        }
        coverView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OrderTableViewCell {
    
    private func coverListView(with modelArray: [optimizationsModel]) {
        coverView.subviews.forEach { $0.removeFromSuperview() }
        
        guard !modelArray.isEmpty else { return }
        
        var previousView: OrderListView?
        
        for (index, item) in modelArray.enumerated() {
            let listView = OrderListView()
            listView.model = item
            coverView.addSubview(listView)
            if index == 0 {
                listView.twoLabel.textColor = UIColor.init(hex: "#4BCD4D")
                listView.twoLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(500))
            }else {
                listView.twoLabel.textColor = UIColor.init(hex: "#000000")
                listView.twoLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
            }
            
            listView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(28)
                
                if let previous = previousView {
                    make.top.equalTo(previous.snp.bottom).offset(10)
                } else {
                    make.top.equalToSuperview().offset(10)
                }
                if index == modelArray.count - 1 {
                    make.bottom.lessThanOrEqualToSuperview().offset(-10)
                }
            }
            previousView = listView
        }
    }
    
}


