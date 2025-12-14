//
//  BaseViewController.swift
//  OkDana
//
//  Created by hekang on 2025/12/13.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#48CC4D")
        return view
    }()
    
    lazy var headView: AppNavView = {
        let headView = AppNavView()
        return headView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(hex: "#F5F5F5")
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
