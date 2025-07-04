//
//  MainTabBarController.swift
//  N11CloneApp
//
//  Created by irem karakaplan on 2.07.2025.
//
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
        customizeTabBarAppearance()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = UIColor.white
        tabBar.tintColor = UIColor.n11Purple
        tabBar.unselectedItemTintColor = UIColor.black
        tabBar.isTranslucent = false
        
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
    }
    
    private func setupViewControllers() {
        let homeViewController = HomeViewController()
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        homeNavController.tabBarItem = UITabBarItem(
            title: "Ana Sayfa",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        homeNavController.tabBarItem.tag = 0
        
        let categoriesViewController = CategoriesViewController()
        let categoriesNavController = UINavigationController(rootViewController: categoriesViewController)
        categoriesNavController.tabBarItem = UITabBarItem(
            title: "Kategoriler",
            image: UIImage(systemName: "square.grid.2x2"),
            selectedImage: UIImage(systemName: "square.grid.2x2.fill")
        )
        categoriesNavController.tabBarItem.tag = 1
        
        let cartViewController = CartViewController()
        let cartNavController = UINavigationController(rootViewController: cartViewController)
        cartNavController.tabBarItem = UITabBarItem(
            title: "Sepetim",
            image: UIImage(systemName: "cart"),
            selectedImage: UIImage(systemName: "cart.fill")
        )
        cartNavController.tabBarItem.tag = 2
        
        let favoritesViewController = FavoritesViewController()
        let favoritesNavController = UINavigationController(rootViewController: favoritesViewController)
        favoritesNavController.tabBarItem = UITabBarItem(
            title: "Listelerim",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        favoritesNavController.tabBarItem.tag = 3
        
        let accountViewController = AccountViewController()
        let accountNavController = UINavigationController(rootViewController: accountViewController)
        accountNavController.tabBarItem = UITabBarItem(
            title: "Hesabım",
            image: UIImage(systemName: "person.circle"),
            selectedImage: UIImage(systemName: "person.circle.fill")
        )
        accountNavController.tabBarItem.tag = 4

        viewControllers = [
            homeNavController,
            categoriesNavController,
            cartNavController,
            favoritesNavController,
            accountNavController
        ]
                selectedIndex = 0
    }
    
    private func customizeTabBarAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white

            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.black
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 10, weight: .medium)
            ]

            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.n11Purple
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.n11Purple,
                .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
            ]
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.backgroundColor = UIColor.white
            tabBar.tintColor = UIColor.n11Purple
            tabBar.unselectedItemTintColor = UIColor.black
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        if let index = tabBar.items?.firstIndex(of: item) {
            animateTabSelection(at: index)
        }
    }
    
    private func animateTabSelection(at index: Int) {
        guard let tabBarItems = tabBar.items,
              index < tabBarItems.count,
              let itemView = tabBar.subviews[safe: index + 1] else { return }
        
        UIView.animate(withDuration: 0.15, animations: {
            itemView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                itemView.transform = CGAffineTransform.identity
            }
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
