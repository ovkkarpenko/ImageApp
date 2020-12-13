//
//  AppDelegate.swift
//  ImageApp
//
//  Created by Oleksandr Karpenko on 11.12.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let rootNc = UINavigationController(rootViewController: MainViewController())
        
        window = UIWindow()
        window?.rootViewController = rootNc
        window?.makeKeyAndVisible()
        
        return true
    }
}

