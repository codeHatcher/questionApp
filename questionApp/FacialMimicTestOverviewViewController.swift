//
//  FacialMimicTestOverviewViewController.swift
//  questionApp
//
//  Created by john bateman on 7/29/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FacialMimicTestOverviewViewController: UIViewController {

    @IBOutlet weak var previewButton: UIButton!
    var playerVC:AVPlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // analytics
      Tracker.createEvent(.FacialMimic, .Load, .Overview)
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
        if segue.identifier == "FacialMimicEmbeddedVideoSegue" {

        }
        else if segue.identifier == "FacialMimicWhatWillYouNeedSegueID" {
        }
    }
  
    @IBAction func onBackTap(sender: BNBackButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
