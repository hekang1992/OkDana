//
//  CardView.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/15.
//

import UIKit
import SnapKit

class CardView: UIView {
    
    var tapClickBlock: (() -> Void)?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        let code = LanguageManager.currentLanguage
        oneImageView.image = code == .id ? UIImage(named: "id_one_s_image") : UIImage(named: "en_one_s_image")
        return oneImageView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView(frame: .zero)
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 8
        whiteView.layer.masksToBounds = true
        return whiteView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        let code = LanguageManager.currentLanguage
        twoImageView.image = code == .id ? UIImage(named: "id_card_list_image") : UIImage(named: "en_card_list_image")
        return twoImageView
    }()
    
    lazy var leftImageView: UIImageView = {
        let leftImageView = UIImageView()
        leftImageView.image = UIImage(named: "id_plca_image")
        leftImageView.layer.cornerRadius = 5
        leftImageView.layer.masksToBounds = true
        return leftImageView
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "up_bu_ic_image")
        return rightImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.text = LanguageManager.localizedString(for: "Upload")
        nameLabel.textColor = UIColor.init(hex: "#FFFFFF")
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        descLabel.text = LanguageManager.localizedString(for: "Ensure that the ID card border is complete and there is no strong reflection when taking the photo.")
        descLabel.textColor = UIColor.init(hex: "#939090")
        descLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(300))
        return descLabel
    }()
    
    lazy var lineView: DashedLineView = {
        let lineView = DashedLineView(frame: .zero)
        return lineView
    }()
    
    lazy var footImageView: UIImageView = {
        let footImageView = UIImageView()
        let code = LanguageManager.currentLanguage
        footImageView.image = code == .id ? UIImage(named: "cs_id_fot_image") : UIImage(named: "fc_en_fot_image")
        return footImageView
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        clickBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return clickBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(oneImageView)
        scrollView.addSubview(whiteView)
        whiteView.addSubview(twoImageView)
        whiteView.addSubview(leftImageView)
        whiteView.addSubview(rightImageView)
        rightImageView.addSubview(nameLabel)
        whiteView.addSubview(descLabel)
        whiteView.addSubview(lineView)
        whiteView.addSubview(footImageView)
        whiteView.addSubview(clickBtn)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        oneImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 282, height: 30))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(29)
        }
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(362)
            make.width.equalTo(335)
            make.bottom.equalToSuperview().offset(-20)
        }
        twoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
        }
        leftImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(50)
            make.size.equalTo(CGSize(width: 164, height: 97))
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalTo(leftImageView)
            make.size.equalTo(CGSize(width: 130, height: 36))
            make.right.equalToSuperview().offset(-10)
        }
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(leftImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.height.equalTo(1)
            make.top.equalTo(descLabel.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
        }
        footImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(16)
            make.size.equalTo(CGSize(width: 299, height: 102))
        }
        clickBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardView {
    
    @objc private func btnClick() {
        self.tapClickBlock?()
    }
    
}
