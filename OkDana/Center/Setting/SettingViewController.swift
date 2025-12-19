//
//  SettingViewController.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/15.
//

import UIKit
import SnapKit
import TYAlertController
import Contacts
import RxSwift
import RxCocoa
import RxGesture
import Kingfisher

class SettingViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel = SettingListViewModel()
    
    var modelArray: [other_urlModel]? {
        didSet {
            
        }
    }
    
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.register(CenterTableViewCell.self, forCellReuseIdentifier: "CenterTableViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
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
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = .red
        return coverView
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
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.normalHeadView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(200)
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

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CenterTableViewCell", for: indexPath) as! CenterTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.otherModel = modelArray?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = modelArray?[indexPath.row]
        let inputs = model?.inputs ?? ""
        if inputs == "logout" {
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
        }else {
            self.goWebVc(with: inputs)
        }
    }
    
}
