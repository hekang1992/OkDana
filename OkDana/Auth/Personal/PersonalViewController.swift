//
//  PersonalViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import SnapKit
import TYAlertController

class PersonalViewController: BaseViewController {
    
    var productID: String = ""
    
    var modelArray: [combiningModel] = []
    
    var stepArray: [StepModel] = []
    
    let viewModel = PersonalViewModel()
    
    var listArray: [systemModel] = []
    
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
        tableView.register(OneTableViewCell.self, forCellReuseIdentifier: "OneTableViewCell")
        tableView.register(TwoTableViewCell.self, forCellReuseIdentifier: "TwoTableViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
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
            guard let self = self else { return }
            let leaveView = AlertWView(frame: self.view.bounds)
            let alertVc = TYAlertController(alert: leaveView, preferredStyle: .alert)
            self.present(alertVc!, animated: true)
            
            leaveView.oneBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            
            leaveView.twoBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.backToListPageVc()
                }
            }
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
            stepArray.append(StepModel(title: "\(index + 1)", isCurrent: (index < 2)))
        }
        stepView.models = stepArray
        
        self.normalHeadView.setTitle(modelArray[0].geometric ?? "")
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.size.equalTo(CGSize(width: 313, height: 50))
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom).offset(25)
            make.bottom.equalTo(nextButton.snp.top).offset(-5)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        nextButton.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        Task {
            await self.getPersonalInfo()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = bgView.bounds
    }
}

extension PersonalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listArray[indexPath.row]
        let cellType = model.acs ?? ""
        if cellType == "hamiltonianb" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OneTableViewCell", for: indexPath) as! OneTableViewCell
            cell.model = model
            cell.textBlock = { name in
                cell.text = name
                model.never = name
                model.complications = name
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoTableViewCell", for: indexPath) as! TwoTableViewCell
            cell.model = model
            cell.clickBlock = { [weak self] in
                guard let self = self else { return }
                self.view.endEditing(true)
                tapClick(with: cell, listmodel: model)
            }
            return cell
        }
    }
    
}

extension PersonalViewController {
    
    private func tapClick(with cell: TwoTableViewCell, listmodel: systemModel) {
        let alertView = PopAlertEnmuView(frame: self.view.bounds)
        let modelArray = listmodel.simulation ?? []
        alertView.modelArray = modelArray
        alertView.nameLabel.text = listmodel.geometric ?? ""
        let alertVc = TYAlertController(alert: alertView, preferredStyle: .actionSheet)!
        self.present(alertVc, animated: true)
        
        for (index, model) in modelArray.enumerated() {
            let text = cell.text ?? ""
            let target = model.concurrent ?? ""
            if target == text {
                alertView.selectedIndex = index
            }
            alertView.modelArray = modelArray
        }
        
        alertView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        alertView.confirmBlock = { [weak self] model in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                cell.text = model.concurrent ?? ""
                listmodel.never = model.concurrent ?? ""
                listmodel.complications = model.complications ?? ""
            }
        }
    }
    
    private func getPersonalInfo() async {
        do {
            let json = ["cannot": productID]
            let model = try await viewModel.getPersonalDetailInfo(json: json)
            if model.somewhat == 0 {
                self.listArray = model.combined?.system ?? []
                self.tableView.reloadData()
            }
        } catch  {
            
        }
    }
    
}

extension PersonalViewController {
    
    @objc private func btnClick() {
        var json = ["cannot": productID, "auth": "1"]
        for model in listArray {
            let key = model.somewhat ?? ""
            json[key] = model.complications ?? ""
        }
        print("json===☕️====\(json)")
        Task {
            await self.savePersonalInfo(with: json)
        }
    }
    
    private func savePersonalInfo(with json: [String: String]) async {
        do {
            let model: BaseModel = try await viewModel.savePersonalDetailInfo(json: json)
            if model.somewhat == 0 {
                self.backToListPageVc()
            }else {
                ToastManager.showMessage(message: model.conversion ?? "")
            }
        } catch {
            
        }
        
    }
}
