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
        
        let result = resolveUrl(url)
        
        if result.intent == "adjust" {
            // force to access method in ViewController
            (window?.rootViewController as? ViewController)?.fromWidgetBackToApp(brightness: Float(result.value)!)
        } else if result.intent == "set" {
            // force to access method in ViewController
            (window?.rootViewController as? ViewController)?.fromWidgetBackToApp(customNum: Int(result.value)!)
        }
        
        return false
    }
    
    private func resolveUrl(_ url: URL) -> (intent: String, value: String){
        
        let urlString = url.absoluteString
        
        // default(set)
        var intent = "set"
        var index = urlString.index(urlString.startIndex, offsetBy: 17)
        
        // if adjust
        if urlString.contains("adjust") {
            intent = "adjust"
            index = urlString.index(urlString.startIndex, offsetBy: 20)
        }
        
        // get value
        let para = String(urlString[index...])
        
        return (intent, para)
    }
}

