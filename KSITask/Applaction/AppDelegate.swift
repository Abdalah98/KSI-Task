//
//  AppDelegate.swift
//  KSITask
//
//  Created by Bedo on 09/06/2023.
//

import UIKit
import CoreData
import RealmSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    var appFlowCoordinator: AppFlowCoordinator?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

      
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()

        window?.rootViewController = navigationController
        appFlowCoordinator = AppFlowCoordinator(navigationController: navigationController)
        appFlowCoordinator?.start()
        RealmConfiguration.configure()
      return true
    }
  

}

class RealmConfiguration {
    static func configure() {
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        
        // Uncomment the following line if you want to delete and recreate the Realm file on each app launch (for testing/development purposes).
        // try! FileManager.default.removeItem(at: config.fileURL!)
    }
}
