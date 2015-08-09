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


class InterfaceController: WKInterfaceController {
    let motionMgr:CMMotionManager = CMMotionManager()
    let motionQueue:NSOperationQueue = NSOperationQueue.mainQueue()
    let assetURL = NSBundle.mainBundle().URLForResource("fart", withExtension: "wav")
    
    @IBOutlet var testLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        coreMotionAcceleroMeterTest()
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func onClickPlayBtn() {
        self.playSoundByMediaPlayerController(assetURL!)
    }
    
    func playSoundByAudioFilePlayer(assetURL: NSURL) {
        let asset = WKAudioFileAsset(URL: assetURL)
        let playerItem = WKAudioFilePlayerItem(asset: asset)
        let audioFilePlayer = WKAudioFilePlayer(playerItem: playerItem)
            
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
//            self.testLabel.setText("X:\(acceleration.x) Y:\(acceleration.y) Z:\(acceleration.z)")
            if abs(acceleration.x) > 1 || abs(acceleration.y) > 1 || abs(acceleration.z) > 1 {
                self.playSoundByMediaPlayerController(self.assetURL!)
            }
        }
    }
}
