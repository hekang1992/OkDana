//
//  CenterView.swift
//  OkDana
//
//  Created by hekang on 2025/12/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class CenterView: UIView {
    
    var cellBlock: ((easierModel) -> Void)?
    
    var modelArray: [easierModel] = []
    
    var mentBlock: (() -> Void)?
    
    let disposeBag = DisposeBag()

    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "cen_ic_lo_image")
        iconImageView.layer.cornerRadius = 29
        iconImageView.layer.masksToBounds = true
        return iconImageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textAlignment = .left
        phoneLabel.textColor = UIColor.init(hex: "#3D3D3D")
        phoneLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        return phoneLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .left
        descLabel.text = LanguageManager.localizedString(for: "Welcome to OK Dana!")
        descLabel.textColor = UIColor.init(hex: "#AEAEAE")
        descLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(400))
        return descLabel
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        let code = LanguageManager.currentLanguage
        let imageStr = code == .id ? "id_cen_li_image" : "en_cen_li_image"
        oneImageView.image = UIImage(named: imageStr)
        return oneImageView
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
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CenterTableViewCell.self, forCellReuseIdentifier: "CenterTableViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(phoneLabel)
        addSubview(descLabel)
        addSubview(scrollView)
        scrollView.addSubview(oneImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 66, height: 66))
            make.left.equalToSuperview().offset(20)
        }
        phoneLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalTo(iconImageView.snp.top).offset(6)
            make.height.equalTo(22)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(phoneLabel)
            make.top.equalTo(phoneLabel.snp.bottom).offset(5)
            make.height.equalTo(18)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        oneImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 114.pix()))
        }
        
        scrollView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 444.pix()))
        }
        
        oneImageView.rx.tapGesture().when(.recognized).bind(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.mentBlock?()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CenterView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CenterTableViewCell", for: indexPath) as! CenterTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let model = modelArray[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = modelArray[indexPath.row]
        self.cellBlock?(model)
    }
    
}
