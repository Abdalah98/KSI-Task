//
//  CustomTabbar.swift
//  KSITask
//
//  Created by Bedo on 13/06/2023.
//

import UIKit

class CustomTabbar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false

        setTabBarViewControllers()
        setupTabBarColors()
        setupTabbarItemsInsets()
    }
    fileprivate func setupTabbarItemsInsets() {
        tabBar.items?.forEach { $0.imageInsets.bottom = -4 }
        // force titles to be redrawn in the correct positions
        tabBar.items?.forEach { $0.titlePositionAdjustment.vertical = -8 }
        // push the title out of the bounds of the screen to hide it
    }
    fileprivate func setTabBarViewControllers() {
        self.viewControllers = [
            UINavigationController(rootViewController: HomeVC()),
            UINavigationController(rootViewController: MartVC()),
            UINavigationController(rootViewController: CartVC()),
            UINavigationController(rootViewController: FavouriteVC()),
            UINavigationController(rootViewController: ProfileVC()),

        ]
        self.tabBar.items?[0].image = UIImage(named: "Home")!
        self.tabBar.items?[1].image = UIImage(named: "cart")!
        self.tabBar.items?[2].image = UIImage(named: "markt")!
        self.tabBar.items?[3].image = UIImage(named: "favoirt")!
        self.tabBar.items?[4].image = UIImage(named: "Profile")!

    }
    fileprivate func setupTabBarColors() {
        tabBar.tintColor = .purple
        tabBar.barTintColor = .black
        tabBar.unselectedItemTintColor = .white
    }

}
