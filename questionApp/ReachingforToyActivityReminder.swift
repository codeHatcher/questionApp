//
//  ReachingforToyActivityReminder.swift
//  questionApp
//
//  Created by Lekshmi on 9/23/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import Foundation
import UIKit

class  ReachingforToyActivityReminder: ActivityReminderViewController{
  
  @IBAction func onHomeButtonTap(sender: AnyObject) {
    var storyboard = UIStoryboard (name: "Main", bundle: nil)
    var controller: MilestonesViewController = storyboard.instantiateViewControllerWithIdentifier("MilestonesVCStoryboardID") as! MilestonesViewController
    self.presentViewController(controller, animated: true, completion: nil);
  }
}