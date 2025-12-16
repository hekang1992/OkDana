//
//  OrderEmptyView.swift
//  OkDana
//
//  Created by hekang on 2025/12/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OrderEmptyView: UIView {
    
    let disposeBag = DisposeBag()
    
    var applyBlock: (() -> Void)?

    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "empty_bg_image")
        return bgImageView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.text = LanguageManager.localizedString(for: "There are no orders at this time.")
        descLabel.textColor = UIColor.init(hex: "#B2AEAE")
        descLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(400))
        return descLabel
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitle(LanguageManager.localizedString(for: "Apply"), for: .normal)
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        applyBtn.setBackgroundImage(UIImage(named: "em_bt_image"), for: .normal)
        applyBtn.adjustsImageWhenHighlighted = false
        return applyBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(descLabel)
        addSubview(applyBtn)
        
        bgImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.size.equalTo(CGSize(width: 117, height: 117))
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(1)
            make.centerX.equalToSuperview()
            make.height.equalTo(12)
        }
        applyBtn.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 142, height: 38))
        }
        
        applyBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.applyBlock?()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
