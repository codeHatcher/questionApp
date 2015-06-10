//
//  UIButtonNext.swift
//  questionApp
//
//  Created by Brown Magic on 6/10/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import UIKit

let omnesFont = UIFont(name: "Omnes", size: 30)
let orange = UIColor(red: 243/255, green: 108/255, blue: 43/255, alpha: 1.0)

class UIButtonNext: UIButton {

    override func drawRect(rect: CGRect) {
      self.setTitle("save profile", forState: UIControlState.Normal)
      self.titleLabel!.font = omnesFont
      self.setTitleColor(orange, forState: UIControlState.Normal)
      //self.titleLabel!.textColor = UIColor(red: 243.0/255.0, green: 108.0/255.0, blue: 43.0/255.0, alpha: 1.0)
      // self.setImage(UIImage(named: "startButton"), forState: UIControlState.Normal)
      self.setBackgroundImage(UIImage(named: "baseButton"), forState: UIControlState.Normal)
    }

}
