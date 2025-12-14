//
//  OneHomeView.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import UIKit
import SnapKit

class OneHomeView: UIView {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        return bgView
    }()
    
    lazy var headView: UIView = {
        let headView = UIView()
        headView.backgroundColor = UIColor(hex: "#48CC4D")
        return headView
    }()
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "head_one_image")
        return headImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "head_two_image")
        return twoImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        let code = LanguageManager.currentLanguage
        threeImageView.image = code == .id ? UIImage(named: "id_head_three_image") : UIImage(named: "head_three_image")
        return threeImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = LanguageManager.localizedString(for: "Welcome !")
        nameLabel.textColor = UIColor.init(hex: "#FFFFFF")
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var fourImageView: UIImageView = {
        let fourImageView = UIImageView()
        let code = LanguageManager.currentLanguage
        fourImageView.image = code == .id ? UIImage(named: "id_foot_image") : UIImage(named: "en_foot_image")
        return fourImageView
    }()
    
    lazy var leftLabel: UILabel = {
        let leftLabel = UILabel(frame: .zero)
        leftLabel.text = LanguageManager.localizedString(for: "Privacy Policy")
        leftLabel.textAlignment = .center
        leftLabel.textColor = UIColor(hex: "#808080")
        leftLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(300))
        return leftLabel
    }()
    
    lazy var rightLabel: UILabel = {
        let rightLabel = UILabel(frame: .zero)
        rightLabel.text = LanguageManager.localizedString(for: "Loan Terms")
        rightLabel.textAlignment = .center
        rightLabel.textColor = UIColor(hex: "#808080")
        rightLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(300))
        return rightLabel
    }()
    
    lazy var leftView: UIView = {
        let leftView = UIView()
        leftView.backgroundColor = UIColor.init(hex: "#808080")
        return leftView
    }()
    
    lazy var rightView: UIView = {
        let rightView = UIView()
        rightView.backgroundColor = UIColor.init(hex: "#808080")
        return rightView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        addSubview(scrollView)
        scrollView.addSubview(bgView)
        bgView.addSubview(headImageView)
        bgView.addSubview(twoImageView)
        headImageView.addSubview(threeImageView)
        headImageView.addSubview(nameLabel)
        bgView.addSubview(fourImageView)
        bgView.addSubview(leftLabel)
        bgView.addSubview(rightLabel)
        leftLabel.addSubview(leftView)
        rightLabel.addSubview(rightView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.greaterThanOrEqualTo(scrollView).priority(.low)
        }
        headImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(253)
        }
        twoImageView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(-45)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(241)
        }
        threeImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.size.equalTo(CGSize(width: 353, height: 161))
            make.bottom.equalToSuperview().offset(-45)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(24)
        }
        fourImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(twoImageView.snp.bottom).offset(21)
            make.width.equalTo(335)
            make.bottom.equalToSuperview().offset(-40)
        }
        leftLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(90)
            make.top.equalTo(fourImageView.snp.bottom).offset(14)
            make.size.equalTo(CGSize(width: 95, height: 16))
        }
        rightLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-90)
            make.top.equalTo(fourImageView.snp.bottom).offset(14)
            make.size.equalTo(CGSize(width: 81, height: 16))
        }
        leftView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        rightView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
