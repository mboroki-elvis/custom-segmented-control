//
//  AppDelegate.swift
//  ThemeExample
//
//  Created by Elvis Mwenda on 08/05/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationContoller = UINavigationController(rootViewController: ViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationContoller
        window?.makeKeyAndVisible()
        return true
    }
}

