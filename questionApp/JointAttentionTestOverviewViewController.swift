//
//  JointAttentionTestOverviewViewController.swift
//  questionApp
//
//  Created by Michael Leung on 8/17/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class JointAttentionTestOverviewViewController: UIViewController {
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        if segue.identifier == "pointFollowingEmbeddedVideoSegue" {
        }
        else if segue.identifier == "JointAttentionWhatWillYouNeedSegueID" {
        }
    }
    
  
    @IBAction func onBackTap(sender: BNBackButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}