//
//  ProductView.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import UIKit
import SnapKit

class ProductView: UIView {
    
    var model: yvesModel? {
        didSet {
            guard let model = model else { return }
            actualLabel.text = model.disappear ?? ""
            amountLabel.text = model.evaporation ?? ""
        }
    }
    
    var modelArray: [combiningModel] = []

    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "product_head_bg_image")
        return headImageView
    }()
    
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
        label.font = UIFont.systemFont(ofSize: 56, weight: UIFont.Weight(600))
        label.textAlignment = .center
        return label
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
        tableView.register(ProductListViewCell.self, forCellReuseIdentifier: "ProductListViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        nextBtn.setBackgroundImage(UIImage(named: "netx_bg_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headImageView)
        headImageView.addSubview(actualLabel)
        headImageView.addSubview(amountLabel)
        headImageView.addSubview(oneLineImageView)
        headImageView.addSubview(twoLineImageView)
        addSubview(nextBtn)
        addSubview(tableView)
        
        headImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(127)
        }
        
        actualLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(22)
            make.height.equalTo(15)
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
        
        twoLineImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(amountLabel.snp.bottom).offset(5)
            make.width.equalTo(230)
            make.height.equalTo(1)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.size.equalTo(CGSize(width: 313, height: 50))
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProductView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListViewCell", for: indexPath) as! ProductListViewCell
        let index = indexPath.row
        let model = modelArray[index]
        cell.model = model

        let discovery = model.discovery ?? 0
        if discovery == 1 {
            cell.iconImageView.image = UIImage(named: "list_sel_0\(index + 1)_image")
            cell.rightImageView.image = UIImage(named: "list_sel_right_image")
        }else {
            cell.iconImageView.image = UIImage(named: "list_nor_0\(index + 1)_image")
            cell.rightImageView.image = UIImage(named: "list_nor_right_image")
        }
        return cell
    }
    
    
}
