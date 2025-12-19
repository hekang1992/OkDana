//
//  PhotoViewController.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import TYAlertController
import Kingfisher

class PhotoViewController: BaseViewController {
    
    var productID: String = ""
    
    var modelArray: [combiningModel] = []
    
    var stepArray: [StepModel] = []
    
    let viewModel = ProductViewModel()
    
    var despiteModel: despiteModel?
    
    let disposeBag = DisposeBag()
    
    let startViewModel = StartViewModel()
    
    let locationManager = AppLocationManager()
    
    var start_time: String = ""
    
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
    
    lazy var cardView: CardView = {
        let cardView = CardView(frame: .zero)
        return cardView
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
            stepArray.append(StepModel(title: "\(index + 1)", isCurrent: (index < 1)))
        }
        stepView.models = stepArray
        
        self.normalHeadView.setTitle(modelArray[0].geometric ?? "")
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.size.equalTo(CGSize(width: 313, height: 50))
        }
        
        view.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.top.equalTo(stepView.snp.bottom)
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-10)
        }
        
        
        cardView.tapClickBlock = { [weak self] in
            guard let self = self, let model = despiteModel else { return }
            let deposited = model.deposited ?? ""
            if deposited.isEmpty {
                showAlert()
            }else {
                let faceVc = FaceViewController()
                faceVc.productID = productID
                faceVc.modelArray = modelArray
                self.navigationController?.pushViewController(faceVc, animated: true)
            }
        }
        
        nextButton.rx.tap.bind(onNext: { [weak self] in
            guard let self = self, let model = despiteModel else { return }
            let deposited = model.deposited ?? ""
            if deposited.isEmpty {
                showAlert()
            }else {
                let faceVc = FaceViewController()
                faceVc.productID = productID
                faceVc.modelArray = modelArray
                self.navigationController?.pushViewController(faceVc, animated: true)
            }
        }).disposed(by: disposeBag)
        
        Task {
            await self.getCardInfo()
        }
        
        locationManager.getCurrentLocation { json in
            LocationManagerModel.shared.locationJson = json
        }
        
        start_time = String(Int(Date().timeIntervalSince1970))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = bgView.bounds
    }
}

extension PhotoViewController {
    
    private func showAlert() {
        
        self.takePhoto()
        
//        let alertController = UIAlertController(
//            title: LanguageManager.localizedString(for: "Please Select Image Source"),
//            message: nil,
//            preferredStyle: .actionSheet
//        )
//        
//        let cameraAction = UIAlertAction(title: LanguageManager.localizedString(for: "Camera"), style: .default) { _ in
//            self.dismiss(animated: true) {
//                self.takePhoto()
//            }
//        }
//        
//        let cancelAction = UIAlertAction(title: LanguageManager.localizedString(for: "Cancel"), style: .cancel) { _ in
//            self.dismiss(animated: true)
//        }
//        
//        if let cameraImage = UIImage(systemName: "camera") {
//            cameraAction.setValue(cameraImage, forKey: "image")
//        }
//        
//        alertController.addAction(cameraAction)
//        alertController.addAction(cancelAction)
//        
//        self.present(alertController, animated: true, completion: nil)
    }
    
    private func takePhoto() {
        CameraManager.shared.takePhoto(with: "1") { image in
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                if let imageData = image.jpegData(compressionQuality: 0.3) {
                    Task {
                        await self.uploadCardInfo(with: imageData)
                    }
                }
            }
        }
    }
    
}

extension PhotoViewController {
    
    private func getCardInfo() async {
        do {
            let json = ["cannot": productID]
            let model = try await viewModel.getPersonalCardInfo(json: json)
            if model.somewhat == 0 {
                if let despiteModel = model.combined?.despite {
                    self.despiteModel = despiteModel
                    let deposited = despiteModel.deposited ?? ""
                    if deposited.isEmpty {
//                        showAlert()
                    }else {
                        self.cardView.leftImageView.kf.setImage(with: URL(string: deposited))
                    }
                }
            }else {
                ToastManager.showMessage(message: model.conversion ?? "")
            }
        } catch  {
            
        }
    }
    
    private func uploadCardInfo(with imageData: Data) async {
        do {
            let json = ["complications": "11", "preference": "1"]
            let model = try await viewModel.uploadPersonalCardInfo(json: json, imageData: imageData)
            if model.somewhat == 0 {
                let resulting = model.combined?.resulting ?? 1
                if let modelArray = model.combined?.nest {
                    if resulting == 0 {
                        await self.getCardInfo()
                        await self.pointMessage()
                    }else if resulting == 1 {
                        self.alertCardView(with: modelArray)
                    }
                }
            }else {
                ToastManager.showMessage(message: model.conversion ?? "")
            }
        } catch  {
            
        }
    }
    
    private func alertCardView(with modelArray: [nestModel]) {
        let cardView = AppAlertSelectView(frame: self.view.bounds)
        cardView.modelArray = modelArray
        let alertVc = TYAlertController(alert: cardView, preferredStyle: .actionSheet)
        self.present(alertVc!, animated: true)
        
        cardView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        cardView.confirmBlock = { [weak self] in
            self?.saveInfo(with: cardView)
        }
        
        cardView.timeBlock = { [weak self] timeStr in
            guard let self = self else { return }
            let timeView = PopTimeView(frame: self.view.bounds)
            timeView.defaultDateString = timeStr.isEmpty ? "10-10-2000" : timeStr
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            window.addSubview(timeView)
            
            timeView.timeBlock = { time in
                cardView.threeListView.nameTextFiled.text = time
                timeView.defaultDateString = time
                timeView.removeFromSuperview()
            }
            timeView.cancelBlock = {
                timeView.removeFromSuperview()
            }
            self.view.endEditing(true)
            cardView.oneListView.nameTextFiled.resignFirstResponder()
            cardView.twoListView.nameTextFiled.resignFirstResponder()
        }
        
    }
    
    private func saveInfo(with cardView: AppAlertSelectView) {
        Task {
            do {
                let name = cardView.oneListView.nameTextFiled.text ?? ""
                let idNumber = cardView.twoListView.nameTextFiled.text ?? ""
                let dateStr = cardView.threeListView.nameTextFiled.text ?? ""
                let json = ["cannot": productID,
                            "concurrent": name,
                            "models": idNumber,
                            "behavior": dateStr
                ]
                let model = try await viewModel.savePersonalCardInfo(json: json)
                if model.somewhat == 0 {
                    self.dismiss(animated: true) {
                        LoginConfig.saveCardInfo(name: name, idNum: idNumber, time: dateStr)
                    }
                    await self.getCardInfo()
                    await self.pointMessage()
                }else {
                    ToastManager.showMessage(message: model.conversion ?? "")
                }
            } catch {
                
            }
        }
    }
    
    private func pointMessage() async {
        do {
            let end_time = String(Int(Date().timeIntervalSince1970))
            let locationJson = LocationManagerModel.shared.locationJson
            let apiJson = ["advanced": "2",
                           "compute": locationJson?["compute"] ?? "",
                           "perturb": locationJson?["perturb"] ?? "",
                           "mentioned": start_time,
                           "family": end_time
            ]
            
            let _ = try await startViewModel.uploadPointInfo(json: apiJson)
            
        } catch  {
            
        }
    }
    
}
