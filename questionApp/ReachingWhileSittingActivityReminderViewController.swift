//
//  ReachingWhileSittingActivityReminderViewController.swift
//  questionApp
//
//  Created by Daniel Hsu on 8/9/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

class ReachingWhileSittingActivityReminderViewController: ActivityReminderViewController {
   
    @IBAction func onHomeButtonTap(sender: AnyObject) {
        var storyboard = UIStoryboard (name: "Main", bundle: nil)
        var controller: MilestonesViewController = storyboard.instantiateViewControllerWithIdentifier("MilestonesVCStoryboardID") as! MilestonesViewController
        self.presentViewController(controller, animated: true, completion: nil);
    }
}
