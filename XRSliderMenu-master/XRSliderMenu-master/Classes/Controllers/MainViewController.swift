//
//  MainViewController.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/2/23.
//  Copyright © 2016年 X.R. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let iconBtn = UIButton(frame: CGRectMake(2, 0, 38, 38))
        iconBtn.setImage(UIImage(named: "head.jpg"), forState: .Normal)
        iconBtn.layer.masksToBounds = true
        iconBtn.layer.cornerRadius = iconBtn.frame.width * 0.5
        
        let leftItem = UIBarButtonItem(customView: iconBtn)
        let seperatorItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        seperatorItem.width = iconBtn.frame.origin.x - 12.0
        
        self.navigationItem.leftBarButtonItems = [seperatorItem, leftItem]
        
        self.segmentControl.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: .Normal)
        self.segmentControl.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(red: 26 / 255.0, green: 184 / 255.0, blue: 242 / 255.0, alpha: 1.0)], forState: .Selected)
        self.segmentControl.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
