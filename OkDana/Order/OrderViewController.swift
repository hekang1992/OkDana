//
//  OrderViewController.swift
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
import MJRefresh

class OrderViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel = OrderViewModel()
    
    var modelArray: [easierModel] = []
    
    var type: String = "4"
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "order_bg_image")
        return bgImageView
    }()
    
    private lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var emptyView: OrderEmptyView = {
        let emptyView = OrderEmptyView()
        emptyView.isHidden = true
        return emptyView
    }()
    
    private var buttons: [UIButton] = []
    
    private var selectedIndex: Int = 0 {
        didSet {
            updateButtonStates()
        }
    }
    
    private let buttonTitles = ["All", "Apply", "Repayment", "Finish"]
    
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
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: "OrderTableViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtons()
        selectedIndex = 0
    }
    
    private func setupUI() {
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(151)
        }
        
        view.addSubview(self.normalHeadView)
        self.normalHeadView.backButton.isHidden = true
        self.normalHeadView.nameLabel.textColor = UIColor.init(hex: "#FFFFFF")
        self.normalHeadView.nameLabel.text = LanguageManager.localizedString(for: "My Order")
        self.normalHeadView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        view.addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(62)
            make.bottom.equalTo(bgImageView.snp.bottom).offset(31)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(whiteView.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(whiteView.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        emptyView.applyBlock = {
            NotificationCenter.default.post(name: NSNotification.Name("changeRootVc"), object: nil)
        }
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [weak self] in
            guard let self = self else { return }
            Task {
                await self.orderListInfo(with: self.type)
            }
        })
        
    }
    
    private func setupButtons() {
        var previousButton: UIButton?
        
        for (index, title) in buttonTitles.enumerated() {
            let button = createButton(title: LanguageManager.localizedString(for: title), tag: index)
            buttons.append(button)
            whiteView.addSubview(button)
            
            button.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                
                if let previous = previousButton {
                    make.left.equalTo(previous.snp.right).offset(2)
                    make.width.equalTo(previous)
                } else {
                    make.left.equalToSuperview().offset(5)
                }
            }
            
            previousButton = button
        }
        
        if let lastButton = buttons.last {
            lastButton.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-5)
            }
        }
    }
    
    private func createButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = tag
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        button.setTitleColor(UIColor(hex: "#686868"), for: .normal)
        button.backgroundColor = .white
        
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        switch selectedIndex {
        case 0:
            self.type = "4"
        case 1:
            self.type = "7"
        case 2:
            self.type = "6"
        case 3:
            self.type = "5"
        default:
            break
        }
        Task {
            await self.orderListInfo(with: type)
        }
    }
    
    private func updateButtonStates() {
        for (index, button) in buttons.enumerated() {
            if index == selectedIndex {
                button.backgroundColor = UIColor(hex: "#00CA5D")
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(UIColor(hex: "#686868"), for: .normal)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await self.orderListInfo(with: type)
        }
    }
}


extension OrderViewController {
    
    private func orderListInfo(with type: String) async {
        do {
            let json = ["intelligence": type, "order": "1"]
            let model = try await viewModel.getOrderListInfo(json: json)
            if model.somewhat == 0 {
                let modelArray = model.combined?.easier ?? []
                self.modelArray = modelArray
                if modelArray.count > 0 {
                    self.tableView.isHidden = false
                    self.emptyView.isHidden = true
                }else {
                    self.tableView.isHidden = true
                    self.emptyView.isHidden = false
                }
            }
            self.tableView.reloadData()
            await self.tableView.mj_header?.endRefreshing()
        } catch  {
            self.tableView.isHidden = true
            self.emptyView.isHidden = false
            await self.tableView.mj_header?.endRefreshing()
        }
    }
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath) as! OrderTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let model = self.modelArray[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.modelArray[indexPath.row]
        let pageUrl = model.genetic ?? ""
        if pageUrl.contains(AppScheme.base) {
            AppSchemeUrlConfig.handleRoute(pageUrl: pageUrl, from: self)
        } else if pageUrl.contains("http://") || pageUrl.contains("https://") {
            self.goWebVc(with: pageUrl)
        }else {
            
        }
    }
    
}
