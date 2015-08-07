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

class BNLocalNotification {

  struct NotificationConstants {
    static var subject = "babynoggin Test Reminder"
    static var body = "It's time to retry the test."
    static var reminderBodyFormatted = "It's time to retry the %@ test."
    static var composerErrorTitle = "Error"
    static var composerErrorMessage = "Unable to schedule the reminder."
    static var defaultInterval: Double = 5 // TODO: Currently set to 5 seconds to support testing. Must change to the following 2 week interval for beta release: 14 * 24 * 60 * 60 = 1209600
    static var confirmedTitle = "All set!"
    static var confirmedMessage = "A notification has been scheduled when it is time to try the %@ test again in 2 weeks"
    static var button = "OK"
  }
  
  static let LocalNotificationInfoDictionaryTestNameKey = "NotificationTestName"
  
  /* Set testName to a TestNamesPresentable member to identify the test. (See the TestNamesPresentable struct at the top of this file.) This testName will be used in the Reminder presented to the user.
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
  
  @IBAction func scheduleNotification(sender: AnyObject) {
    
    var localNotification = UILocalNotification()
    
    // configure the title
    localNotification.alertTitle = NotificationConstants.subject
    
    // configure body
    if let testName = self.testName {
      var bodyString = String(format: NotificationConstants.reminderBodyFormatted, testName)
      localNotification.alertBody = bodyString
    } else {
      localNotification.alertBody = NotificationConstants.body
    }
    
    // add a badge
    localNotification.applicationIconBadgeNumber = 1
    

// TODO: get rid of this
//    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];
//    localNotif.userInfo = infoDict;
    
    // ask user for permission to display notifications
    acquireNotificationPermission()

    // TODO: specify the test in the userInfo property so the app knows which test to display when it is launched.
    let infoDictionary = [BNLocalNotification.LocalNotificationInfoDictionaryTestNameKey : Test.TestNames.hearing] // TODO: test name
    localNotification.userInfo = infoDictionary

    // schedule the notification
    localNotification.fireDate = NSDate(timeIntervalSinceNow: 5 /*TODO: switch to this --> elapsedSecondsBeforePresentingReminder*/)
    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    
    //presentConfirmationAlert()
  }
  
  /*
  @brief Ask the user for permission to register local notifications on this device.
  @discussion Registers UI, Sound, and Badge permissions for the notifications.
  */
  func acquireNotificationPermission() {
    
    let registerUserNotificationSettings = UIApplication.instancesRespondToSelector("registerUserNotificationSettings:")
    
    if registerUserNotificationSettings {
      var types: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound | UIUserNotificationType.Badge
      
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
  
  

//  static func parseLocalNotification(localNotification: UILocalNotification) {
//    
//    let testName = localNotification.userInfo![BNLocalNotification.LocalNotificationInfoDictionaryTestNameKey] as! String
//    handleNotificationSelection(testName)
//    
//    // remove the notification
//    UIApplication.sharedApplication().cancelLocalNotification(localNotification)
//  }
  
//    if true {
//
//    //if localNotification.userInfo!["UUID"] as! String == "bob" {
//    
////    let userinfo = localNotification.userInfo as NSDictionary
////
////    if let testName = userinfo?.valueForKey("bob") as? String {
//    
////    if let testName = userinfo[BNLocalNotification.LocalNotificationInfoDictionaryTestNameKey] as? String {
//      handleNotificationSelection(testName)
//
//    }
//  }
  
//  static func parseLocalNotification(launchOptions: [NSObject: AnyObject]?) {
//    if let options = launchOptions {
//      if let testName = options[BNLocalNotification.LocalNotificationInfoDictionaryTestNameKey] as? String {
//        println("testName extracted from local notification = \(testName)")
//        handleNotificationSelection(testName)
//      }
//    }
//  }
  
  /*
  @brief Display the first view controller of the test identified in the notification.
  @discussion It can legitimately be argued that a more pure separation of view and model would be to simply post an NSNotification here and leave it to any view controller having registered an observer for that NSNotification to take action upon receipt of the NSNotificatoin (by prompting the user or displaying the new view controller associated with the reminder local notification). However, I chose to walk the VC stack and present the view controller in this class function so that it was not necessary to register an NSNotification observer in a couple hunred view controllers. This looks like the correct tradeoff to me at this time.
  @param (in) localNotification - The local notification selected by the end user. It contains a userInfo dictionary identifying the test to launch.
  */
  static func handleLocalNotification(localNotification: UILocalNotification) {
    
    let testName = localNotification.userInfo![BNLocalNotification.LocalNotificationInfoDictionaryTestNameKey] as! String
    let testID = 0
    var storyboardID: String? = nil
    var controller : UIViewController? = nil
    
    switch testName {
    case Test.TestNames.pupilResponse:  // Pupil Response
      storyboardID = "WhyIsPupilResponseStoryboardID"
      var storyboard = UIStoryboard (name: "Main", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPupilResponseViewController
    case Test.TestNames.fallingToy: // Falling Toy
      storyboardID = "WhyIsObjectPermanenceStoryboardID"
      var storyboard = UIStoryboard (name: "Main", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsObjectPermanenceViewController
    case Test.TestNames.letsCrawl: // Let's Crawl
      storyboardID = "WhyIsCrawlingViewControllerStoryboardID"
      var storyboard = UIStoryboard (name: "Main", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsCrawlingViewController
    case Test.TestNames.pointFollowing: // Point Following
      storyboardID = "WhyIsPointFollowingStoryboardID"
      var storyboard = UIStoryboard (name: "PointFollowing", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPointFollowingViewController
    case Test.TestNames.hearing: // Hearing
      storyboardID = "WhyIsHearingStoryboardID"
      var storyboard = UIStoryboard (name: "Hearing", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsHearingViewController
    case Test.TestNames.crossingEyes: // Crossing Eyes
      storyboardID = "WhyIsCrossingEyesStoryboardID"
      var storyboard = UIStoryboard (name: "CrossingEyes", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsCrossingEyesViewController
    case Test.TestNames.attentionAtDistance: // Attention at Distance
      storyboardID = "WhyIsAttentionAtDistanceStoryboardID"
      var storyboard = UIStoryboard (name: "Main", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsAttentionAtDistanceViewController
    case Test.TestNames.symmetry: // Symmetry
      storyboardID = "WhyIsSymmetryStoryboardID"
      var storyboard = UIStoryboard (name: "Symmetry", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsSymmetryViewController
    case Test.TestNames.pincer: // Pincer
      storyboardID = "WhyIsPincerStoryboardID"
      var storyboard = UIStoryboard (name: "Pincer", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPincerViewController
    case Test.TestNames.partiallyCoveredToy: // Partially Covered Toy
      storyboardID = "WhyIsPartiallyCoveredToyStoryboardID"
      var storyboard = UIStoryboard (name: "PartiallyCoveredToy", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPartiallyCoveredToyViewController
    case Test.TestNames.selfRecognition: // Self Recognition
      storyboardID = "WhyIsSelfRecognitionStoryboardID"
      var storyboard = UIStoryboard (name: "SelfRecognition", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsSelfRecognitionController
    case Test.TestNames.socialSmiling: // Social Smiling
      storyboardID = "WhyIsSocialSmilingStoryboardID"
      var storyboard = UIStoryboard (name: "SocialSmiling", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsSocialSmilingViewController
    case Test.TestNames.FacialMimic: // Facial Mimic
      storyboardID = "WhyIsFacialMimicStoryboardID"
      var storyboard = UIStoryboard (name: "FacialMimic", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsFacialMimicViewController
    default: // TODO - probably best to bring up main screen in default case
      storyboardID = "WhyIsPupilResponseStoryboardID"
      var storyboard = UIStoryboard (name: "Main", bundle: nil)
      controller = storyboard.instantiateViewControllerWithIdentifier(storyboardID!) as! WhyIsPupilResponseViewController
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
    
    // decrement the app's badge icon count
    UIApplication.sharedApplication().applicationIconBadgeNumber -= 1
    
    // remove the local notification
    UIApplication.sharedApplication().cancelLocalNotification(localNotification)
  }
}