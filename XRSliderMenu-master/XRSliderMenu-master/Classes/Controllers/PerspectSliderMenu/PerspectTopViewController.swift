//
//  PerspectTopViewController.swift
//  XRSliderMenu-master
//
//  Created by xuran on 16/12/9.
//  Copyright © 2016年 X.R. All rights reserved.
//

/// 顶部视图控制器

import UIKit

@objc protocol PerspectTopViewControllerDelegate: NSObjectProtocol {
    
    @objc func didTapSettingItem()
    @objc func didTapViewControllerAnywhere()
}

class PerspectTopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    weak var delegate: PerspectTopViewControllerDelegate?
    
    @IBAction func settingBtnAction(_ sender: UIButton) {
        
        if delegate != nil && delegate!.responds(to: #selector(PerspectTopViewControllerDelegate.didTapSettingItem)) {
            delegate!.didTapSettingItem()
        }
    }
    
    func tapGestureAction(tapGesture: UITapGestureRecognizer) {
        
        if delegate != nil && delegate!.responds(to: #selector(PerspectTopViewControllerDelegate.didTapViewControllerAnywhere)) {
            delegate!.didTapViewControllerAnywhere()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTableView.backgroundColor = UIColor.white
        self.myTableView.separatorColor = RGBColor(220, g: 220, b: 220)
        self.myTableView.layoutMargins = UIEdgeInsetsMake(0, 60.0, 0, 0)
        self.myTableView.separatorInset = UIEdgeInsetsMake(0, 60.0, 0, 0)
        self.myTableView.register(UINib(nibName: "MessageCell", bundle: Bundle.main), forCellReuseIdentifier: "MessageCell")
        let headerVw = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100.0))
        headerVw.backgroundColor = UIColor.yellow
        self.myTableView.tableHeaderView = headerVw
        self.myTableView.tableFooterView = UIView()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction(tapGesture:)))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
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
