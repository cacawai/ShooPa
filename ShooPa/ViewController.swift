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

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print(__FUNCTION__)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            guard message["key"] as? String == "value" else {return}
            self.label.text = "OK"
            let localNotification = UILocalNotification()
            localNotification.alertBody = "Message Received!"
//            localNotification.fireDate = NSDate()
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            
            UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
            
            let url = NSBundle.mainBundle().URLForResource("ak47-1", withExtension: "wav", subdirectory: "sound/weapons")
//            NSBundle.mainBundle().URLForResource("ak47-1", withExtension: "wav")
            if XYAudioPlayer.sharedInstance().isPlaying() == false {
                XYAudioPlayer.sharedInstance().play(url, playToTheEndBlock: { () -> Void in
                    //
                })
            }
        }

    }
}

