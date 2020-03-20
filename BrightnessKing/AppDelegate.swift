//
//  AppDelegate.swift
//  Practice
//
//  Created by 何榮森 on 2020/3/17.
//  Copyright © 2020 何榮森. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("url: \(url)")
        
        let urlString = url.absoluteString
        let index = urlString.index(urlString.startIndex, offsetBy: 13)
        let para = String(urlString[index...])
        print("get brightness: \(para)")
        
        // force to access method in ViewController
        (window?.rootViewController as? ViewController)?.fromWidgetBackToApp(brightness: Float(para)!)
        
        return false
    }
}

