//
//  Untitled.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopTimeView: UIView {
    
    var time: String = ""
    
    let disposeBag = DisposeBag()
    
    // MARK: - Public property
    var defaultDateString: String = "10-11-2000" {
        didSet {
            updateDateFromString(defaultDateString)
        }
    }
    
    var timeBlock: ((String) -> Void)?
    
    var cancelBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "alert_nor_bg_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(UIImage(named: "cal_foc_a_image"), for: .normal)
        return cancelBtn
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.setTitle(LanguageManager.localizedString(for: "Confirm"), for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        loginBtn.setBackgroundImage(UIImage(named: "login_btn_image"), for: .normal)
        loginBtn.adjustsImageWhenHighlighted = false
        return loginBtn
    }()
   
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = LanguageManager.localizedString(for: "Select A Date")
        nameLabel.textColor = UIColor.init(hex: "#000000")
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
        return nameLabel
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        dp.locale = Locale(identifier: "en_ID")
        dp.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return dp
    }()
    
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd-MM-yyyy"
        return f
    }()
    
    lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.textAlignment = .center
        dayLabel.text = LanguageManager.localizedString(for: "Date")
        dayLabel.textColor = UIColor.init(hex: "#2A2A2A")
        dayLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(500))
        return dayLabel
    }()
    
    lazy var monthLabel: UILabel = {
        let monthLabel = UILabel()
        monthLabel.textAlignment = .left
        monthLabel.text = LanguageManager.localizedString(for: "Month")
        monthLabel.textColor = UIColor.init(hex: "#2A2A2A")
        monthLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(500))
        return monthLabel
    }()
    
    lazy var yearLabel: UILabel = {
        let yearLabel = UILabel()
        yearLabel.textAlignment = .left
        yearLabel.text = LanguageManager.localizedString(for: "Year")
        yearLabel.textColor = UIColor.init(hex: "#2A2A2A")
        yearLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight(500))
        return yearLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateDateFromString(defaultDateString)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        updateDateFromString(defaultDateString)
    }
    
    // MARK: - UI
    private func setupUI() {
        
        addSubview(bgImageView)
        bgImageView.addSubview(cancelBtn)
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(dayLabel)
        bgImageView.addSubview(monthLabel)
        bgImageView.addSubview(yearLabel)
        bgImageView.addSubview(datePicker)
        bgImageView.addSubview(loginBtn)
        bgImageView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(411)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.top.equalToSuperview().offset(33)
            make.right.equalToSuperview().offset(-20)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 313, height: 50))
            make.bottom.equalToSuperview().offset(-30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(18)
            make.height.equalTo(20)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(loginBtn.snp.top).offset(-5)
        }
        dayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(82)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(30)
            make.width.equalTo(115)
        }
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.top)
            make.left.equalTo(dayLabel.snp.right)
            make.height.equalTo(30)
            make.width.equalTo(115)
        }
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.top)
            make.left.equalTo(monthLabel.snp.right).offset(12)
            make.height.equalTo(30)
            make.width.equalTo(115)
        }
        
        cancelBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            self.cancelBlock?()
        }).disposed(by: disposeBag)
        
        loginBtn.rx.tap.bind(onNext: { [weak self] in
            guard let self = self else { return }
            if time.isEmpty {
                self.timeBlock?(defaultDateString)
            }else {
                self.timeBlock?(time)
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateDateFromString(_ str: String) {
        if let date = dateFormatter.date(from: str) {
            datePicker.setDate(date, animated: false)
            let _ = dateFormatter.string(from: date)
        } else {
            if let defaultDate = dateFormatter.date(from: "10-10-2000") {
                datePicker.setDate(defaultDate, animated: false)
                let _ = dateFormatter.string(from: defaultDate)
            }
        }
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let time = dateFormatter.string(from: sender.date)
        self.time = time
    }
    
    func getSelectedDateString() -> String {
        return dateFormatter.string(from: datePicker.date)
    }
    
}
