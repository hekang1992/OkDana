//
//  BaseTabBarController.swift
//  OkDana
//
//  Created by hekang on 2025/12/13.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
        delegate = self
    }

    // MARK: - Setup ViewControllers
    private func setupViewControllers() {
        viewControllers = TabItem.allCases.map {
            makeNavigationController(for: $0)
        }
    }

    // MARK: - Create NavigationController
    private func makeNavigationController(for item: TabItem) -> UINavigationController {

        let nav = BaseNavigationController(rootViewController: item.viewController)

        let tabBarItem = UITabBarItem(
            title: item.title,
            image: UIImage(named: item.normalImage)?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: item.selectedImage)?.withRenderingMode(.alwaysOriginal)
        )

        tabBarItem.setTitleTextAttributes(item.normalTextAttributes, for: .normal)
        tabBarItem.setTitleTextAttributes(item.selectedTextAttributes, for: .selected)

        nav.tabBarItem = tabBarItem
        return nav
    }

    // MARK: - TabBar Appearance
    private func setupTabBarAppearance() {

        tabBar.borderWidth = 0
        tabBar.borderColor = .clear
        tabBar.backgroundColor = .clear

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = .clear

            appearance.stackedLayoutAppearance.normal.titleTextAttributes = TabItem.normalTextAttributes
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = TabItem.selectedTextAttributes

            
            appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 3)
            appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 3)

            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension BaseTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        if LoginConfig.hasValidToken() == false {
            let nav = BaseNavigationController(rootViewController: LoginViewController())
            nav.modalPresentationStyle = .overFullScreen
            present(nav, animated: true)
            return false
        }
        return true
    }
    
}

// MARK: - Tab Configuration
private enum TabItem: CaseIterable {

    case home
    case bills
    case mine

    var title: String {
        switch self {
        case .home:
            return LanguageManager.localizedString(for: "Home")
        case .bills:
            return LanguageManager.localizedString(for: "Bills")
        case .mine:
            return LanguageManager.localizedString(for: "Mine")
        }
    }

    var normalImage: String {
        switch self {
        case .home: return "home_nor_image"
        case .bills: return "bills_nor_image"
        case .mine: return "mine_nor_image"
        }
    }

    var selectedImage: String {
        switch self {
        case .home: return "home_sel_image"
        case .bills: return "bills_sel_image"
        case .mine: return "mine_sel_image"
        }
    }

    var viewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController()
        case .bills:
            return OrderViewController()
        case .mine:
            return CenterViewController()
        }
    }

    // MARK: - Text Attributes
    static let normalTextAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor(hex: "#8C8C8C"),
        .font: UIFont.systemFont(ofSize: 14)
    ]

    static let selectedTextAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor(hex: "#00CA5D"),
        .font: UIFont.systemFont(ofSize: 14)
    ]

    var normalTextAttributes: [NSAttributedString.Key: Any] {
        Self.normalTextAttributes
    }

    var selectedTextAttributes: [NSAttributedString.Key: Any] {
        Self.selectedTextAttributes
    }
}

// MARK: - UIView Extension
extension UIView {

    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}
