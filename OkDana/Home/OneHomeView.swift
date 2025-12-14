//
//  OneHomeView.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OneHomeView: UIView {
    
    let disposeBag = DisposeBag()
    
    var clickBlock: ((String) -> Void)?
    
    var model: despiteModel? {
        didSet {
            guard let model = model else { return }
            oneLabel.text = model.actual ?? ""
            twoLabel.text = model.rational ?? ""
            threeLabel.text = "\(model.discretized ?? ""):"
            fourLabel.text = model.obstacle ?? ""
            let applyStr = model.hierarchy ?? ""
            applyBtn.setTitle(applyStr, for: .normal)
        }
    }
    
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
        twoImageView.isUserInteractionEnabled = true
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
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textColor = UIColor.init(hex: "#B1B0B0")
        oneLabel.textAlignment = .center
        oneLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(400))
        return oneLabel
    }()
    
    lazy var oneLineImageView: UIImageView = {
        let oneLineImageView = UIImageView()
        oneLineImageView.image = UIImage(named: "head_line_bg_image")
        return oneLineImageView
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textColor = UIColor.init(hex: "#6DD54C")
        twoLabel.textAlignment = .center
        twoLabel.font = UIFont.systemFont(ofSize: 56, weight: UIFont.Weight(600))
        return twoLabel
    }()
    
    lazy var twoLineImageView: UIImageView = {
        let twoLineImageView = UIImageView()
        twoLineImageView.image = UIImage(named: "head_line_bg_image")
        return twoLineImageView
    }()
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        threeLabel.textColor = UIColor.init(hex: "#B1B0B0")
        threeLabel.textAlignment = .left
        threeLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(300))
        return threeLabel
    }()
    
    lazy var fourLabel: UILabel = {
        let fourLabel = UILabel()
        fourLabel.textColor = UIColor.init(hex: "#3B3B3B")
        fourLabel.textAlignment = .left
        fourLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(300))
        return fourLabel
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setBackgroundImage(UIImage(named: "app_apply_btn_image"), for: .normal)
        applyBtn.setTitleColor(UIColor.init(hex: "#FFFFFF"), for: .normal)
        applyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return applyBtn
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        return clickBtn
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
        
        twoImageView.addSubview(oneLabel)
        twoImageView.addSubview(oneLineImageView)
        twoImageView.addSubview(twoLabel)
        twoImageView.addSubview(twoLineImageView)
        twoImageView.addSubview(threeLabel)
        twoImageView.addSubview(fourLabel)
        twoImageView.addSubview(applyBtn)
        twoImageView.addSubview(clickBtn)
        
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
        
        oneLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(35)
            make.height.equalTo(15)
        }
        
        oneLineImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 230, height: 1))
            make.top.equalTo(oneLabel.snp.bottom).offset(8)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneLineImageView.snp.bottom).offset(5)
            make.height.equalTo(60)
        }
        
        twoLineImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 230, height: 1))
            make.top.equalTo(twoLabel.snp.bottom).offset(5)
        }
        
        threeLabel.snp.makeConstraints { make in
            make.top.equalTo(twoLineImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview().offset(-40)
            make.height.equalTo(15)
        }
        
        fourLabel.snp.makeConstraints { make in
            make.centerY.equalTo(threeLabel)
            make.left.equalTo(threeLabel.snp.right).offset(5)
            make.height.equalTo(15)
        }
        
        applyBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
            make.size.equalTo(CGSize(width: 286, height: 52))
        }
        
        clickBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        clickBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            let productID = self.model?.arbitrary ?? 0
            self.clickBlock?(String(productID))
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
