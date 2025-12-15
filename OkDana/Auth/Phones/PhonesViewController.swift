//
//  PhonesViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import SnapKit
import TYAlertController

class PhonesViewController: BaseViewController {
    
    var productID: String = ""
    
    var modelArray: [combiningModel] = []
    
    var stepArray: [StepModel] = []
    
    let viewModel = PhonesViewModel()
    
    var listArray: [artificialModel] = []
    
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
        tableView.register(PhonesTableViewCell.self, forCellReuseIdentifier: "PhonesTableViewCell")
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
            stepArray.append(StepModel(title: "\(index + 1)", isCurrent: (index < modelArray.count - 1)))
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
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-5)
        }
    
        Task {
            await self.getPersonalInfo()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = bgView.bounds
    }
}

extension PhonesViewController {
    
    private func getPersonalInfo() async {
        do {
            let json = ["cannot": productID]
            let model: BaseModel = try await viewModel.getPersonalDetailInfo(json: json)
            if model.somewhat == 0 {
                self.listArray = model.combined?.artificial ?? []
            }
            self.tableView.reloadData()
        } catch {
            
        }
    }
    
}

extension PhonesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.listArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhonesTableViewCell", for: indexPath) as! PhonesTableViewCell
        cell.model = model
        
        cell.relationBlock = { [weak self] in
            guard let self = self else { return }
            cellTapClick(with: cell, listmodel: model)
        }
        
        cell.phoneBlock = { [weak self] in
            guard let self = self else { return }
        }
        
        return cell
    }
    
    private func cellTapClick(with cell: PhonesTableViewCell, listmodel: artificialModel) {
        let alertView = PopAlertEnmuView(frame: self.view.bounds)
        let modelArray = listmodel.simulation ?? []
        alertView.modelArray = modelArray
        alertView.nameLabel.text = listmodel.geometric ?? ""
        let alertVc = TYAlertController(alert: alertView, preferredStyle: .actionSheet)!
        self.present(alertVc, animated: true)
        
        for (index, model) in modelArray.enumerated() {
            let text = cell.oneListView.nameTextFiled.text ?? ""
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
                cell.oneListView.nameTextFiled.text = model.concurrent ?? ""
                listmodel.inserts = model.complications ?? ""
            }
        }
    }
    
}
