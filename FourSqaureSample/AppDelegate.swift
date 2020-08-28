//
//  AppDelegate.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if UserDefaults.standard.object(forKey: Constants.DefaultLocationMode) == nil {
            UserDefaults.standard.set(LocationMode.single.rawValue, forKey: Constants.DefaultLocationMode)
        }
        return true
    }

}

