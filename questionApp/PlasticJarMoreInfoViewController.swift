//
//  PlasticJarMoreInfoViewController.swift
//  questionApp
//
//  Created by Daniel Hsu on 8/7/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

class PlasticJarMoreInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onCloseButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
