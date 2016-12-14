//
//  MainViewController.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/2/23.
//  Copyright © 2016年 X.R. All rights reserved.
//

import UIKit

// RGB Color
func RGBColor(_ r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var myTableView: UITableView!
    
    var tapHeaderClosure: ((UIButton?) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let iconBtn = UIButton(frame: CGRect(x: 2, y: 0, width: 38, height: 38))
        iconBtn.setImage(UIImage(named: "head.jpg"), for: UIControlState())
        iconBtn.layer.masksToBounds = true
        iconBtn.layer.cornerRadius = iconBtn.frame.width * 0.5
        iconBtn.addTarget(self, action: #selector(MainViewController.tapHeadAction(_:)), for: .touchUpInside)
        
        let leftItem = UIBarButtonItem(customView: iconBtn)
        let seperatorItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        seperatorItem.width = iconBtn.frame.origin.x - 12.0
        
        self.navigationItem.leftBarButtonItems = [seperatorItem, leftItem]
        
        self.segmentControl.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: UIControlState())
        self.segmentControl.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor(red: 26 / 255.0, green: 184 / 255.0, blue: 242 / 255.0, alpha: 1.0)], for: .selected)
        self.segmentControl.tintColor = UIColor.white
        
        self.myTableView.backgroundColor = UIColor.white
        self.myTableView.separatorColor = RGBColor(220, g: 220, b: 220)
        self.myTableView.layoutMargins = UIEdgeInsetsMake(0, 60.0, 0, 0)
        self.myTableView.separatorInset = UIEdgeInsetsMake(0, 60.0, 0, 0)
        self.myTableView.register(UINib(nibName: "MessageCell", bundle: Bundle.main), forCellReuseIdentifier: "MessageCell")
        self.myTableView.tableFooterView = UIView()
        let searchBar = UISearchBar(frame: CGRect(x: 20, y: 5, width: self.myTableView.frame.width - 40.0, height: 40.0))
        searchBar.backgroundColor = UIColor.white
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "搜索"
        self.myTableView.tableHeaderView = searchBar
    }
    
    func tapHeadAction(_ btn: UIButton) {
        if self.tapHeaderClosure != nil {
            self.tapHeaderClosure(btn)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? MessageCell
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed("MessageCell", owner: nil, options: nil)?.last as? MessageCell
        }
        
        cell?.selectionStyle = .gray
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

