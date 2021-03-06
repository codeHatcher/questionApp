//
//  SocialSmilingBadOutcomeViewController.swift
//  questionApp
//
//  Created by Daniel Hsu on 7/28/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

class SocialSmilingBadOutcomeViewController: UIViewController {
  
    /** A Test containing the updated test history. This property should be set by the source view controller. */
    var test:Test?
  
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var chartRange: BNTestRangeChartView!
  @IBOutlet weak var rangeChartLabel: UILabel!
  
  var parent = Parent()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      // analytics
      Tracker.createEvent(.SocialSmiling, .Load, .Bad)
        
        // Initialize text in the view based on the test history.
        initializeViewFromTestHistory()
        
        // Schedule a local notification to remind the user to rerun this test.
        scheduleReminder()
      
      // configure chart
    // Do any additional setup after loading the view.
      chartRange.config(startMonth: 0, endMonth: 12, successAgeInMonths: 4, babyAgeInMonths: parent.ageInMonths, babyName: parent.babyName!)
      
      // font can't be set directly in storyboard for attributed string, set the label font here
      // make label's set attr string to a mutable so we can add attributes on
      let attrString:NSMutableAttributedString = NSMutableAttributedString(attributedString: rangeChartLabel.attributedText!)
      
      // add font attribute
      attrString.addAttribute(NSFontAttributeName, value: UIFont(name: kOmnesFontMedium, size: 15)!, range: NSMakeRange(0, attrString.length))
      rangeChartLabel.attributedText = attrString
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "socialSmilingToActivityReminderSegue" {
            let controller = segue.destinationViewController as! ActivityReminderViewController
            
            // set the test name on the ActivityReminder VC
            controller.testName = TestNamesPresentable.socialsmiling
        }
    }
    
    @IBAction func onHomeButtonTap(sender: AnyObject) {
        var storyboard = UIStoryboard (name: "Main", bundle: nil)
        var controller: MilestonesViewController = storyboard.instantiateViewControllerWithIdentifier("MilestonesVCStoryboardID") as! MilestonesViewController
        self.presentViewController(controller, animated: true, completion: nil);
        
    }
    
    // Helper function formats text attributes for multiple substrings in label.
    func applyTextAttributesToLabel(string: String, indexAtStartOfBold index: Int, countOfBoldCharacters count: Int) {
        
        var attributedString = NSMutableAttributedString(string: string)
        
        let baseAttributes = [NSForegroundColorAttributeName: kGrey, NSFontAttributeName: UIFont(name: kOmnesFontMedium, size: 22)!]
        let boldAttributes = [NSForegroundColorAttributeName: kGrey, NSFontAttributeName: UIFont(name: kOmnesFontSemiBold, size: 22)!]
        
        attributedString.addAttributes(baseAttributes, range: NSMakeRange(0, index > 0 ? index - 1 : index))
        attributedString.addAttributes(boldAttributes, range: NSMakeRange(index, count))
        
        infoLabel.attributedText = attributedString
    }
    
    /*!
    @brief Initialize the text in the view based on the number of failed tests.
    */
    func initializeViewFromTestHistory() {
        var failed = 0
        if let failedCount = test?.failedTestsCount() {
            failed = failedCount
        }
        
      if failed <= 1 {
            // update infoLabel
            let string = "Not to worry. Not all babies develop at the same rate.Try again and be sure baby is rested, fed, and alert."
            applyTextAttributesToLabel(string, indexAtStartOfBold:54, countOfBoldCharacters:52)
        } else if failed == 2 {
            // update questionLabel
            questionLabel.text = "Not social smiling?"
            
            // update infoLabel
            let string = "Try this: get baby's attention by making a sound. You may also show baby a toy while talking and smiling. Does baby smile? If not, try again in 3 days."
            applyTextAttributesToLabel(string, indexAtStartOfBold:122, countOfBoldCharacters:29)
            
        } else if failed >= 3 {
            // update questionLabel
            questionLabel.text = "Not social smiling?"
            
            // update infoLabel
            let string = "Perform this test a few more times to be sure the outcome is consistent. If so, record this test to show your pediatrician."
            applyTextAttributesToLabel(string, indexAtStartOfBold:73, countOfBoldCharacters:50)
        } else {
            // update questionLabel
            questionLabel.text = "Not social smiling?"
            
            // update infoLabel
          let string = "Not to worry. Not all babies develop at the same rate.Try again and be sure baby is rested, fed, and alert."
            applyTextAttributesToLabel(string, indexAtStartOfBold:55, countOfBoldCharacters:53)
        }
    }
    
    /*!
    @brief Schedule a local notification to remind the user to run the test again.
    @discussion The local notification is scheduled if it does not currently exist.
    */
    func scheduleReminder() {
        
        if BNLocalNotification.doesLocalNotificationExist(Test.TestNamesPresentable.socialSmiling) == false {
            
            // configure the local notification
            let localNotification = BNLocalNotification(nameOfTest: Test.TestNamesPresentable.socialSmiling, secondsBeforeDisplayingReminder: Test.NotificationInterval.socialSmiling)
            
            // schedule the local notification
            localNotification.scheduleNotification()
        }
    }
}
