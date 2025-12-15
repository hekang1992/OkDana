//
//  ProductDetailViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/14.
//

import UIKit
import SnapKit
import MJRefresh

class ProductDetailViewController: BaseViewController {
    
    var productID: String = ""
    
    var virtualModel: virtualModel?
    
    let viewModel = ProductViewModel()
    
    var modelArray: [combiningModel] = []
    
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
            //            let isAuth = String(self.virtualModel?.complications ?? 0)
            self.tapClickToPageVc(with: nextStr)
        }
        
        self.listView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.getDetailInfo()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            await getDetailInfo()
        }
    }
}

extension ProductDetailViewController {
    
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
                }
                if let virtualModel = model.combined?.virtual {
                    self.virtualModel = virtualModel
                }
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
        case "":
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
    
}
