//
//  MenuViewController.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/2/23.
//  Copyright © 2016年 X.R. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var headImage: UIImageView!
    
    // 点击tableViewCell的回调
    var tapTableClosure: ((NSIndexPath) -> Void)!
    
    var titleArray: [String] = ["开通会员", "QQ钱包", "个性装扮", "我的收藏", "我的相册", "我的文件"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backImageView.image = UIImage(named: "back")
        self.headImage.layer.cornerRadius = 25.0
        self.headImage.clipsToBounds = true
        self.headImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.headImage.layer.borderWidth = 1.5
        
        self.myTableView.registerNib(UINib(nibName: "MyCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "MyCell")
        self.myTableView.separatorStyle = .None
        self.myTableView.backgroundColor = UIColor.clearColor()
        let footerVw = NSBundle.mainBundle().loadNibNamed("MessageFooterView", owner: nil, options: nil).last as? MessageFooterView
        footerVw?.backgroundColor = UIColor.clearColor()
        self.myTableView.tableFooterView = footerVw
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var myCell = tableView.dequeueReusableCellWithIdentifier("MyCell") as? MyCell
        
        if myCell == nil {
            myCell = NSBundle.mainBundle().loadNibNamed("MyCell", owner: nil, options: nil).last as? MyCell
        }
        
        myCell?.selectionStyle = .None
        myCell?.logoImageView.image = UIImage(named: "qq")
        myCell?.titleLabel.text = self.titleArray[indexPath.row]
        
        return myCell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.tapTableClosure != nil {
            self.tapTableClosure(indexPath)
        }
    }
}
