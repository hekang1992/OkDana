//
//  ProductDetailViewController.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/14.
//

import UIKit
import SnapKit
import MJRefresh

class ProductDetailViewController: BaseViewController {
    
    var productID: String = ""
    
    var virtualModel: virtualModel?
    
    var yvesModel: yvesModel?
    
    let viewModel = ProductViewModel()
    
    var modelArray: [combiningModel] = []
    
    let startViewModel = StartViewModel()
    
    let locationManager = AppLocationManager()
    
    lazy var listView: ProductView = {
        let listView = ProductView(frame: .zero)
        return listView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        headView.backAction = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(-10)
            make.left.right.bottom.equalToSuperview()
        }
        
        listView.cellTapClickBlock = { [weak self] model in
            guard let self = self else { return }
            let nextStr = model.map ?? ""
            let isAuth = model.discovery ?? 0
            if isAuth == 1 {
                self.tapClickToPageVc(with: nextStr)
            }else {
                self.listView.nextClickBlock?()
            }
        }
        
        listView.nextClickBlock = { [weak self] in
            guard let self = self else { return }
            let nextStr = self.virtualModel?.map ?? ""
            if nextStr.isEmpty {
                let proportional = self.yvesModel?.proportional ?? ""
                let evaporation = self.yvesModel?.evaporation ?? ""
                let laying = self.yvesModel?.laying ?? ""
                let lays = self.yvesModel?.lays ?? ""
                let json = ["proportional": proportional,
                            "evaporation": evaporation,
                            "laying": laying,
                            "lays": lays
                ]
                Task {
                    await self.applyOrder(with: json)
                }
            }else {
                self.tapClickToPageVc(with: nextStr)
            }
        }
        
        self.listView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.getDetailInfo()
            }
        })
        
        locationManager.getCurrentLocation { json in
            LocationManagerModel.shared.locationJson = json
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            await getDetailInfo()
        }
    }
}

extension ProductDetailViewController {
    
    private func applyOrder(with json: [String: String]) async {
        do {
            let model = try await viewModel.orderMessageInfo(json: json)
            if model.somewhat == 0 {
                let inputs = model.combined?.inputs ?? ""
                if inputs.contains(AppScheme.base) {
                    AppSchemeUrlConfig.handleRoute(pageUrl: inputs, from: self)
                }else if inputs.contains("http://") || inputs.contains("https://") {
                    self.goWebVc(with: inputs)
                    await self.pointMessage(with: json["proportional"] ?? "")
                }else {
                    
                }
            }else {
                ToastManager.showMessage(message: model.conversion ?? "")
            }
        } catch {
            
        }
    }
    
    @MainActor
    private func getDetailInfo() async {
        do {
            let json = [
                "cannot": productID,
                "type": "1"
            ]
            
            let model: BaseModel = try await viewModel.getProductDetailInfo(json: json)
            
            if model.somewhat == 0 {
                if let listModel = model.combined?.yves {
                    self.headView.nameLabel.text = model.combined?.yves?.pspace ?? ""
                    let footTitle = model.combined?.yves?.hierarchy ?? ""
                    self.listView.nextButton.setTitle(footTitle, for: .normal)
                    self.listView.model = listModel
                    self.yvesModel = listModel
                }
                
                self.virtualModel = model.combined?.virtual
                
                if let modelArray = model.combined?.combining {
                    self.modelArray = modelArray
                    self.listView.modelArray = modelArray
                }
                self.listView.tableView.reloadData()
            }
            await MainActor.run {
                self.listView.tableView.mj_header?.endRefreshing()
            }
        } catch {
            await MainActor.run {
                self.listView.tableView.mj_header?.endRefreshing()
            }
            print("getDetailInfo error:", error)
        }
    }
}

extension ProductDetailViewController {
    
    private func tapClickToPageVc(with type: String) {
        switch type {
        case "citiesa":
            Task {
                await self.getCardInfo()
            }
            break
        case "citiesb":
            let personalVc = PersonalViewController()
            personalVc.productID = productID
            personalVc.modelArray = modelArray
            self.navigationController?.pushViewController(personalVc, animated: true)
            break
        case "citiesc":
            let workVc = WorkViewController()
            workVc.productID = productID
            workVc.modelArray = modelArray
            self.navigationController?.pushViewController(workVc, animated: true)
            break
        case "citiesd":
            let phonesVc = PhonesViewController()
            phonesVc.productID = productID
            phonesVc.modelArray = modelArray
            self.navigationController?.pushViewController(phonesVc, animated: true)
            break
        case "citiese":
            let walletVc = WalletViewController()
            walletVc.productID = productID
            walletVc.modelArray = modelArray
            self.navigationController?.pushViewController(walletVc, animated: true)
            break
        default:
            break
        }
    }
    
    private func getCardInfo() async {
        do {
            let json = ["cannot": productID]
            let model = try await viewModel.getPersonalCardInfo(json: json)
            if model.somewhat == 0 {
                if let despiteModel = model.combined?.despite {
                    let deposited = despiteModel.deposited ?? ""
                    let trail = despiteModel.trail ?? ""
                    if deposited.isEmpty {
                        let photoVc = PhotoViewController()
                        photoVc.productID = productID
                        photoVc.modelArray = modelArray
                        self.navigationController?.pushViewController(photoVc, animated: true)
                        return
                    }
                    if trail.isEmpty {
                        let faceVc = FaceViewController()
                        faceVc.productID = productID
                        faceVc.modelArray = modelArray
                        self.navigationController?.pushViewController(faceVc, animated: true)
                        return
                    }
                    let completeVc = ComleteViewController()
                    completeVc.productID = productID
                    completeVc.modelArray = modelArray
                    self.navigationController?.pushViewController(completeVc, animated: true)
                }
            }else {
                ToastManager.showMessage(message: model.conversion ?? "")
            }
        } catch  {
            
        }
        
    }
    
    private func pointMessage(with ocn: String) async {
        do {
            let end_time = String(Int(Date().timeIntervalSince1970))
            let locationJson = LocationManagerModel.shared.locationJson
            let apiJson = ["advanced": "8",
                           "compute": locationJson?["compute"] ?? "",
                           "perturb": locationJson?["perturb"] ?? "",
                           "mentioned": end_time,
                           "family": end_time,
                           "continues": ocn
            ]
            
            let _ = try await startViewModel.uploadPointInfo(json: apiJson)
            
        } catch  {
            
        }
    }
    
}
