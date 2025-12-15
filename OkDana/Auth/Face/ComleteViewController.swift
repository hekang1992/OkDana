//
//  ComleteViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import TYAlertController
import Kingfisher

class ComleteViewController: BaseViewController {
    
    var productID: String = ""
    
    var modelArray: [combiningModel] = []
    
    var stepArray: [StepModel] = []
    
    let viewModel = ProductViewModel()
    
    let disposeBag = DisposeBag()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "#F5F5F5").cgColor,
            UIColor(hex: "#DDFFDD").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect.zero
        bgView.layer.insertSublayer(gradientLayer, at: 0)
        return bgView
    }()
    
    private var gradientLayer: CAGradientLayer? {
        return bgView.layer.sublayers?.first as? CAGradientLayer
    }
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: UIFont.Weight(500))
        button.setBackgroundImage(UIImage(named: "netx_bg_image"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.setTitle(LanguageManager.localizedString(for: "Next"), for: .normal)
        return button
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        let code = LanguageManager.currentLanguage
        bgImageView.image = code == .id ? UIImage(named: "com_id_li_image") : UIImage(named: "com_en_li_image")
        return bgImageView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 8
        whiteView.layer.masksToBounds = true
        return whiteView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor(hex: "#585858")
        descLabel.textAlignment = .left
        descLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(500))
        descLabel.text = LanguageManager.localizedString(for: "Certification Information")
        return descLabel
    }()
    
    lazy var oneListView: CompeteListView = {
        let oneListView = CompeteListView()
        oneListView.oneLabel.text = LanguageManager.localizedString(for: "Name")
        oneListView.twoLabel.text = LoginConfig.currentName
        return oneListView
    }()
    
    lazy var twoListView: CompeteListView = {
        let twoListView = CompeteListView()
        twoListView.oneLabel.text = LanguageManager.localizedString(for: "ID")
        twoListView.twoLabel.text = LoginConfig.currentNumber
        return twoListView
    }()
    
    lazy var threeListView: CompeteListView = {
        let threeListView = CompeteListView()
        threeListView.oneLabel.text = LanguageManager.localizedString(for: "Birthday")
        threeListView.twoLabel.text = LoginConfig.currentTime
        return threeListView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.isHidden = true
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        bgView.addSubview(normalHeadView)
        normalHeadView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        normalHeadView.backAction = { [weak self] in
            self?.backToListPageVc()
        }
        
        let stepView = StepIndicatorView()
        view.addSubview(stepView)
        
        stepView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(normalHeadView.snp.bottom).offset(15)
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(20)
        }
        
        for (index, _) in modelArray.enumerated() {
            stepArray.append(StepModel(title: "\(index + 1)", isCurrent: (index < 1)))
        }
        stepView.models = stepArray
        
        self.normalHeadView.setTitle(modelArray[0].geometric ?? "")
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.size.equalTo(CGSize(width: 313, height: 50))
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-10)
        }
        
        scrollView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 268, height: 201))
        }
        
        scrollView.addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335, height: 204))
            make.bottom.equalToSuperview().offset(-20)
        }
        
        nextButton.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.backToListPageVc()
        }).disposed(by: disposeBag)
        
        whiteView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(12)
            make.height.equalTo(18)
        }
        
        whiteView.addSubview(oneListView)
        whiteView.addSubview(twoListView)
        whiteView.addSubview(threeListView)
        
        oneListView.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(11)
            make.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        twoListView.snp.makeConstraints { make in
            make.top.equalTo(oneListView.snp.bottom).offset(14)
            make.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        threeListView.snp.makeConstraints { make in
            make.top.equalTo(twoListView.snp.bottom).offset(14)
            make.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = bgView.bounds
    }
}

extension ComleteViewController {
    
    
}


class CompeteListView: UIView {
    
    lazy var oneView: UIView = {
        let oneView = UIView(frame: .zero)
        oneView.layer.cornerRadius = 5
        oneView.layer.masksToBounds = true
        oneView.backgroundColor = UIColor(hex: "#F5F5F5")
        return oneView
    }()
   
     lazy var oneLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#9C9C9C")
        label.font = .systemFont(ofSize: 12, weight: UIFont.Weight(300))
        label.textAlignment = .left
        return label
    }()
    
     lazy var twoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#3B3B3B")
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight(500))
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneView)
        oneView.addSubview(oneLabel)
        oneView.addSubview(twoLabel)
        
        oneView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(36)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(36)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(36)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
