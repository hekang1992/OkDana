//
//  PhonesTableViewCell.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhonesTableViewCell: UITableViewCell {
    
    var relationBlock: (() -> Void)?
    
    var phoneBlock: (() -> Void)?
    
    let disposeBag = DisposeBag()
    
    var model: artificialModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.geometric ?? ""
            oneListView.nameLabel.text = model.convex ?? ""
            oneListView.nameTextFiled.placeholder = model.insertion ?? ""
            
            twoListView.nameLabel.text = model.constricting ?? ""
            twoListView.nameTextFiled.placeholder = model.entropy ?? ""
            
            
            let inserts = model.inserts ?? ""
            
            let modelArray = model.simulation ?? []
            
            for model in modelArray {
                if model.complications == inserts {
                    oneListView.nameTextFiled.text = model.concurrent ?? ""
                }
            }
            
            let name = model.concurrent ?? ""
            
            let phone = model.hull ?? ""
            
            let displayText = phone.isEmpty ? name : "\(name)-\(phone)"
            twoListView.nameTextFiled.text = displayText
            
            
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.init(hex: "#525252")
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(400))
        return nameLabel
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "phon_plc_image")
        return bgImageView
    }()
    
    lazy var oneListView: AppAlertListView = {
        let oneListView = AppAlertListView(frame: .zero)
        return oneListView
    }()
    
    lazy var twoListView: AppAlertListView = {
        let twoListView = AppAlertListView(frame: .zero)
        twoListView.iconImageView.image = UIImage(named: "phon_icon_image")
        return twoListView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(226)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(17)
        }
        
        bgView.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(13)
        }
        
        bgView.addSubview(oneListView)
        bgView.addSubview(twoListView)
        
        oneListView.snp.makeConstraints { make in
            make.top.equalTo(bgImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        twoListView.snp.makeConstraints { make in
            make.top.equalTo(oneListView.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        oneListView.clickBlock = { [weak self] one in
            self?.relationBlock?()
        }
        
        twoListView.clickBlock = { [weak self] two in
            self?.phoneBlock?()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
