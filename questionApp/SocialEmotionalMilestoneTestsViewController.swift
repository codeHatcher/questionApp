//
//  SocialEmotionalMilestoneTestsViewController.swift
//  questionApp
//
//  Created by john bateman on 7/13/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

class SocialEmotionalMilestoneTestsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onMilestonesBarButtonItem(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onPointFollowingButtonTap(sender: AnyObject) {
        var storyboard = UIStoryboard (name: "PointFollowing", bundle: nil)
        var controller: WhyIsPointFollowingViewController = storyboard.instantiateViewControllerWithIdentifier("WhyIsPointFollowingStoryboardID") as! WhyIsPointFollowingViewController
        self.presentViewController(controller, animated: true, completion: nil);
    }
}