//
//  SettingViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import SnapKit
import TYAlertController
import Contacts
import RxSwift
import RxCocoa
import RxGesture

class SettingViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel = SettingListViewModel()
    
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
    
    lazy var oneListView: SettingListView = {
        let oneListView = SettingListView()
        oneListView.iconImageView.image = UIImage(named: "set_li_one_image")
        oneListView.nameLabel.text = LanguageManager.localizedString(for: "Privacy Policy")
        return oneListView
    }()
    
    lazy var twoListView: SettingListView = {
        let twoListView = SettingListView()
        twoListView.iconImageView.image = UIImage(named: "set_li_two_image")
        twoListView.nameLabel.text = LanguageManager.localizedString(for: "Loan Terms")
        return twoListView
    }()
    
    lazy var threeListView: SettingListView = {
        let threeListView = SettingListView()
        threeListView.iconImageView.image = UIImage(named: "set_li_three_image")
        threeListView.nameLabel.text = LanguageManager.localizedString(for: "Log Out")
        return threeListView
    }()
    
    lazy var deleteLabel: UILabel = {
        let deleteLabel = UILabel()
        deleteLabel.text = LanguageManager.localizedString(for: "Delete")
        deleteLabel.textColor = UIColor.init(hex: "#B4B4B4")
        deleteLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(400))
        deleteLabel.textAlignment = .center
        deleteLabel.isUserInteractionEnabled = true
        return deleteLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(hex: "#B4B4B4")
        return lineView
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
            self?.navigationController?.popToRootViewController(animated: true)
        }
        normalHeadView.nameLabel.text = LanguageManager.localizedString(for: "Set Up")
        
        view.addSubview(oneListView)
        view.addSubview(twoListView)
        view.addSubview(threeListView)
        
        oneListView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 335.pix(), height: 45))
            make.top.equalTo(normalHeadView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        twoListView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 335.pix(), height: 45))
            make.top.equalTo(oneListView.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
        }
        
        threeListView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 335.pix(), height: 45))
            make.top.equalTo(twoListView.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(deleteLabel)
        deleteLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.equalTo(17)
        }
        
        deleteLabel.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        
        oneListView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            ToastManager.showMessage(message: "1")
        }
        
        twoListView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            ToastManager.showMessage(message: "2")
        }
        
        threeListView.tapClickBlock = { [weak self] in
            guard let self = self else { return }
            let popView = AlertLogoutView(frame: self.view.bounds)
            let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)
            self.present(alertVc!, animated: true)
            
            popView.oneBlock = {
                self.dismiss(animated: true)
            }
            
            popView.twoBlock = { [weak self] in
                guard let self = self else { return }
                Task {
                    await self.logoutInfo()
                }
            }
        }
        
        deleteLabel
            .rx
            .tapGesture()
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }
                let popView = AlertDeleteView(frame: self.view.bounds)
                let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)
                self.present(alertVc!, animated: true)
                
                popView.oneBlock = {
                    self.dismiss(animated: true)
                }
                
                popView.twoBlock = { [weak self] in
                    guard let self = self else { return }
                    if !popView.clickBtn.isSelected {
                        ToastManager.showMessage(message: LanguageManager.localizedString(for: "Please read and agree to the above content"))
                        return
                    }
                    Task {
                        await self.deleteAccountInfo()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = bgView.bounds
    }
}

extension SettingViewController {
    
    private func logoutInfo() async {
        do {
            let model = try await viewModel.logoutInfo()
            if model.somewhat == 0 {
                LoginConfig.clear()
                try? await Task.sleep(nanoseconds: 100_000_000)
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil)
                }
            }
            ToastManager.showMessage(message: model.conversion ?? "")
        } catch  {
            
        }
    }
    
    private func deleteAccountInfo() async {
        do {
            let model = try await viewModel.deleteAccountInfo()
            if model.somewhat == 0 {
                LoginConfig.clear()
                try? await Task.sleep(nanoseconds: 100_000_000)
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil)
                }
            }
            ToastManager.showMessage(message: model.conversion ?? "")
        } catch  {
            
        }
    }
    
}
