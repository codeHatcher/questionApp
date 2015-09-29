//
//  PincerTestOverviewViewController.swift
//  questionApp
//
//  Created by john bateman on 7/16/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PincerTestOverviewViewController: UIViewController {

    @IBOutlet weak var previewButton: UIButton!
    var playerVC:AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // analytics
      Tracker.createEvent(.PincerGrasp, .Load, .Overview)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pincerEmbeddedVideoSegue" {
            // set the playerVC as the destination
            playerVC = segue.destinationViewController as! AVPlayerViewController
            let path = NSBundle.mainBundle().pathForResource("pincer grasp", ofType: "mp4")
            let url = NSURL.fileURLWithPath(path!)
            // let url = NSURL(string: "crawl.mp4") // for remote locations
            
            // hide player controls
            playerVC.showsPlaybackControls = false
            playerVC.hidesBottomBarWhenPushed = true
            playerVC.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            playerVC.player = AVPlayer(URL: url)
            // we start off paused, then we will play once the button is hit
            playerVC.player?.pause()
            
            // listen for video end notification
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "enableVideoReplay",
                name: AVPlayerItemDidPlayToEndTimeNotification,
                object: playerVC.player?.currentItem)
        }
        else if segue.identifier == "pincerWhatWillYouNeedSegueID" {
            playerVC.player?.pause()
        }
    }
    
    @IBAction func onBackTap(sender: BNBackButton) {
        playerVC.player?.pause()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
