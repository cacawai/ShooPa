//
//  ViewController.swift
//  ShooPa
//
//  Created by xuxinyuan on 15/7/6.
//  Copyright © 2015年 last4. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func session(session: WCSession, didReceiveMessage message: [String : AnyObject])
    {
        NSLog("didReceiveMessage")
    }
}

