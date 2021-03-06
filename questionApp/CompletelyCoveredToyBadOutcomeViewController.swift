//
//  CompletelyCoveredToyBadOutcomeViewController.swift
//  questionApp
//
//  Created by Daniel Hsu on 8/7/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

class CompletelyCoveredToyBadOutcomeViewController: UIViewController {
  
    /** A Test containing the updated test history. This property should be set by the source view controller. */
    var test : Test?
    var parent = Parent()
  
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var rangeChartView: BNTestRangeChartView!
    @IBOutlet weak var rangeChartLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // analytics
      Tracker.createEvent(.CompletelyCovered, .Load, .Bad)
        
        // Initialize text in the view based on the test history.
        initializeViewFromTestHistory()
        
        // Schedule a local notification to remind the user to rerun this test.
        scheduleReminder()
        
        rangeChartView.config(startMonth: 0, endMonth: 20, successAgeInMonths: 15, babyAgeInMonths: parent.ageInMonths, babyName: parent.babyName!)
        
        // font can't be set directly in storyboard for attributed string, set the label font here
        // make label's set attr string to a mutable so we can add attributes on
        let attrString:NSMutableAttributedString = NSMutableAttributedString(attributedString: rangeChartLabel.attributedText!)
        
        // add font attribute
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: kOmnesFontSemiBold, size: 13)!, range: NSMakeRange(0, attrString.length))
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
        if segue.identifier == "completelyCoveredToyToActivityReminderSegue" {
            let controller = segue.destinationViewController as! ActivityReminderViewController
            
            // set the test name on the ActivityReminder VC
            controller.testName = TestNamesPresentable.completelyCoveredToy
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
          let string = "Not to worry. Not all babies develop at the same rate.\nTry again and be sure baby is rested, fed, and alert."
          applyTextAttributesToLabel(string, indexAtStartOfBold:0, countOfBoldCharacters:0)
        } else if failed == 2 {
          // update questionLabel
          questionLabel.text = "Didn't react?"
          
          // update infoLabel
          let string = "ry the test again using baby’s favorite toy and with a little bit of the toy showing.\nIf baby still doesn’t react, try the test again in 2 weeks."
          applyTextAttributesToLabel(string, indexAtStartOfBold:0, countOfBoldCharacters:0)
          
        } else {
          // update questionLabel
          questionLabel.text = "Didn't react?"
          
          // update infoLabel
          let string = "Inability to recognize Object Permanence after 12 months may indicate visual and/or cognitive issues. \nIf baby consistently shows no reaction beyond 12 months, record the video and talk to your pediatrician at your next well-child visit."
          applyTextAttributesToLabel(string, indexAtStartOfBold:0, countOfBoldCharacters:0)
        }}
    
    /*!
    @brief Schedule a local notification to remind the user to run the test again.
    @discussion The local notification is scheduled if it does not currently exist.
    */
    func scheduleReminder() {
        
        if BNLocalNotification.doesLocalNotificationExist(Test.TestNamesPresentable.completelyCoveredToy) == false {
            
            // configure the local notification
            let localNotification = BNLocalNotification(nameOfTest: Test.TestNamesPresentable.completelyCoveredToy, secondsBeforeDisplayingReminder: Test.NotificationInterval.completelyCoveredToy)
            
            // schedule the local notification
            localNotification.scheduleNotification()
        }
    }
}
