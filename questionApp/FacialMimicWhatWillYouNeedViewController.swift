//
//  FacialMimicWhatWillYouNeedViewController.swift
//  questionApp
//
//  Created by john bateman on 7/29/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

class FacialMimicWhatWillYouNeedViewController: UIViewController {

    @IBOutlet weak var testPreparationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // analytics
      Tracker.createEvent(.FacialMimic, .Load, .WhatIsNeeded)
        //applyTextAttributesToLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onNextStepButtonTap(sender: AnyObject) {
        let dontShowIsBabyReadyVC = NSUserDefaults.standardUserDefaults().boolForKey("dontShowIsBabyReady")
        if dontShowIsBabyReadyVC == true {
            performSegueWithIdentifier("FacialMimicTimeToTestSegueID", sender: self)
        } else {
            performSegueWithIdentifier("FacialMimicIsBabyReadySegueID", sender: self)
        }
    }
    
    @IBAction func onBackButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Helper function formats text attributes for multiple substrings in label.
    func applyTextAttributesToLabel() {
        
        let string = "You'll need your baby. That's it!"
        
        var attributedString = NSMutableAttributedString(string: string)
        
        let baseAttributes = [NSForegroundColorAttributeName: kGrey, NSFontAttributeName: UIFont(name: kOmnesFontMedium, size: 22)!]
        let firstAttributes = [NSForegroundColorAttributeName: kGrey, NSFontAttributeName: UIFont(name: kOmnesFontSemiBold, size: 22)!]
        let secondAttributes = [NSForegroundColorAttributeName: kGrey, NSFontAttributeName: UIFont(name: kOmnesFontMedium, size: 22)!]
        
        attributedString.addAttributes(baseAttributes, range: NSMakeRange(0, 20))
        attributedString.addAttributes(firstAttributes, range: NSMakeRange(21, 12))
        attributedString.addAttributes(secondAttributes, range: NSMakeRange(33, 29))
        
        testPreparationLabel.attributedText = attributedString
    }
}
