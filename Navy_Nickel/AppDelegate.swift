//
//  AppDelegate.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła(S) on 18/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: ChaptersViewController())
        self.window = window
        window.makeKeyAndVisible()
        return true
    }

}
