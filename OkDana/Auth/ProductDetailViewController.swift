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
    
    let viewModel = ProductViewModel()
    
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
                    self.listView.nextBtn.setTitle(footTitle, for: .normal)
                    self.listView.model = listModel
                }
                if let modelArray = model.combined?.combining {
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
