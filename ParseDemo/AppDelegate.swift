//
//  AppDelegate.swift
//  ParseDemo
//
//  Created by Jeremy Petter on 2016-03-30.
//  Copyright © 2016 JeremyPetter. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        //Initialize Parse
        Parse.setApplicationId("PZzGTD8UFGZlKQLmHyeMxxGI2FYvFp7XlQAnNisZ", clientKey: "8RRx1K4yII8EEf01u1008PqwKcRZLttM7CPFNxP9")

        //Setup initial window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        guard let window = window else {
            print("couldn't initialize window")
            return true
        }
        window.backgroundColor = UIColor.whiteColor()
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()

        return true
    }
}

