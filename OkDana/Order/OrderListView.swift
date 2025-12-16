//
//  OrderListView.swift
//  OkDana
//
//  Created by hekang on 2025/12/16.
//

import UIKit
import SnapKit

class OrderListView: UIView {
    
    // MARK: - Properties
    
    var model: optimizationsModel? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - UI Components
    
     lazy var oneLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#B2AEAE")
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(400))
        return label
    }()
    
     lazy var twoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        addSubview(oneLabel)
        addSubview(twoLabel)
    }
    
    private func setupConstraints() {
        oneLabel.snp.makeConstraints { make in
            make.height.equalTo(27)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.lessThanOrEqualTo(twoLabel.snp.left).offset(-8)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.height.equalTo(27)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-21)
        }
    }
    
    // MARK: - Private Methods
    
    private func updateUI() {
        guard let model = model else {
            clearUI()
            return
        }
        
        oneLabel.text = model.geometric ?? ""
        twoLabel.text = model.markov ?? ""
    }
    
    private func clearUI() {
        oneLabel.text = nil
        twoLabel.text = nil
    }
}
