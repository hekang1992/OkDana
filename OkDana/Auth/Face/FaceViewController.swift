//
//  FaceViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import TYAlertController
import Kingfisher

class FaceViewController: BaseViewController {
    
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
        let code = LanguageManager.currentLanguage
        cardView.leftImageView.image = UIImage(named: "face_place_image")
        cardView.oneImageView.image = code == .id ? UIImage(named: "id_two_s_image") : UIImage(named: "en_two_s_image")
        cardView.twoImageView.image = code == .id ? UIImage(named: "id_faca_card_lia_image") : UIImage(named: "faca_card_lia_image")
        cardView.footImageView.image = code == .id ? UIImage(named: "fc_id_fot_image") : UIImage(named: "cs_en_fot_image")
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
            let trail = model.trail ?? ""
            if trail.isEmpty {
                showAlert()
            }else {
                let compVc = ComleteViewController()
                compVc.productID = productID
                compVc.modelArray = modelArray
                self.navigationController?.pushViewController(compVc, animated: true)
            }
        }
        
        nextButton.rx.tap.bind(onNext: { [weak self] in
            guard let self = self, let model = despiteModel else { return }
            let trail = model.trail ?? ""
            if trail.isEmpty {
                showAlert()
            }else {
                let compVc = ComleteViewController()
                compVc.productID = productID
                compVc.modelArray = modelArray
                self.navigationController?.pushViewController(compVc, animated: true)
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

extension FaceViewController {
    
    private func showAlert() {
        let alertController = UIAlertController(
            title: LanguageManager.localizedString(for: "Please Select Image Source"),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let cameraAction = UIAlertAction(title: LanguageManager.localizedString(for: "Camera"), style: .default) { _ in
            self.dismiss(animated: true) {
                self.takePhoto()
            }
        }
        
        let cancelAction = UIAlertAction(title: LanguageManager.localizedString(for: "Cancel"), style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        
        if let cameraImage = UIImage(systemName: "camera") {
            cameraAction.setValue(cameraImage, forKey: "image")
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func takePhoto() {
        CameraManager.shared.takePhoto(with: "2") { image in
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

extension FaceViewController {
    
    private func getCardInfo() async {
        do {
            let json = ["cannot": productID]
            let model = try await viewModel.getPersonalCardInfo(json: json)
            if model.somewhat == 0 {
                if let despiteModel = model.combined?.despite {
                    self.despiteModel = despiteModel
                    let trail = despiteModel.trail ?? ""
                    if trail.isEmpty {
                        showAlert()
                    }else {
                        self.cardView.leftImageView.kf.setImage(with: URL(string: trail))
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
            let json = ["complications": "10", "preference": "1"]
            let model = try await viewModel.uploadPersonalCardInfo(json: json, imageData: imageData)
            if model.somewhat == 0 {
                await self.getCardInfo()
                await self.pointMessage()
            }else {
                ToastManager.showMessage(message: model.conversion ?? "")
            }
        } catch  {
            
        }
    }
    
    private func pointMessage() async {
        do {
            let end_time = String(Int(Date().timeIntervalSince1970))
            let locationJson = LocationManagerModel.shared.locationJson
            let apiJson = ["advanced": "3",
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
