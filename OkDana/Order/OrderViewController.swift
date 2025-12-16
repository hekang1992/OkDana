//
//  OrderViewController.swift
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

class OrderViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "order_bg_image")
        return bgImageView
    }()
    
    // 白色容器视图
    private lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    // 按钮数组
    private var buttons: [UIButton] = []
    
    // 当前选中的按钮索引
    private var selectedIndex: Int = 0 {
        didSet {
            updateButtonStates()
        }
    }
    
    // 按钮标题
    private let buttonTitles = ["All", "Apply", "Repayment", "Finish"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtons()
        selectedIndex = 0
    }
    
    private func setupUI() {
        // 添加背景图片
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(151)
        }
        
        // 添加头部视图
        view.addSubview(self.normalHeadView)
        self.normalHeadView.backButton.isHidden = true
        self.normalHeadView.nameLabel.textColor = UIColor.init(hex: "#FFFFFF")
        self.normalHeadView.nameLabel.text = LanguageManager.localizedString(for: "My Order")
        self.normalHeadView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        // 添加白色容器视图
        view.addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(62)
            make.bottom.equalTo(bgImageView.snp.bottom).offset(31)
            make.centerX.equalToSuperview()
        }
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
                    make.left.equalTo(previous.snp.right).offset(3)
                    make.width.equalTo(previous)
                } else {
                    make.left.equalToSuperview().offset(8)
                }
            }
            
            previousButton = button
        }
        
        if let lastButton = buttons.last {
            lastButton.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-8)
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
}

