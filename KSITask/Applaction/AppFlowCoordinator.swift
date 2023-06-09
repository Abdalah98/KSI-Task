//
//  OnboardingVC.swift
//  todoor
//
//  Created by Abdallah on 07/05/2023.
//

import Foundation
import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

      let mainViewController = HomeVC()
      navigationController.pushViewController(mainViewController, animated: true)
    }


}
