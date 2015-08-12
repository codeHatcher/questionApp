//
//  SelfRecognitionBadOutcomeViewController.swift
//  questionApp
//
//  Created by Daniel Hsu on 7/24/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

class SelfRecognitionBadOutcomeViewController: UIViewController {

    /** A history of previous test outcomes. This property should be set by the source view controller. */
    var test:Test?
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize text in the view based on the test history.
        initializeViewFromTestHistory()
        
        // Schedule a local notification, once, to remind the user to rerun this test.
        scheduleReminderOnce()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selfRecognitionToActivityReminderSegue" {
            let controller = segue.destinationViewController as! ActivityReminderViewController
            
            // set the test name on the ActivityReminder VC
            controller.testName = TestNamesPresentable.selfrecognition
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
        @param testName (in) Name of the test. Must be of Test.TestNames.
    */
    func initializeViewFromTestHistory() {
        var failed = 0
        if let failedCount = test?.failedTestsCount() {
            failed = failedCount
        }
      
        if failed <= 1 {
            // update infoLabel
            let string = "Not to worry. Baby is a bit too young for this skill.\nTry again in a month."
            applyTextAttributesToLabel(string, indexAtStartOfBold:54, countOfBoldCharacters:21)
        } else if failed == 2 {
            // update questionLabel
            questionLabel.text = "No self recognition?"
            
            // update infoLabel
            let string = "Did baby make noises, smile at her reflection, or suddenly become unhappy? This means she’s on her way to recognizing her reflection. Practice by playing peekaboo or showing baby photos of herself, then try the test again in a month."
            applyTextAttributesToLabel(string, indexAtStartOfBold:134, countOfBoldCharacters:99)
            
        } else if failed == 3 {
            // update questionLabel
            questionLabel.text = "No self recognition?"
            
            // update infoLabel
            let string = "Since your baby is under 12 months, she still has time to develop those muscles. If you're concerned, check with your pediatrician."
            applyTextAttributesToLabel(string, indexAtStartOfBold:81, countOfBoldCharacters:50)
        } else if failed >= 4 {
            // update questionLabel
            questionLabel.text = "No self recognition?"
            
            // update infoLabel
            let string = "Most babies develop self recognition by age two or three. If your baby consistenty shows no reaction beyond age two, talk to your pediatrician at your next well-child visit."
            applyTextAttributesToLabel(string, indexAtStartOfBold:58, countOfBoldCharacters:115)
        } else {
            // update questionLabel
            questionLabel.text = "No self recognition?"
            
            // update infoLabel
            let string = "Not to worry. Baby is a bit too young for this skill.\nTry again in a month."
            applyTextAttributesToLabel(string, indexAtStartOfBold:54, countOfBoldCharacters:21)
        }
    }
    
    /*!
    @brief Schedule a local notification to remind the user to run the test again.
    @discussion The local notification is scheduled once, based on the number of failed tests. The number of previous failed tests that triggers the notification for each specific test is stored in the Test.LocalNotificationTrigger struct.
    */
    func scheduleReminderOnce() {
        var failed = 0
        if let failedCount = test?.failedTestsCount() {
            failed = failedCount
        }
        
        if failed == Test.LocalNotificationTrigger.selfRecognition {
            let localNotification = BNLocalNotification(nameOfTest: Test.TestNamesPresentable.selfRecognition, secondsBeforeDisplayingReminder: Test.NotificationInterval.selfRecognition)
            localNotification.scheduleNotification(self)
        }
    }
}
