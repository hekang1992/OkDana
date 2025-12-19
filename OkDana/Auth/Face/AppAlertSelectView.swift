//
//  AppAlertSelectView.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AppAlertSelectView: UIView {
    
    var timeBlock: ((String) -> Void)?
    
    var modelArray: [nestModel]? {
        didSet {
            guard let modelArray = modelArray else { return }
            let oneModel = modelArray[0]
            let twoModel = modelArray[1]
            let threeModel = modelArray[2]
            
            oneListView.nameLabel.text = oneModel.food ?? ""
            twoListView.nameLabel.text = twoModel.food ?? ""
            threeListView.nameLabel.text = threeModel.food ?? ""
            
            oneListView.nameTextFiled.placeholder = oneModel.ants ?? ""
            twoListView.nameTextFiled.placeholder = twoModel.ants ?? ""
            threeListView.nameTextFiled.placeholder = threeModel.ants ?? ""
            
            oneListView.nameTextFiled.text = oneModel.ants ?? ""
            twoListView.nameTextFiled.text = twoModel.ants ?? ""
            threeListView.nameTextFiled.text = threeModel.ants ?? ""
            
        }
    }
    
    let disposeBag = DisposeBag()
    
    var cancelBlock: (() -> Void)?
    
    var confirmBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "alert_nor_bg_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = LanguageManager.localizedString(for: "Confirm Information")
        nameLabel.textColor = UIColor.init(hex: "#FFFFFF")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(UIImage(named: "cal_foc_a_image"), for: .normal)
        cancelBtn.adjustsImageWhenHighlighted = true
        return cancelBtn
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight(500))
        button.setBackgroundImage(UIImage(named: "netx_bg_image"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.setTitle(LanguageManager.localizedString(for: "Confirm"), for: .normal)
        return button
    }()
    
    lazy var oneListView: AppAlertListView = {
        let oneListView = AppAlertListView(frame: .zero)
        oneListView.iconImageView.isHidden = true
        oneListView.clickBtn.isHidden = true
        return oneListView
    }()
    
    lazy var twoListView: AppAlertListView = {
        let twoListView = AppAlertListView(frame: .zero)
        twoListView.iconImageView.isHidden = true
        twoListView.clickBtn.isHidden = true
        return twoListView
    }()
    
    lazy var threeListView: AppAlertListView = {
        let threeListView = AppAlertListView(frame: .zero)
        threeListView.iconImageView.isHidden = false
        threeListView.clickBtn.isHidden = false
        return threeListView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(nextButton)
        bgImageView.addSubview(oneListView)
        bgImageView.addSubview(twoListView)
        bgImageView.addSubview(threeListView)
        
        bgImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(411)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(20)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(33)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.right.equalToSuperview().offset(-20)
        }
        
        oneListView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(76)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        twoListView.snp.makeConstraints { make in
            make.top.equalTo(oneListView.snp.bottom).offset(18)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        threeListView.snp.makeConstraints { make in
            make.top.equalTo(twoListView.snp.bottom).offset(18)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 313, height: 50))
            make.bottom.equalToSuperview().offset(-30)
        }
        
        cancelBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.cancelBlock?()
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.confirmBlock?()
        }).disposed(by: disposeBag)
        
        threeListView.clickBlock = { [weak self] timeStr in
            guard let self = self else { return }
            self.timeBlock?(timeStr)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
