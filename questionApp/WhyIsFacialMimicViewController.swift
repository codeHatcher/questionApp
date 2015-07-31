//
//  WhyIsFacialMimicViewController.swift
//  questionApp
//
//  Created by john bateman on 7/29/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

class WhyIsFacialMimicViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //applyTextAttributesToLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Helper function formats text attributes for multiple substrings in label.
    func applyTextAttributesToLabel() {
        
        let string = "Facial mimicry, or empathetic response, is normal in infants. Babies who do not mimic facial expressions are more likely to be autistic or even psychopathic."
        
        var attributedString = NSMutableAttributedString(string: string)
        
        let boldAttributes = [NSForegroundColorAttributeName: kGrey, NSFontAttributeName: UIFont(name: kOmnesFontSemiBold, size: 22)!]
        let standardAttributes = [NSForegroundColorAttributeName: kGrey, NSFontAttributeName: UIFont(name: kOmnesFontMedium, size: 22)!]
        
        attributedString.addAttributes(standardAttributes, range: NSMakeRange(0, 73))
        attributedString.addAttributes(boldAttributes, range: NSMakeRange(73, 31))
        attributedString.addAttributes(standardAttributes, range: NSMakeRange(104, 53))
        
        descriptionLabel.attributedText = attributedString
    }
}
