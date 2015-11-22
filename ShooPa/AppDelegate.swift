//
//  AppDelegate.swift
//  ShooPa
//
//  Created by xuxinyuan on 15/7/6.
//  Copyright © 2015年 last4. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WCSessionDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if WCSession.isSupported() {
            WCSession.defaultSession().delegate = self
            WCSession.defaultSession().activateSession()
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func sessionWatchStateDidChange(session: WCSession) {
        
    }
    
    /** ------------------------- Interactive Messaging ------------------------- */
     
     /** Called when the reachable state of the counterpart app changes. The receiver should check the reachable property on receiving this delegate callback. */
    @available(iOS 9.0, *)
    func sessionReachabilityDidChange(session: WCSession) {
        
    }
    
    /** Called on the delegate of the receiver. Will be called on startup if the incoming message caused the receiver to launch. */
    @available(iOS 9.0, *)
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        
    }

}

