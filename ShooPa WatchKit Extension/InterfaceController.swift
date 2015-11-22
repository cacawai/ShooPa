//
//  InterfaceController.swift
//  ShooPa WatchKit Extension
//
//  Created by xuxinyuan on 15/7/6.
//  Copyright © 2015年 last4. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    let motionMgr:CMMotionManager = CMMotionManager()
    let motionQueue:NSOperationQueue = NSOperationQueue.mainQueue()
    let assetURL = NSBundle.mainBundle().URLForResource("fart", withExtension: "wav")
    var audioFilePlayer:WKAudioFilePlayer!
    var session:WCSession!
    
    @IBOutlet var testLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self // conforms to WCSessionDelegate
            session.activateSession()
        }
        coreMotionAcceleroMeterTest()
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.initAudioFilePlayer(assetURL!)
        let session = WCSession.defaultSession()
        session.activateSession()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func onClickPlayBtn() {
        self.playSoundByAudioFilePlayer(assetURL!)
    }

    func initAudioFilePlayer(assetURL: NSURL) {
        let asset = WKAudioFileAsset(URL: assetURL)
        let playerItem = WKAudioFilePlayerItem(asset: asset)
        audioFilePlayer = WKAudioFilePlayer(playerItem: playerItem)
    }
    
    func playSoundByAudioFilePlayer(assetURL: NSURL) {
        print("Play\n")
        if (audioFilePlayer.status == WKAudioFilePlayerStatus.ReadyToPlay) {
            audioFilePlayer.play()
        }
    }
    
    func playSoundByMediaPlayerController(url: NSURL) {
        
        self.presentMediaPlayerControllerWithURL(url, options: [WKMediaPlayerControllerOptionsAutoplayKey: true]) { (didPlayToEnd: Bool, endTime: NSTimeInterval, err: NSError?) -> Void in
            if (!didPlayToEnd) {
                print("The player did not play all the way to the end. The player only played until time - \(endTime)\n")
            }
            
            if err != nil{
                print("There was an error with playback:" + (err?.description)! + "\n")
            }
        }
    }
    
    func coreMotionAcceleroMeterTest()
    {
        motionMgr.accelerometerUpdateInterval = 0.1
        motionMgr.startAccelerometerUpdatesToQueue(motionQueue) { (accel: CMAccelerometerData?, err: NSError?) -> Void in
            let acceleration:CMAcceleration = accel!.acceleration
            let dataToSend = "X:\(acceleration.x) Y:\(acceleration.y) Z:\(acceleration.z)\n"
//            print(dataToSend)
            if abs(acceleration.x) > 1 || abs(acceleration.y) > 1 || abs(acceleration.z) > 1 {
//                self.playSoundByMediaPlayerController(self.assetURL!)
//                self.playSoundByAudioFilePlayer(self.assetURL!)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.communicateWithTheMainApp(dataToSend)
                })
            }
        }
    }
    
    func communicateWithTheMainApp(dataToSend: String) {
        if (WCSession.defaultSession().reachable) {
            testLabel.setText("Reachable")
            let applicationDict = ["key":"value"]// Create a dict of application data
            WCSession.defaultSession().sendMessage(applicationDict, replyHandler: { (reply: [String : AnyObject]) -> Void in
                //
                }, errorHandler: { (err: NSError) -> Void in
                    print(err.description)
            })
        }else{
            testLabel.setText("Unreachable")
        }
    }
}
