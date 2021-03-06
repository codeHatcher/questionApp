//
//  WhyIsPupilResponseViewController.swift
//  questionApp
//
//  Created by Brown Magic on 6/28/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

class WhyIsPupilResponseViewController: UIViewController {
  
  @IBOutlet weak var pupilResponseDescriptionLabel: UILabel!
  @IBOutlet weak var backButton: BNBackButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
	Tracker.createEvent(.PupilResponse, .Load, .Why)
    
    // Do any additional setup after loading the view.
    
    // set up attributes for both part of pupil response description label
    let string = "Baby's pupils should expand and contract in varying light levels. It's a quick indication of how the eyes, or nerves connecting the eyes to the brain, are doing."
    var attributedString = NSMutableAttributedString(string: string)
    
    let firstAttributes = [NSForegroundColorAttributeName: kGrey, NSFontAttributeName: UIFont(name: kOmnesFontSemiBold, size: 22)!]
    let secondAttributes = [NSForegroundColorAttributeName: kGrey, NSFontAttributeName: UIFont(name: kOmnesFontMedium, size: 22)!]
    
    attributedString.addAttributes(firstAttributes, range: NSMakeRange(12, 28))
    attributedString.addAttributes(secondAttributes, range: NSMakeRange(40, 13))
    
    pupilResponseDescriptionLabel.attributedText = attributedString
    
    // if no view controller to dismiss, don't show back button
    if (self.presentingViewController == nil) {
//      backButton.hidden = true
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  @IBAction func onBackTap(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  
}
