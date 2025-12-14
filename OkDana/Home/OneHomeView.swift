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

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        addSubview(scrollView)
        scrollView.addSubview(headImageView)
        scrollView.addSubview(twoImageView)
        headImageView.addSubview(threeImageView)
        headImageView.addSubview(nameLabel)
        scrollView.addSubview(fourImageView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
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
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
