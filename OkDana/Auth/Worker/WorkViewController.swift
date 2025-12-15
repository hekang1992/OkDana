//
//  WorkViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import SnapKit

class WorkViewController: BaseViewController {
    
    var productID: String = ""
    var modelArray: [combiningModel] = []
    var stepArray: [StepModel] = []
    
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
            stepArray.append(StepModel(title: "\(index + 1)", isCurrent: (index < 3)))
        }
        stepView.models = stepArray
        
        self.normalHeadView.setTitle(modelArray[0].geometric ?? "")
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.size.equalTo(CGSize(width: 313, height: 50))
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = bgView.bounds
    }
}
