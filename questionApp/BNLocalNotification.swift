/*!
@header BNLocalNotification.swift

@brief This file contains the BNLocalNotification class which schedules local notifications.
@discussion The class should be initialized with a test name and the number of seconds before the notification is displayed to the user.

Created on 8/5/15

@author John Bateman

@copyright 2015 Qidza, Inc.
*/

import UIKit
import Foundation

/* A custom NSNotification that indicates that a test reminder has been scheduled. */
let testReminderScheduledNotificationKey =  "com.qidza.testReminderScheduledNotificationKey"

/* A custom NSNotification that indicates that a test reminder has been removed. */
let testReminderRemovedNotificationKey =  "com.qidza.testReminderRemovedNotificationKey"

/* Name of key used in the userInfo dictionary in the testReminder notifications.*/
let testNameUserInfoKey = "testName"


class BNLocalNotification {

  struct NotificationConstants {
    static var subject = "babynoggin Test Reminder"
    static var body = "It's time to retry the test."
    static var reminderBodyFormatted = "It's time to retry the %@ test if your baby has not yet passed."
    static var composerErrorTitle = "Error"
    static var composerErrorMessage = "Unable to schedule the reminder."
    static var defaultInterval: Double = 1209600 // (14 * 24 * 60 * 60) = 2 weeks
    static var confirmedTitle = "All set!"
    static var confirmedMessage = "A notification has been scheduled when it is time to try the %@ test again in 2 weeks"
    static var button = "OK"
  }
  
  static let LocalNotificationInfoDictionaryTestNameKey = "NotificationTestName"
  
  /* Set testName to a TestNamesPresentable member to identify the test. (See Test.TestNamesPresentable) This testName will be used in the Reminder presented to the user.
  */
  var testName: String? = nil
  
  /* Set elapsedSecondsBeforePresentingReminder to identify the number of seconds from now that should elapse before the reminder is presented to the user.
  */
  var elapsedSecondsBeforePresentingReminder: Double = NotificationConstants.defaultInterval // 2 weeks in seconds by default
  
  /*
  @brief This designated initializer initializes a BNLocalNotification instance with a test name and schedule interval.
  @param (in) nameOfTest - identifies the test.
  @param (in) secondsBeforeDisplayingReminder - Number of seconds to wait before displaying the notification to the user.
  */
  init(nameOfTest: String, secondsBeforeDisplayingReminder: Double) {
    testName = nameOfTest
    elapsedSecondsBeforePresentingReminder = secondsBeforeDisplayingReminder
  }
  
  /*
  @brief Create the local notification on this device.
  @discussion Uses the fire date identified in self.elapsedSecondsBeforePresentingReminder.
  */
  @IBAction func scheduleNotification() {
    
    let localNotification = UILocalNotification()
    
    // configure the title
    if #available(iOS 8.2, *) {
      localNotification.alertTitle = NotificationConstants.subject
    }
    
    // configure body
    if let testName = self.testName {
      let bodyString = String(format: NotificationConstants.reminderBodyFormatted, testName)
      localNotification.alertBody = bodyString
    } else {
      localNotification.alertBody = NotificationConstants.body
    }
    
    // increment the badge number
    let currentBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber
    localNotification.applicationIconBadgeNumber = currentBadgeNumber + 1
    
    // ask user for permission to display notifications
    acquireNotificationPermission()

    // Specify the test in the userInfo property so the app knows which test to display when it is launched.
    if let testName = testName {
      let infoDictionary = [BNLocalNotification.LocalNotificationInfoDictionaryTestNameKey : testName]
      localNotification.userInfo = infoDictionary
    }
    
    // schedule the notification
    localNotification.fireDate = NSDate(timeIntervalSinceNow: elapsedSecondsBeforePresentingReminder)
    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    
    // Send a notification indicating that a reminder has been scheduled.
    if let testName = testName {
      postTestReminderScheduledNotification(testName)
    }
  }
  
  /*
  @brief Ask the user for permission to register local notifications on this device.
  @discussion Registers UI, Sound, and Badge permissions for the notifications.
  */
  func acquireNotificationPermission() {
    
    let registerUserNotificationSettings = UIApplication.instancesRespondToSelector("registerUserNotificationSettings:")
    
    if registerUserNotificationSettings {
      var types: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound, UIUserNotificationType.Badge]
      
      UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: types, categories: nil))
    }
  }
  
  /*
  @brief Show an Alert Message to the user explaining that the notification has been scheduled.
  */
  func presentConfirmationAlert() {
    
    // configure the message
    var messageString: String = ""
    if let testName = testName {
      messageString = String(format: NotificationConstants.confirmedMessage, testName)
    } else {
      messageString = String(format: NotificationConstants.confirmedMessage, "")
    }
    let alert = UIAlertView(title: NotificationConstants.confirmedTitle, message: messageString, delegate: self, cancelButtonTitle: NotificationConstants.button)
    
    // display the alert on the main thread
    dispatch_async(dispatch_get_main_queue()) {
      alert.show()
    }
  }
  
  /*
  @brief Display the first view controller of the test identified in the notification.
  @param (in) localNotification - The local notification selected by the end user. It contains a userInfo dictionary identifying the test to launch.
  */
  static func handleLocalNotification(localNotification: UILocalNotification) {
    
    let testName = localNotification.userInfo![BNLocalNotification.LocalNotificationInfoDictionaryTestNameKey] as! String
    let testID = 0
    var storyboardID: String? = nil
    var controller : UIViewController? = nil
    
    BNLocalNotification.presentTestViewController(testName)
    
//    switch testName {
//      
//    case Test.TestNamesPresentable.pupilResponse:  // Pupil Response
//      storyboardID = "WhyIsPupilResponseStoryboardID"
//      var storyboard = UIStoryboard (name: "Main", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPupilResponseViewController
//      
//    case Test.TestNamesPresentable.fallingToy: // Falling Toy
//      storyboardID = "WhyIsObjectPermanenceStoryboardID"
//      var storyboard = UIStoryboard (name: "Main", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsObjectPermanenceViewController
//    
//    case Test.TestNamesPresentable.letsCrawl: // Let's Crawl
//      storyboardID = "WhyIsCrawlingViewControllerStoryboardID"
//      var storyboard = UIStoryboard (name: "Main", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsCrawlingViewController
//    
//    case Test.TestNamesPresentable.pointFollowing: // Point Following
//      storyboardID = "WhyIsPointFollowingStoryboardID"
//      var storyboard = UIStoryboard (name: "PointFollowing", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPointFollowingViewController
//    
//    case Test.TestNamesPresentable.hearing: // Hearing
//      storyboardID = "WhyIsHearingStoryboardID"
//      var storyboard = UIStoryboard (name: "Hearing", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsHearingViewController
//    
//    case Test.TestNamesPresentable.crossingEyes: // Crossing Eyes
//      storyboardID = "WhyIsCrossingEyesStoryboardID"
//      var storyboard = UIStoryboard (name: "CrossingEyes", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsCrossingEyesViewController
//    
//    case Test.TestNamesPresentable.attentionAtDistance: // Attention at Distance
//      storyboardID = "WhyIsAttentionAtDistanceStoryboardID"
//      var storyboard = UIStoryboard (name: "AttentionAtDistance", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsAttentionAtDistanceViewController
//    
//    case Test.TestNamesPresentable.symmetry: // Symmetry
//      storyboardID = "WhyIsSymmetryStoryboardID"
//      var storyboard = UIStoryboard (name: "Symmetry", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsSymmetryViewController
//    
//    case Test.TestNamesPresentable.pincer: // Pincer
//      storyboardID = "WhyIsPincerStoryboardID"
//      var storyboard = UIStoryboard (name: "Pincer", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPincerViewController
//    
//    case Test.TestNamesPresentable.partiallyCoveredToy: // Partially Covered Toy
//      storyboardID = "WhyIsPartiallyCoveredToyStoryboardID"
//      var storyboard = UIStoryboard (name: "PartiallyCoveredToy", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPartiallyCoveredToyViewController
//    
//    case Test.TestNamesPresentable.selfRecognition: // Self Recognition
//      storyboardID = "WhyIsSelfRecognitionStoryboardID"
//      var storyboard = UIStoryboard (name: "SelfRecognition", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsSelfRecognitionController
//    
//    case Test.TestNamesPresentable.socialSmiling: // Social Smiling
//      storyboardID = "WhyIsSocialSmilingStoryboardID"
//      var storyboard = UIStoryboard (name: "SocialSmiling", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsSocialSmilingViewController
//    
//    case Test.TestNamesPresentable.facialMimic: // Facial Mimic
//      storyboardID = "WhyIsFacialMimicStoryboardID"
//      var storyboard = UIStoryboard (name: "FacialMimic", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsFacialMimicViewController
//      
//    case Test.TestNamesPresentable.unassistedSitting: // Unassisted Sitting
//      storyboardID = "WhyIsUnassistedSittingStoryboardID"
//      var storyboard = UIStoryboard (name: "UnassistedSitting", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsUnassistedSittingViewController
//      
//    case Test.TestNamesPresentable.reachingWhileSitting: // Sitting And Reaching
//      storyboardID = "WhyIsReachingWhileSittingStoryboardID"
//      var storyboard = UIStoryboard (name: "ReachingWhileSitting", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsReachingWhileSittingViewController
//
//    case Test.TestNamesPresentable.plasticJar: // Plastic Jar
//      storyboardID = "WhyIsPlasticJarStoryboardID"
//      var storyboard = UIStoryboard (name: "PlasticJar", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPlasticJarViewController
//      
//    case Test.TestNamesPresentable.completelyCoveredToy: // Plastic Jar
//      storyboardID = "WhyIsCompletelyCoveredToyStoryboardID"
//      var storyboard = UIStoryboard (name: "CompletelyCoveredToy", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsCompletelyCoveredToyViewController
//      
//    default: // Bring up the Milestones view controller in the default case
//      storyboardID = "MilestonesVCStoryboardID"
//      var storyboard = UIStoryboard (name: "Main", bundle: nil)
//      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! MilestonesViewController
//    }
//    
//    // Present the Why... view controller for the test associated with the local notification on top of the current topmost VC.
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    if let controller = controller {
//      if var topmostViewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
//        // walk VC stack to find topmost VC
//        while let presentedViewController = topmostViewController.presentedViewController {
//          topmostViewController = presentedViewController
//        }
//        // present new VC
//        dispatch_async(dispatch_get_main_queue()) {
//          topmostViewController.presentViewController(controller, animated: true, completion: nil);
//        }
//      }
//    }
    
    // decrement the app's badge icon count
    UIApplication.sharedApplication().applicationIconBadgeNumber -= 1
    
    // remove the local notification
    UIApplication.sharedApplication().cancelLocalNotification(localNotification)
    
    // Send a notification indicating that a reminder has been removed.
    BNLocalNotification.postTestReminderRemovedNotification(testName)
  }
  
  /*
  @brief Display the first view controller of the test identified by testName.
  @discussion It can legitimately be argued that a more pure separation of view and model would be to simply post an NSNotification here and leave it to any view controller having registered an observer for that NSNotification to take action upon receipt of the NSNotificatoin (by prompting the user or displaying the new view controller associated with the reminder local notification). However, I chose to walk the VC stack and present the view controller in this class function so that it was not necessary to register an NSNotification observer in a couple hunred view controllers. This looks like the correct tradeoff to me at this time.
  @param (in) testName - The name of the test to launch.
  */
  static func presentTestViewController(testName: String) {
    let testID = 0
    var storyboardID: String? = nil
    var controller : UIViewController? = nil
    
    switch testName {
      
    case Test.TestNamesPresentable.pupilResponse:  // Pupil Response
      storyboardID = "WhyIsPupilResponseStoryboardID"
      var storyboard = UIStoryboard (name: "Main", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPupilResponseViewController
      
    case Test.TestNamesPresentable.fallingToy: // Falling Toy
      storyboardID = "WhyIsObjectPermanenceStoryboardID"
      var storyboard = UIStoryboard (name: "Main", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsObjectPermanenceViewController
      
    case Test.TestNamesPresentable.letsCrawl: // Let's Crawl
      storyboardID = "WhyIsCrawlingViewControllerStoryboardID"
      var storyboard = UIStoryboard (name: "Main", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsCrawlingViewController
      
    case Test.TestNamesPresentable.pointFollowing: // Point Following
      storyboardID = "WhyIsPointFollowingStoryboardID"
      var storyboard = UIStoryboard (name: "PointFollowing", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPointFollowingViewController
      
    case Test.TestNamesPresentable.hearing: // Hearing
      storyboardID = "WhyIsHearingStoryboardID"
      var storyboard = UIStoryboard (name: "Hearing", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsHearingViewController
      
    case Test.TestNamesPresentable.crossingEyes: // Crossing Eyes
      storyboardID = "WhyIsCrossingEyesStoryboardID"
      var storyboard = UIStoryboard (name: "CrossingEyes", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsCrossingEyesViewController
      
    case Test.TestNamesPresentable.attentionAtDistance: // Attention at Distance
      storyboardID = "WhyIsAttentionAtDistanceStoryboardID"
      var storyboard = UIStoryboard (name: "AttentionAtDistance", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsAttentionAtDistanceViewController
      
    case Test.TestNamesPresentable.symmetry: // Symmetry
      storyboardID = "WhyIsSymmetryStoryboardID"
      var storyboard = UIStoryboard (name: "Symmetry", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsSymmetryViewController
      
    case Test.TestNamesPresentable.pincer: // Pincer
      storyboardID = "WhyIsPincerStoryboardID"
      var storyboard = UIStoryboard (name: "Pincer", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPincerViewController
      
    case Test.TestNamesPresentable.partiallyCoveredToy: // Partially Covered Toy
      storyboardID = "WhyIsPartiallyCoveredToyStoryboardID"
      var storyboard = UIStoryboard (name: "PartiallyCoveredToy", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPartiallyCoveredToyViewController
      
    case Test.TestNamesPresentable.selfRecognition: // Self Recognition
      storyboardID = "WhyIsSelfRecognitionStoryboardID"
      var storyboard = UIStoryboard (name: "SelfRecognition", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsSelfRecognitionController
      
    case Test.TestNamesPresentable.socialSmiling: // Social Smiling
      storyboardID = "WhyIsSocialSmilingStoryboardID"
      var storyboard = UIStoryboard (name: "SocialSmiling", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsSocialSmilingViewController
      
    case Test.TestNamesPresentable.facialMimic: // Facial Mimic
      storyboardID = "WhyIsFacialMimicStoryboardID"
      var storyboard = UIStoryboard (name: "FacialMimic", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsFacialMimicViewController
      
    case Test.TestNamesPresentable.unassistedSitting: // Unassisted Sitting
      storyboardID = "WhyIsUnassistedSittingStoryboardID"
      var storyboard = UIStoryboard (name: "UnassistedSitting", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsUnassistedSittingViewController
      
    case Test.TestNamesPresentable.reachingWhileSitting: // Sitting And Reaching
      storyboardID = "WhyIsReachingWhileSittingStoryboardID"
      var storyboard = UIStoryboard (name: "ReachingWhileSitting", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsReachingWhileSittingViewController
      
    case Test.TestNamesPresentable.plasticJar: // Plastic Jar
      storyboardID = "WhyIsPlasticJarStoryboardID"
      var storyboard = UIStoryboard (name: "PlasticJar", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPlasticJarViewController
      
    case Test.TestNamesPresentable.completelyCoveredToy: // Plastic Jar
      storyboardID = "WhyIsCompletelyCoveredToyStoryboardID"
      var storyboard = UIStoryboard (name: "CompletelyCoveredToy", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsCompletelyCoveredToyViewController
      
    default: // Bring up the Milestones view controller in the default case
      storyboardID = "MilestonesVCStoryboardID"
      var storyboard = UIStoryboard (name: "Main", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! MilestonesViewController
    }
    
    // Present the Why... view controller for the test associated with the local notification on top of the current topmost VC.
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    if let controller = controller {
      if var topmostViewController = UIApplication.sharedApplication().keyWindow?.rootViewController {
        // walk VC stack to find topmost VC
        while let presentedViewController = topmostViewController.presentedViewController {
          topmostViewController = presentedViewController
        }
        // present new VC
        dispatch_async(dispatch_get_main_queue()) {
          topmostViewController.presentViewController(controller, animated: true, completion: nil);
        }
      }
    }
  }
  
  /*!
  @brief Remove a local notification if the test was passed in the interim.
  @discussion If the local notification was previously scheduled, this function will remove it by searching all local notifications for the proper userInfo key containing the test's name.
  @param (in) testName - The name of the test whose local notification is to be deleted. Use a Test.TestNamesPresentable value. (cannot be nil)
  */
  static func removeLocalNotification(testName: String) {
    
    var theApp:UIApplication = UIApplication.sharedApplication()
    
    // Iterate through all local notifications to find one containing testName in the userInfo and delete it.
    for locNotif in theApp.scheduledLocalNotifications! {
      var notification = locNotif as UILocalNotification!
      let notificationUserInfo = notification.userInfo! as! [String:AnyObject]
      let notificationTestName = notificationUserInfo[BNLocalNotification.LocalNotificationInfoDictionaryTestNameKey]! as! String
      if notificationTestName == testName {
                // TODO: add profile name to the userInfo and only delete if same profile name
                //        in other words, the first child fails repeatedly, while the 2nd fails then passes. Only delete the notification belonging to the second child.
        
        // match! Cancel this local notification.
        theApp.cancelLocalNotification(notification)
        
        // Send a notification indicating that a reminder has been removed.
        BNLocalNotification.postTestReminderRemovedNotification(testName)
        break
      }
    }
  }
  
  /*!
  @brief Determine if a local notification exists that contains testName in userInfo.
  @param (in) testName - The name of the test to be found in the userInfo of a local notification. Use a Test.TestNamesPresentable value. (cannot be nil)
  @return Returns true if testName is found in the userInfo of a local notification, else returns false.
  */
  static func doesLocalNotificationExist(testName: String) -> Bool {
    
    // Iterate through all local notifications to find one containing testName in the userInfo.
    var theApp:UIApplication = UIApplication.sharedApplication()
    for locNotif in theApp.scheduledLocalNotifications! {
      
      var notification = locNotif as! UILocalNotification
      let notificationUserInfo = notification.userInfo! as! [String:AnyObject]
      let notificationTestName = notificationUserInfo[BNLocalNotification.LocalNotificationInfoDictionaryTestNameKey]! as! String
      
      if notificationTestName == testName {
        // TODO: add profile name to the userInfo and only delete if same profile name
        //        in other words, the first child fails repeatedly, while the 2nd fails then passes. Only delete the notification belonging to the second child.
        
        // Match! Found a local notification containing testName in userInfo.
        return true
      }
    }
    
    // No local notification was found containing testName in userInfo.
    return false
  }
  
  /*
  @brief Helper function to prompt user if they would like to run the test now.
  @param The notification.
  */
  static func showAlertForLocalNotification(notification: UILocalNotification) {
    
    let messageString = String(format:"%@ Select Ok to run the test now.", notification.alertBody!)
    var title = ""
    if #available(iOS 8.2, *) {
        if let a = notification.alertTitle {
          title = a
        }
    }
    let alert = UIAlertController(title: title, message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
      BNLocalNotification.handleLocalNotification(notification)
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
      // Cancelled alert. do nothing.
    }))
    
    let controller = getTopmostViewController()
    controller.presentViewController(alert, animated: true, completion: nil)
  }
  
  /*
  @brief Walk the view controller stack to find the topmost controller.
  @return the topmost view controller.
  */
  static func getTopmostViewController() -> UIViewController {
    
    var topmostViewController: UIViewController! = UIApplication.sharedApplication().keyWindow!.rootViewController
      
    while let presentedViewController = topmostViewController.presentedViewController {
      topmostViewController = presentedViewController
    }
    
    return topmostViewController
  }
  
  /*
  @brief Remove all local notifications from notification center, and remove the badge from the app.
  */
  static func clearAllLocalNotifications() {
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    UIApplication.sharedApplication().cancelAllLocalNotifications()
  }
  
  /*
  @brief post an NSNotification indicating that a test reminder has been scheduled.
  @discussion The test name is sent in the notification's userInfo.
  @param (in) testName - The name of the test for which the reminder has been scheduled. A Test.TestNamesPresentable value. (cannot be nil)
  */
  func postTestReminderScheduledNotification(testName: String) {
    var dataDict = [String : String] ()
    dataDict[testNameUserInfoKey] = testName
    NSNotificationCenter.defaultCenter().postNotificationName(testReminderScheduledNotificationKey, object: self, userInfo: dataDict)
  }
  
  /*
  @brief post an NSNotification indicating that a test reminder has been removed.
  @discussion The test name is sent in the notification's userInfo.
  @param (in) testName - The name of the test for which the reminder has been removed. A Test.TestNamesPresentable value. (cannot be nil)
  */
  static func postTestReminderRemovedNotification(testName: String) {
    var dataDict = [String : String] ()
    dataDict[testNameUserInfoKey] = testName
    NSNotificationCenter.defaultCenter().postNotificationName(testReminderRemovedNotificationKey, object: self, userInfo: dataDict)
  }
}