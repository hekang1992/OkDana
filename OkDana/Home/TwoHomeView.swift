//
//  TwoHomeView.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class TwoHomeView: UIView {
    
    let disposeBag = DisposeBag()
    
    var bigModel: despiteModel? {
        didSet {
            guard let bigModel = bigModel else { return }
            let logoUrl = bigModel.subclass ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = bigModel.pspace ?? ""
        }
    }
    
    var modelArray: [despiteModel]? {
        didSet {
            guard let modelArray = modelArray else { return }
            
        }
    }
    
    var cellTapClickBlock: ((String) -> Void)?

    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "head_one_image")
        return imageView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductTableViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "head_two_image")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor(hex: "#FFFFFF")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    // MARK: - Card Content
    private lazy var actualLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#B1B0B0")
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(400))
        label.textAlignment = .center
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#6DD54C")
        label.font = UIFont.systemFont(ofSize: 52, weight: UIFont.Weight(600))
        label.textAlignment = .center
        return label
    }()
    
    private lazy var limitLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#B1B0B0")
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(300))
        label.textAlignment = .left
        return label
    }()
    
    private lazy var loanLimitLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#3B3B3B")
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(300))
        label.textAlignment = .left
        return label
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "app_apply_btn_image"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(500))
        return button
    }()
    
    private lazy var oneLineImageView: UIImageView = {
        let oneLineImageView = UIImageView()
        oneLineImageView.image = UIImage(named: "head_line_bg_image")
        return oneLineImageView
    }()
    
    private lazy var twoLineImageView: UIImageView = {
        let twoLineImageView = UIImageView()
        twoLineImageView.image = UIImage(named: "head_line_bg_image")
        return twoLineImageView
    }()
    
    private lazy var moreImageView: UIImageView = {
        let imageView = UIImageView()
        let code = LanguageManager.currentLanguage
        imageView.image =  code == .id ? UIImage(named: "id_more_pro_image") : UIImage(named: "en_more_pro_image")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImageView)
        addSubview(stackView)
        addSubview(tableView)
        headerImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(253)
        }
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5)
            make.height.equalTo(30)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(1)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(nameLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 26, height: 26))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TwoHomeView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        
        let bigBtn = UIButton(type: .custom)
        
        
        headView.addSubview(cardImageView)
        cardImageView.addSubview(actualLabel)
        cardImageView.addSubview(amountLabel)
        cardImageView.addSubview(oneLineImageView)
        cardImageView.addSubview(twoLineImageView)
        cardImageView.addSubview(limitLabel)
        cardImageView.addSubview(loanLimitLabel)
        cardImageView.addSubview(applyButton)
        headView.addSubview(moreImageView)
        headView.addSubview(bigBtn)
        
        cardImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(230)
        }
        
        moreImageView.snp.makeConstraints { make in
            make.top.equalTo(cardImageView.snp.bottom).offset(18)
            make.height.equalTo(16)
            make.centerX.equalToSuperview()
        }
        
        // Card Content Constraints
        actualLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(35)
        }
        
        oneLineImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(actualLabel.snp.bottom).offset(8)
            make.width.equalTo(230)
            make.height.equalTo(1)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneLineImageView.snp.bottom).offset(5)
            make.height.equalTo(60)
        }
        
        cardImageView.addSubview(twoLineImageView)
        twoLineImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(amountLabel.snp.bottom).offset(5)
            make.width.equalTo(230)
            make.height.equalTo(1)
        }
        
        limitLabel.snp.makeConstraints { make in
            make.top.equalTo(twoLineImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview().offset(-40)
        }
        
        loanLimitLabel.snp.makeConstraints { make in
            make.centerY.equalTo(limitLabel)
            make.left.equalTo(limitLabel.snp.right).offset(5)
        }
        
        applyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
            make.size.equalTo(CGSize(width: 286, height: 52))
        }
        
        bigBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let bigModel = bigModel {
            actualLabel.text = bigModel.actual ?? ""
            amountLabel.text = bigModel.rational ?? ""
            limitLabel.text = "\(bigModel.discretized ?? ""):"
            loanLimitLabel.text = bigModel.obstacle ?? ""
            applyButton.setTitle(bigModel.hierarchy ?? "", for: .normal)
        }
        
        bigBtn
            .rx
            .tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.cellTapClickBlock?(String(self.bigModel?.arbitrary ?? 0))
        })
            .disposed(by: disposeBag)
        
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 280
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = modelArray?[indexPath.row] {
            self.cellTapClickBlock?(String(model.arbitrary ?? 0))
        }
        
    }
    
}
