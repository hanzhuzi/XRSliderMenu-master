//
//  MainViewController.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/2/23.
//  Copyright © 2016年 X.R. All rights reserved.
//

import UIKit

// RGB Color
func RGBColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var myTableView: UITableView!
    
    var tapHeaderClosure: ((UIButton?) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let iconBtn = UIButton(frame: CGRectMake(2, 0, 38, 38))
        iconBtn.setImage(UIImage(named: "head.jpg"), forState: .Normal)
        iconBtn.layer.masksToBounds = true
        iconBtn.layer.cornerRadius = iconBtn.frame.width * 0.5
        iconBtn.addTarget(self, action: "tapHeadAction:", forControlEvents: .TouchUpInside)
        
        let leftItem = UIBarButtonItem(customView: iconBtn)
        let seperatorItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        seperatorItem.width = iconBtn.frame.origin.x - 12.0
        
        self.navigationItem.leftBarButtonItems = [seperatorItem, leftItem]
        
        self.segmentControl.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: .Normal)
        self.segmentControl.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(red: 26 / 255.0, green: 184 / 255.0, blue: 242 / 255.0, alpha: 1.0)], forState: .Selected)
        self.segmentControl.tintColor = UIColor.whiteColor()
        
        self.myTableView.backgroundColor = UIColor.whiteColor()
        self.myTableView.separatorColor = RGBColor(220, g: 220, b: 220)
        self.myTableView.layoutMargins = UIEdgeInsetsMake(0, 60.0, 0, 0)
        self.myTableView.separatorInset = UIEdgeInsetsMake(0, 60.0, 0, 0)
        self.myTableView.registerNib(UINib(nibName: "MessageCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "MessageCell")
        self.myTableView.tableFooterView = UIView()
        let searchBar = UISearchBar(frame: CGRectMake(20, 5, self.myTableView.frame.width - 40.0, 40.0))
        searchBar.backgroundColor = UIColor.whiteColor()
        searchBar.searchBarStyle = .Minimal
        searchBar.placeholder = "搜索"
        self.myTableView.tableHeaderView = searchBar
    }
    
    func tapHeadAction(btn: UIButton) {
        if self.tapHeaderClosure != nil {
            self.tapHeaderClosure(btn)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as? MessageCell
        
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("MessageCell", owner: nil, options: nil).last as? MessageCell
        }
        
        cell?.selectionStyle = .Gray
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
}

