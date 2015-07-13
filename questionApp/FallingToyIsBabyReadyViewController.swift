//
//  FallingToyIsBabyReadyViewController.swift
//  questionApp
//
//  Created by john bateman on 7/8/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

class FallingToyIsBabyReadyViewController: UIViewController {

    @IBOutlet weak var dontShowAgainButton: BNButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func onBackButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onNextStepButtonTap(sender: AnyObject) {
        performSegueWithIdentifier("fallingToyTimeToTestSegueID", sender: self)
    }
    
    @IBAction func onDontShowAgainButtonTap(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "dontShowIsBabyReady")
        performSegueWithIdentifier("fallingToyTimeToTestSegueID", sender: self)
    }
}