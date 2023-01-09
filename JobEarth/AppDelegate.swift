//
//  AppDelegate.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/02.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let container = Container()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        inject()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func inject() {
        container.register(ViewModel.self) { res in
            ViewModel(recruitNetwork: res.resolve(RecruitNetworInterface.self)!, cellNetwork: res.resolve(CellNetworkInterface.self)!)
        }
        container.register(RecruitNetworInterface.self) { _ in
            RecruitNetwork(network: Network<RecruitData>())}

        container.register(CellNetworkInterface.self) { _ in
            CellNetwork(network: Network<CellData>())
        }
    }

}
